function calcAndSaveSpectrogram(filebase,fileext,nchannels,channelNums,nFFT,Fs,WinLength,NW,trialsPerFile)

if ~exist('trialsPerFile', 'var') | isempty(trialsPerFile)
    trialsPerFile = 1000;
end

bps = 2; % bytes per sample

whldat = load([filebase '.whl']);
[whlm n] = size(whldat);

infoStruct = dir([filebase fileext]);
eegm = infoStruct.bytes/nchannels/bps;

eegWhlFactor = eegm/whlm;
yData = [];
for i=1:whlm
    eegData = bload([filebase fileext],[nchannels WinLength],max(0,nchannels*round(eegWhlFactor*i-WinLength/2)*bps),'int16');
    yChan = [];
    for j=1:length(channelNums)
        [y f] = mtcsd(eegData(channelNums(j),:),nFFT,Fs,WinLength,0,NW);
        f = f(find(f<150));
        y = y(1:length(f));
        yChan = [yChan y];
    end
    yData = cat(3,yData,yChan);
    if mod(i,trialsPerFile) == 0;
        outFileName = [filebase fileext '_SpectraPerPos'  num2str(i+1-trialsPerFile) '-' ...
            num2str(i) '_Win' num2str(WinLength) '_NW' num2str(NW) '.mat'];
        save(outFileName, 'yData', 'f', 'channelNums','nFFT','Fs','WinLength','NW');
        yData = [];
    end
end
outFileName = [filebase fileext '_SpectraPerPos'  num2str(whlm+1-mod(whlm,trialsPerFile)) '-' ...
    num2str(whlm) '_Win' num2str(WinLength) '_NW' num2str(NW) '.mat'];
save(outFileName, 'yData', 'f', 'channelNums');

