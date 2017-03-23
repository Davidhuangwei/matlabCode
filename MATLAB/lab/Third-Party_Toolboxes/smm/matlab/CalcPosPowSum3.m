% function [sumPerPosStruct,fo,channelNums] = CalcPosPowSum3(taskType,fileBaseCell,fileExt,fileNameFormat,Channels,...
%     winLength,nOverlap,NW,freqRange,peakBool,autoSave,trialTypesBool,mazeLocationsBool)
function [sumPerPosStruct,fo,channelNums] = CalcPosPowSum3(taskType,fileBaseCell,fileExt,fileNameFormat,Channels,...
    winLength,nOverlap,NW,freqRange,peakBool,autoSave,trialTypesBool,mazeLocationsBool)

if ~exist('trialTypesBool','var') | isempty(trialTypesBool)
    trialTypesBool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                   % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
end
if ~exist('mazeLocationsBool','var') | isempty(mazeLocationsBool)
    mazeLocationsBool = [0  0  0  1  1  1   1   1   1];
                      % rp lp dp cp ca rca lca rra lra
end
 
if ~exist('autoSave','var') | isempty(autoSave)
    autoSave = 1;
end
 if ~exist('fileNameFormat','var') | isempty(fileNameFormat)
    fileNameFormat = 2;
 end
 if ~exist('dbBool','var') | isempty(dbBool)
    dbBool = 0;
 end
spectrogramDir = 'spectrograms/';

maxMazeY = 240;
maxMazeX = 368;
whlSamp = 39.065;

yFreqPos = zeros(maxMazeX,maxMazeY,length(Channels));
nPerPos = zeros(maxMazeX,1);

figure(2)
clf
hold on

for h=1:length(fileBaseCell);
    cd(fileBaseCell{h})
    whlDat = LoadMazeTrialTypes(fileBaseCell{h},trialTypesBool,mazeLocationsBool,1);
    notMinusOnes = find(whlDat(:,1) ~= -1);
    whlDat = ceil(whlDat);

    if isempty(notMinusOnes)
        %fprintf(': empty')
    else

        nPerPos = Accumulate(whlDat(notMinusOnes,[1:2]),1,[maxMazeX maxMazeY]);
        for k=1:length(Channels)
            spectraFileName = [spectrogramDir fileBaseCell{h} fileExt 'Win' num2str(winLength) ...
                'Ovrlp' num2str(nOverlap) 'NW' num2str(NW) '_mtpsg_' num2str(Channels(k)) '.mat'];
            if k==1
                fprintf('\nReading: %s',spectraFileName);
            end
            load(spectraFileName);
            toSamp = 1/median(diff(to));
            if peakBool
                yFreqPos(:,:,k) = Accumulate(whlDat(notMinusOnes,[1:2]),...
                    max(yo(find(fo>=freqRange(1) & fo<=freqRange(2)),floor((notMinusOnes-1)/whlSamp*toSamp+1)),[],1),[maxMazeX maxMazeY]);
            else
                yFreqPos(:,:,k) = Accumulate(whlDat(notMinusOnes,[1:2]),...
                    sum(yo(find(fo>=freqRange(1) & fo<=freqRange(2)),floor((notMinusOnes-1)/whlSamp*toSamp+1)),1),[maxMazeX maxMazeY]);
            end
            
        end
        
        %end
        %end
        %if ~exist('sumYFreqPos','var')
        %    sumYFreqPos = zeros(length(fo),maxMazeX,length(Channels));
        %    sumNperPos = zeros(maxMazeX,1);
        %end
        %if isfield(sumPerPosStruct,mazeRegionNames{m})
        %    sumPerPosStruct = setfield(sumPerPosStruct,mazeRegionNames{m},'nPerPos', ...
        %        getfield(sumPerPosStruct,mazeRegionNames{m},'nPerPos') + nPerPos);
        %    sumPerPosStruct = setfield(sumPerPosStruct,mazeRegionNames{m},'yFreqPos', ...
        %        getfield(sumPerPosStruct,mazeRegionNames{m},'yFreqPos') + yFreqPos);
        %else
        %    sumPerPosStruct = setfield(sumPerPosStruct,mazeRegionNames{m},'nPerPos',nPerPos);
        %    sumPerPosStruct = setfield(sumPerPosStruct,mazeRegionNames{m},'yFreqPos',yFreqPos);
        %end
        if ~exist('pos_sum','var')
            pos_sum = nPerPos;
            pow_sum = yFreqPos;
        else
            pos_sum = pos_sum + nPerPos;
            pow_sum = pow_sum + yFreqPos;
        end
        figure(1)
        clf
        imagesc(pos_sum)
        colorbar
        figure(2)
        plot(whlDat(notMinusOnes,1),whlDat(notMinusOnes,2),'.');
        plot(whlDat(round((floor((notMinusOnes-1)/whlSamp*toSamp+1)-1)*whlSamp/toSamp+1),1),whlDat(round((floor((notMinusOnes-1)/whlSamp*toSamp+1)-1)*whlSamp/toSamp+1),2),'r.');
        
        %keyboard
        %sumPerPosCell{m,2} = sumPerPosCell{m,2} + nPerPos;
        %sumPerPosCell{m,3} = sumPerPosCell{m,3} + yFreqPos;
        %sumNperPos = sumNperPos + nPerPos;
        %            sumYFreqPos = sumYFreqPos + yFreqPos;

        if max(max(max(pow_sum))) >= 2^63
            fprintf('summation approaching 2^64 bit limit');
            keyboard
        end
    end
    cd ..
end


i = 'y';
if (autoSave == 0)
    while 1,
        i = input('Save to disk (yes/no)? ', 's');
        if strcmp(i,'yes') | strcmp(i,'no'), break; end
    end
end
if i(1) == 'n'
    CountTrialTypes(fileBaseCell,1);
    return;
else
    trialsmat = CountTrialTypes(fileBaseCell,1);   
    fileNamesInfo = GetFileNamesInfo(fileBaseCell,fileNameFormat);
    peak = [];
    if peakBool
        peak = '_peak';
    end
    outname = [taskType '_' fileNamesInfo ...
        fileExt '_' num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz_Win' num2str(winLength) '_NW' num2str(NW) peak '_pos_pow_sum.mat'];
    
    sumPerPosStruct = [];
    sumPerPosStruct = setfield(sumPerPosStruct,'posSum',pos_sum);
    sumPerPosStruct = setfield(sumPerPosStruct,'powSum',pow_sum);
    sumPerPosStruct = setfield(sumPerPosStruct,'info','trialsMat',trialsmat);
    sumPerPosStruct = setfield(sumPerPosStruct,'info','fileBaseCell',fileBaseCell);
    sumPerPosStruct = setfield(sumPerPosStruct,'info','freqRange',freqRange);
    sumPerPosStruct = setfield(sumPerPosStruct,'info','NW',NW);
    sumPerPosStruct = setfield(sumPerPosStruct,'info','nOverlap',nOverlap);
    sumPerPosStruct = setfield(sumPerPosStruct,'info','fileExt',fileExt);
    sumPerPosStruct = setfield(sumPerPosStruct,'info','peakBool',peakBool);
    sumPerPosStruct = setfield(sumPerPosStruct,'info','channels',Channels);
    sumPerPosStruct = setfield(sumPerPosStruct,'info','outName',outname);
    sumPerPosStruct = setfield(sumPerPosStruct,'info','taskType',taskType);
    sumPerPosStruct = setfield(sumPerPosStruct,'info','trialTypesBool',trialTypesBool);
    sumPerPosStruct = setfield(sumPerPosStruct,'info','mazeLocationsBool',mazeLocationsBool);
    sumPerPosStruct = setfield(sumPerPosStruct,'info','fileNameFormat',fileNameFormat);

    fprintf('Saving %s\n', outname);
    matlabVersion = version;
    if str2num(matlabVersion(1)) > 6
        save(outname,'-V6','sumPerPosStruct');
    else
        save(outname,'sumPerPosStruct');
    end
end
return;
