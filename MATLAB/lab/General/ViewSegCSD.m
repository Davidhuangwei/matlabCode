%% ViewSegCSD(filename,chnum,csdchannels,segment,csdstep,filter)
% chnum - number of channles in dat and eeg used to plot
% several csd maps for csdchannles cell arry of ch. number vectors
% and also datchannels in separate subplot for convenince
% in segment = [reftime beg end] reftime in SECONDS and beg and end in MSEC 
% as in eega output 
function ViewSegCSD(filename,chnum,csdchannels,segment,csdstep,filter)

Par = LoadPar(filename);
if (nargin<2 | isempty(chnum)) 
    chnum = Par.nChannels;
end
if (nargin<5 | isempty(csdstep)) 
    csdstep=2;
end
if (nargin<6 | isempty(filter)) 
    filter=[ 1 200];
end

eegsr=1e6/Par.SampleTime/16;
Nyquist =eegsr/2;
csdplotsnum=length(csdchannels);
csdchnum=[];
for i=1:csdplotsnum
    csdchnum(i)=length(csdchannels{i});
end

segment(2:3)=segment(2:3)/1000;  % from msec to sec

eegfn=[filename '.eeg'];

eegbeg=round((segment(1)+segment(2))*eegsr)*2*chnum;
eegsamples=round((segment(3)-segment(2))*eegsr);
eeg=bload(eegfn,[chnum, eegsamples],eegbeg);

if size(eeg,1)==chnum
     eeg=eeg';
end
if FileExists('offsetcorrection')
    corr = load('offsetcorrection');
else
    corr = mean(eeg,1);
end
eeg=eeg-repmat(corr,eegsamples,1);


%do the filtering below 200 Hz

%eeg = FirFilter(eeg, 20, [100 250]/Nyquist,'bandpass');
%-----------------------------------------------------------needs to be fixed
% if there are some skipped channels = interpolate them
% 
% if (length(csdchannels)<range(csdchannels)+1)
%     MissingCh = setdiff([csdchannels(1):csdchannels(end)],csdchannels);
%     eeg = FixEegChannels(eeg',MissingCh,'cubic');
%     eeg = eeg';
% end

trange = linspace(segment(2),segment(3),eegsamples)*1000;

%eegfromdat=filtereeg(dat,1 ,800,20000);
%dat1 = FirFilter(dat, 20, [100 250]/10000,'bandpass');
eeg = ButFilter(eeg, 2, filter/Nyquist,'bandpass');

%PlotCSD96(eeg,trange,[1:chnum],Par,2);
PlotCSD96(eeg,trange,cell2mat(csdchannels),Par,2);
return

datfn=[filename '.dat'];
if 0%FileExists(datfn)
    
	datsr=20000;
	datbeg=round((segment(1)+segment(2))*datsr)*2*chnum;
	datsamples=round((segment(3)-segment(2))*datsr);
	dat=bload(datfn,[chnum, datsamples],datbeg);
	if size(dat,1)==chnum
         dat=dat';
	end
	dat=dat-2048;
	trangedat = linspace(segment(2),segment(3),datsamples)*1000;
    isdat =1;
else
    isdat =0;
    dat=eeg;
end
%keyboard
 for i=1:csdplotsnum
    % subplot(csdplotsnum+iseeg,1,i);
    if size(csdchannels,1)>size(csdchannels,2)
        subplot(csdplotsnum, 1, i);
    else
        subplot(1,csdplotsnum,  i);
    end
    CurSrcDns(eeg(:,csdchannels{i}),trange,'c', csdchnum(i), [], eegsr, csdstep, []);
    hold on
    tit=[filename ' - ' num2str(csdchannels{i}(1)) ' : ' num2str(csdchannels{i}(end))];
    tit = [tit ' @ ' num2str(segment(1))];
    title(tit);
    if isdat
       %PlotManyCh(dat(:,csdchannels{i}((1+csdstep):(end-csdstep))),trangedat,datsr,3,'k',0);
       PlotTraces(dat(:,csdchannels{i}((1+csdstep):(end-csdstep))),trangedat,datsr,3,'k',0);
%         PlotManyCh(dat(:,csdchannels(1:end)),trangedat,datsr,2,'k',0.2);
    else
%        PlotManyCh(dat(:,csdchannels{i}((1+csdstep):(end-csdstep))),trange,eegsr,3,'k',0);
        PlotTraces(dat(:,csdchannels{i}((1+csdstep):(end-csdstep))),trange,eegsr,3,'k',0);
    end
end
%uncomment above!!!!!!!!!
%keyboard

% if ~FileExists('test.mat')
%     eegch = eeg(125:180*1.25,:);
%     eegch=mean(eegch,1);
%     save('test.mat','eegch');
% else
%     load('test.mat');
%     eegch1 = eeg(125:180*1.25,:);
%     eegch1=mean(eegch1,1);
%     eegch = [eegch; eegch1];
%     save('test.mat','eegch');
% end

% if iseeg
%     subplot(csdplotsnum+iseeg,1,csdplotsnum+1);
%     %maxdat=max(max(dat(:,eegchannels),[],1))
%     %mindat=min(min(dat(:,eegchannels),[],1))
%     %axis([trange(1) trange(2) 1 maxdat]);
%     hold on
%    % plotmanych(dat(:,eegchannels),1,trange);
%     plot(linspace(trange(1),trange(2),datsamples),dat(:,eegchannels));
%     set(gca,'Xlim',trange);
%     tit=num2str(eegchannels);
%     legend(tit');
%     tit = [tit '@ ' num2str(segment(1))];
%     title(tit);
%     
% end
