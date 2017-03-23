function CalcPowSpeedAccel(fileBaseMat,nChan,channels,varargin)
%function CalcPowSpeedAccel(fileBaseMat,nChan,channels,eegSamp,winLength,nOverlap,NW,whlSamp,pixPerCm)
%function CalcPowSpeedAccel(fileBaseMat,nChan,channels,varargin)
%[eegSamp,winLength,nOverlap,NW,whlSamp,pixPerCm] = DefaultArgs(varargin,{1250,1250,0,2,39.065,20.58/11});
[eegSamp,winLength,nOverlap,NW,whlSamp,pixPerCm] = DefaultArgs(varargin,{1250,1250,0,2,39.065,20.58/11});

whlWinLength = winLength/eegSamp*whlSamp;
hanfilter = hanning(floor(whlWinLength));
hanfilter = hanfilter./mean(hanfilter);
    
%pixPerCm =  423/121.5; % McN pix/cm

for i=1:size(fileBaseMat,1)
    whldat = load([fileBaseMat(i,:) '.whl']);
    [whlSpeed whlAccel] = MazeSpeedAccel(whldat,pixPerCm);
    eeg = readmulti([fileBaseMat(i,:) '.eeg'],nChan,channels);
    
    [yo, fo, to] = mtpsg(eeg,winLength*4,eegSamp,winLength,nOverlap,NW);
    
 
    speed = -1*ones(size(to));
    for j=1:length(to)
        try
            whlSpeedSeg = hanfilter.*whlSpeed(round((j-1)*whlWinLength+1):round((j-1)*whlWinLength+length(hanfilter)));
        catch
            keyboard
        end
        indexes = find(whlSpeedSeg >= 0);
        if isempty(indexes)
            speed(j) = -1;
        else
            speed(j) = mean(whlSpeedSeg(indexes));
            %whlSpeedSeg(indexes)
        end
    end
    outName = [fileBaseMat(i,:) '_Speed_mtSpect_Win_' num2str(winLength) '_NW_' num2str(NW) '.mat'];
    fprintf('\nSaving: %s\n',outName);
    matlabVersion = version;
    if str2num(matlabVersion(1)) > 6
        save(outName,'-V6','yo','fo','to','speed','channels');
    else
        save(outName,'yo','fo','to','speed','channels');
    end
end
return


whl(1:1+skipWhl,1) = -1;
whl(1:1+skipWhl,2) = -1;
whl(end-skipWhl:end,1) = -1;
whl(end-skipWhl:end,2) = -1;
