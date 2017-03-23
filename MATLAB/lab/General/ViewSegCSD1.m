%% ViewSegCSD(filename,chnum,csdchannels,segment)
% chnum - number of channles in dat and eeg used to plot
% several csd maps for csdchannles cell arry of ch. number vectors
% and also datchannels in separate subplot for convenince
% in segment = [reftime beg end] reftime in SECONDS and beg and end in MSEC 
% as in eega output 
function ViewSegCSD(filename,chnum,csdchannels,segment,csdstep)
global CSDSTEP;
CSDSTEP=2;
eegsr=1250;
Nyquist=eegsr/2;
% csd
plotsnum=size(csdchannels,1);
% csdchnum=[];
% for i=1:csdplotsnum
%     csdchnum(i)=length(csdchannels{i});
% end

segment(2:3)=segment(2:3)/1000;

eegfn=[filename '.eeg'];

eegbeg=round((segment(1)+segment(2))*eegsr)*2*chnum;
eegsamples=round((segment(3)-segment(2))*eegsr);
eeg=bload(eegfn,[chnum, eegsamples],eegbeg);
%do the filtering
eeg = FirFilter(eeg, 20, 40/Nyquist,'low');


if size(eeg,1)==chnum
     eeg=eeg';
end
eeg=eeg-2048;


% if there are some skipped channels = interpolate them
if (length(csdchannels)<range(csdchannels)+1)
    MissingCh = setdiff([csdchannels(1):csdchannels(end)],csdchannels);
    eeg = FixEegChannels(eeg',MissingCh,'cubic');
    eeg = eeg';
end

trange = linspace(segment(2),segment(3),eegsamples)*1000;

%eegfromdat=filtereeg(dat,1 ,800,20000);
datfn=[filename '.dat'];
if FileExists(datfn)
    
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
end

% for i=1:csdplotsnum
%     subplot(csdplotsnum+iseeg,1,i);
    CurSrcDns(eeg(:,csdchannels),trange,'c');
    hold on
    tit=[filename ' - ' num2str(csdchannels(1)) ' : ' num2str(csdchannels(end))];
    tit = [tit ' @ ' num2str(segment(1))];
    title(tit);
    if isdat
        PlotManyCh(dat(:,csdchannels((1+CSDSTEP):(end-CSDSTEP))),trangedat,datsr,2,'k');
    else
        PlotManyCh(eeg(:,csdchannels((1+CSDSTEP):(end-CSDSTEP))),trange,eegsr,2,'k');
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
