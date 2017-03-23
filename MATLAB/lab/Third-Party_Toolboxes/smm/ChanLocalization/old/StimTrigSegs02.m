function StimTrigSegs02(filebase,beginTime,endTime,stimLag,nchannels,trigChan,notes)

chanInfoDir = 'ChanInfo/';
datsampl=20000;
segLen = 200;
data = readmulti([filebase '/' filebase '.dat'],nchannels,trigChan);
%plotData = readmulti([filebase '.dat'],nchannels,plotChan);
selChans = load([chanInfoDir 'SelectedChannels.eeg.txt']);
% calculate stim peaks
timewindow = 0.0188; %seconds
winheight = 20000;
stimindex = 1;
stims = [];
bps = 2;
figure(1)
for i=beginTime*datsampl:stimLag*datsampl:min(endTime*datsampl-stimLag*datsampl,length(data(:,1))-stimLag*datsampl)
    clf;
    subplot(length(selChans)+1,1,1)
    localmin = i-1 + find(data(i:i+stimLag*datsampl-1,1)==min(data(i:i+stimLag*datsampl-1,1)));
    localmax = i-1 + find(data(i:i+stimLag*datsampl-1,1)==max(data(i:i+stimLag*datsampl-1,1)));
    hold on
    plot(data((localmax(1)-timewindow*datsampl):(localmax(1)+timewindow*datsampl),1));
    plot([timewindow*datsampl timewindow*datsampl],[-winheight -0.75*winheight],'r')
    plot([timewindow*datsampl timewindow*datsampl],[winheight 0.75*winheight],'r')
    set(gca,'ylim',[-winheight winheight],'xlim',[1 timewindow*2*datsampl]);
    
    plotData = bload([filebase '/' filebase '.dat'],[nchannels timewindow*2*datsampl],(localmax(1)-timewindow*datsampl)*nchannels*bps);
   for j=1:length(selChans)
        subplot(length(selChans)+1,1,j+1)
        hold on
        plot(plotData(selChans(j),:));
        plot([timewindow*datsampl timewindow*datsampl],[-winheight -0.75*winheight],'r')
        plot([timewindow*datsampl timewindow*datsampl],[winheight 0.75*winheight],'r')
        set(gca,'ylim',[-winheight winheight],'xlim',[1 timewindow*2*datsampl]);
    end
   
    keyin = input('record stim time? y/[n]', 's');
    if keyin == 'y'
        stims(stimindex) = localmax(1);
        stimindex = stimindex + 1;
    end    
    %end
end
keyin = input('are these stim times good? y/[n]', 's');
if keyin == 'n'
    return
end

extrapEegBool = 1;

 fileExt = '.eeg';
    chanMat = LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']);
    badChans = load([chanInfoDir 'BadChan' fileExt '.txt']);

datSegs = [];
interp1CSD = [];
interp121CSD = [];
    csdSmooth = [1];
csdChanMat1 = LoadVar([chanInfoDir 'ChanMat_NearAveCSD' RmTextSpaces(num2str(csdSmooth)) '.csd.mat']);
csdBadChans1 = load([chanInfoDir 'BadChan_NearAveCSD' RmTextSpaces(num2str(csdSmooth)) '.csd.txt']);
    csdSmooth = [1 2 1];
csdChanMat121 = LoadVar([chanInfoDir 'ChanMat_LinNearCSD' RmTextSpaces(num2str(csdSmooth)) '.csd.mat']);
csdBadChans121 = load([chanInfoDir 'BadChan_LinNearCSD' RmTextSpaces(num2str(csdSmooth)) '.csd.txt']);
for j=1:length(stims)
    datSegs(:,:,j) = bload([filebase '.dat'],[nchannels timewindow*datsampl],stims(j)*nchannels*bps);
    
    interpEEG = InterpNearAve1D(datSegs(:,:,j),chanMat,badChans);
    csdData = CSD1D(interpEEG,{mat2cell(chanMat,size(chanMat,1),repmat(1,size(chanMat,2),1)),csdSmooth});
    interp1CSD(:,:,j) = InterpNearAve1D(csdData,csdChanMat1,csdBadChans1);

    interpEEG = InterpLinExtrapNear(datSegs(:,:,j),chanMat,badChans,extrapEegBool);
    csdData = CSD1D(interpEEG,{mat2cell(chanMat,size(chanMat,1),repmat(1,size(chanMat,2),1)),csdSmooth});
    interp121CSD(:,:,j) = InterpLinExtrapNear(csdData,csdChanMat121,csdBadChans121);
end

time = stims/datsampl;
infoStruct.fileBase = filebase;
infoStruct.nChan = nchannels;
infoStruct.beginTime = beginTime;
infoStruct.endTime = endTime;
infoStruct.stimLag = stimLag;
infoStruct.trigChan = trigChan;
infoStruct.datSamp = datsampl;
infoStruct.segLen = segLen;

infoStruct.chanMat = chanMat;
infoStruct.badChans = badChans;
infoStruct.csdSmooth = 0;
infoStruct.interpMethod = '';
infoStruct.extrapEegBool = extrapEegBool;
segs = datSegs;
save([filebase '/' 'StimTrigSegs_' notes '_TrigChan' num2str(trigChan) '.dat.mat'],SaveAsV6,'segs','time','infoStruct');

infoStruct.chanMat = csdChanMat1;
infoStruct.badChans = csdBadChans1;
infoStruct.csdSmooth = [1];
infoStruct.interpMethod = 'NearAve';
infoStruct.extrapEegBool = extrapEegBool;
segs = interp1CSD;
save([filebase '/' 'StimTrigSegs_' notes '_TrigChan' num2str(trigChan) '_NearAveCSD1.csd.mat'],SaveAsV6,'segs','time','infoStruct');

infoStruct.chanMat = csdChanMat121;
infoStruct.badChans = csdBadChans121;
infoStruct.csdSmooth = [1 2 1];
infoStruct.interpMethod = 'LinNear';
infoStruct.extrapEegBool = extrapEegBool;
segs = interp121CSD;
save([filebase '/' 'StimTrigSegs_' notes '_TrigChan' num2str(trigChan) '_LinNearCSD121.csd.mat'],SaveAsV6,'segs','time','infoStruct');
return
