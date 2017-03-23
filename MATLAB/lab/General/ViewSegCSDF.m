%% ViewSegCSD(filename,chnum,csdchannels,segment)
% chnum - number of channles in dat and eeg used to plot
% several csd maps for csdchannles cell arry of ch. number vectors
% and also datchannels in separate subplot for convenince
% in segment = [reftime beg end] reftime in SECONDS and beg and end in MSEC 
% as in eega output 
function ViewSegCSD(filename,chnum,csdchannels,segment,csdstep)

if (nargin<5 | isempty(csdstep)) 
    csdstep=2;
end

eegsr=20000;
Nyquist =eegsr/2;
csdplotsnum=length(csdchannels);
csdchnum=[];
for i=1:csdplotsnum
    csdchnum(i)=length(csdchannels{i});
end

segment(2:3)=segment(2:3)/1000;  % from msec to sec

eegfn=[filename '.fil'];

eegbeg=round((segment(1)+segment(2))*eegsr)*2*chnum;
eegsamples=round((segment(3)-segment(2))*eegsr);
eeg=bload(eegfn,[chnum, eegsamples],eegbeg);

if size(eeg,1)==chnum
     eeg=eeg';
end
eeg=eeg-2048;

%do the filtering below 200 Hz
eeg = FirFilter(eeg, 20, 30/Nyquist,'low');
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
datfn=[filename '.fil'];
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
%dat1 = FirFilter(dat, 20, [100 250]/10000,'bandpass');
%keyboard
 for i=1:csdplotsnum
    % subplot(csdplotsnum+iseeg,1,i);
    subplot(1,csdplotsnum, i);
    CurSrcDns(eeg(:,csdchannels{i}),trange,'c', csdchnum(i), [], eegsr, csdstep, []);
    cla
    hold on
  %  tit=[filename ' - ' num2str(csdchannels{i}(1)) ' : ' num2str(csdchannels{i}(end))];
   % tit = [tit ' @ ' num2str(segment(1))];
    %title(tit);
    if isdat
%       PlotManyCh(dat(:,csdchannels{i}((1+csdstep):(end-csdstep))),trangedat,datsr,3,'k',1);
         PlotManyCh(dat(:,csdchannels(1:end)),trangedat,datsr,2,'k',1);
    else
       PlotManyCh(eeg(:,csdchannels{i}((1+csdstep):(end-csdstep))),trange,eegsr,4,'k',1);
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
