% function RippTrigNormSegs(fileBaseCell,fileName,rippFileName,fileExt,varargin)
% [plotBool] = DefaultArgs(varargin,{0});
function RippTrigNormSegs(fileBaseCell,fileName,rippFileName,fileExt,varargin)
[plotBool] = DefaultArgs(varargin,{0});

for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j};
    
    clear infoStruct;
    clear segs;
    clear time;
    clear timeExc;
    clear timeInc;
    
    load([fileBaseCell{j} '/' rippFileName fileExt '.mat']);
    infoStruct.RippTrippNormSegs = mfilename;
    infoStruct.RippTrigSegName = rippFileName;
%     infoStruct.normTimeOffset = normTimeOffset;
    rippTimes = time;
    segLen = infoStruct.segLen;
    normTimeOffset = segLen*2/1000;
    eegSamp = infoStruct.sampRate;
    nChan = infoStruct.nChan;
    
    
    time = rippTimes + normTimeOffset;
     tempTimes = FurcateData(rippTimes,time,'round');
    time = time(abs(tempTimes-time) >= abs(normTimeOffset)-normTimeOffset*0.01);
    
    % get the seg
    eegFileLen = dir([fileBase '/' fileBase fileExt]);
    eegFileLen = eegFileLen.bytes;
    rmInd = [];
    segs = [];
    for i=1:length(time)
        if round((time(i)-segLen/1000/2)*eegSamp*nChan*2) >= 0
            bloadTime = clip(round((time(i)-segLen/1000/2)*eegSamp*nChan*2),0,eegFileLen);
            seg = bload([fileBase '/' fileBase fileExt],[nChan round(segLen*eegSamp/1000)],...
               bloadTime,'int16');
            if isempty(segs) | size(seg,2) == size(segs,2) % if didn't run off edge of file
                segs = cat(3,segs,seg);
            else
                rmInd = cat(1,rmInd,i);
            end
        else
            rmInd = cat(1,rmInd,i);
        end
    end
    time(rmInd) = [];
     
   if plotBool
        figure(1)
        hold on
        plot([rippTimes rippTimes+segLen/1000]',repmat([1 1], size(rippTimes))','r');
        PlotVertLines(rippTimes,[0 2],'r')
        PlotVertLines(rippTimes+segLen/1000,[0 2],'r')
        plot([time time+segLen/1000]',repMat([1.5 1.5], size(time))','b');
   end

    outName = [fileBase '/' fileName fileExt '.mat'];
    fprintf('Saving: %s\n',outName);

    save(outName,SaveAsV6,'segs','time','rippTimes','timeInc','timeExc','infoStruct');
end
   
    
    