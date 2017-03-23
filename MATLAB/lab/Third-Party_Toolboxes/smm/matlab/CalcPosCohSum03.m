function [sumPerPosStruct] = CalcPosCohSum03(taskType,fileBaseCell,fileExt,fileNameFormat,nChan,refChan,...
    winLength,aveLength,freqRange,autoSave,trialTypesBool,mazeLocationsBool)
% function [sumPerPosCell,fo,channelNums] = CalcMazeSpectrogram(taskType,fileBaseCell,fileExt,fileNameFormat,Channels,winLength,nOverlap,NW,dbBool,autoSave,trialTypesBool,mazeLocationsBool)
% Loads files containing power spectra for each point in time that
% corresponds to a position in the .whl file. These spectra are Accumulated
% for each position contained in a _LinearizedWhl.mat. The Accumulated
% power spectra can then be used to plot positional spectrograms.
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
spectrogramDir = './';

maxMazeY = 240;
maxMazeX = 368;
whlSamp = 39.065;

yFreqPos = zeros(maxMazeX,maxMazeY,nChan);
nPerPos = zeros(maxMazeX,1);

figure(2)
clf
hold on
cwd = pwd;
for h=1:length(fileBaseCell);
    cd(fileBaseCell{h})
    whlDat = LoadMazeTrialTypes(fileBaseCell{h},trialTypesBool,mazeLocationsBool,1);
    notMinusOnes = find(whlDat(:,1) ~= -1);
    whlDat = ceil(whlDat);

    if isempty(notMinusOnes)
        %fprintf(': empty')
    else

        nPerPos = Accumulate(whlDat(notMinusOnes,[1:2]),1,[maxMazeX maxMazeY]);
        spectraFileName = [spectrogramDir fileBaseCell{h} '_' num2str(freqRange(1)) '-'...
            num2str(freqRange(2))  'Hz_Win' num2str(winLength) '_Ave' num2str(aveLength) fileExt...
            '_ref' num2str(refChan) '.10000coh' ];
            fprintf('\nReading: %s',spectraFileName);
        coh = ATanCoh(bload(spectraFileName,[nChan inf])/10000);

        for k=1:nChan
            yFreqPos(:,:,k) = Accumulate(whlDat(notMinusOnes,[1:2]),...
                coh(k,notMinusOnes),[maxMazeX maxMazeY]);
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
        plot(whlDat(round((floor((notMinusOnes-1)/whlSamp+1)-1)*whlSamp+1),1),whlDat(round((floor((notMinusOnes-1)/whlSamp+1)-1)*whlSamp+1),2),'r.');
        
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
    outname = [taskType '_' fileNamesInfo ...
        fileExt '_ref' num2str(refChan) '_' num2str(freqRange(1)) '-' num2str(freqRange(2))...
        'Hz_Win' num2str(winLength) '_pos_coh_sum.mat'];
    
    sumPerPosStruct = [];
    sumPerPosStruct = setfield(sumPerPosStruct,'posSum',pos_sum);
    sumPerPosStruct = setfield(sumPerPosStruct,'powSum',pow_sum);
    sumPerPosStruct = setfield(sumPerPosStruct,'info','trialsMat',trialsmat);
    sumPerPosStruct = setfield(sumPerPosStruct,'info','fileBaseCell',fileBaseCell);
    sumPerPosStruct = setfield(sumPerPosStruct,'info','freqRange',freqRange);
    sumPerPosStruct = setfield(sumPerPosStruct,'info','fileExt',fileExt);
    sumPerPosStruct = setfield(sumPerPosStruct,'info','nChan',nChan);
    sumPerPosStruct = setfield(sumPerPosStruct,'info','refChan',refChan);
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
