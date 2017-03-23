function  trialbytrialmazepow(filebasemat,fileext,nchannels,channel,lowband,highband)

if ~exist('trialtypesbool')
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                    %cr ir cl il crp irp clp ilp crb irb clb ilb xp
end
if ~exist('mazelocationsbool')
    mazelocationsbool = [0  0  0  1  1  1   1   1   1];
                       %rp lp dp cp ca rca lca rra lra
end
% [1 0 1 0 0 0 0 0 0 0 0 0 0]
% [0 0 0 1 1 1 1 1 1]

[numfiles n] = size(filebasemat);
ntrials=0;

returnarmPowMat = [];
centerarmPowMat = [];
choicepointPowMat = [];
choicearmPowMat = [];

for i=1:numfiles
    
    dspowname = [filebasemat(i,:) '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBdspow'];
    powerdat = ((bload(dspowname,[nchannels inf],0,'int16')')/100);
    [dspm n] = size(powerdat);
    eegdat = readmulti([filebasemat(i,:) '.eeg'],nchannels,channel);
    [eegm n] = size(eegdat);
    correcttrials = loadmazetrialtypes(filebasemat(i,:),[1 0 1 0 0 0 0 0 0 0 0 0 0],[0 0 0 1 1 1 1 1 1]);
    [whlm n] = size(correcttrials);
    if whlm~=dspm
        FILES_NOT_SAME_SIZE
    end
    factor = eegm/whlm;
    
    atports = loadmazetrialtypes(filebasemat(i,:),[1 0 1 0 0 0 0 0 0 0 0 0 0],[1 1 0 0 0 0 0 0 0]);
    
    choicepoint = loadmazetrialtypes(filebasemat(i,:),[1 0 1 0 0 0 0 0 0 0 0 0 0],[0 0 0 1 0 0 0 0 0]);
    centerarm   = loadmazetrialtypes(filebasemat(i,:),[1 0 1 0 0 0 0 0 0 0 0 0 0],[0 0 0 0 1 0 0 0 0]);
    choicearm   = loadmazetrialtypes(filebasemat(i,:),[1 0 1 0 0 0 0 0 0 0 0 0 0],[0 0 0 0 0 1 1 0 0]);
    returnarm   = loadmazetrialtypes(filebasemat(i,:),[1 0 1 0 0 0 0 0 0 0 0 0 0],[0 0 0 0 0 0 0 1 1]);
    
    %plot(correcttrials(:,1),correcttrials(:,2))
    trialbegin = find(correcttrials(:,1)~=-1);
    while ~isempty(trialbegin),
        trialend = trialbegin(1) + find(atports((trialbegin(1)+1):end,1)~=-1);
        if isempty(trialend),
            breaking = 1
            break;
        end
        
        trialreturnarm = trialbegin(1)-1+find(returnarm(trialbegin(1):(trialend(1)-1),1)~=-1);
        trialcenterarm = trialbegin(1)-1+find(centerarm(trialbegin(1):(trialend(1)-1),1)~=-1);
        trialchoicepoint = trialbegin(1)-1+find(choicepoint(trialbegin(1):(trialend(1)-1),1)~=-1);
        trialchoicearm = trialbegin(1)-1+find(choicearm(trialbegin(1):(trialend(1)-1),1)~=-1);
        
        trialbegin = trialend(1)-1+find(correcttrials(trialend(1):end,1)~=-1);
        

        figure(1)
      clf
        subplot(2,1,1)
          hold on
          grid
        plot(eegdat(floor(trialreturnarm(1)*factor):ceil(trialreturnarm(end)*factor))+4500,'color',[0 0 1]);
        plot(eegdat(floor(trialcenterarm(1)*factor):ceil(trialcenterarm(end)*factor))+1500,'color',[1 0 0]);
        plot(eegdat(floor(trialchoicepoint(1)*factor):ceil(trialchoicepoint(end)*factor))-1500,'color',[0 1 0]);
        plot(eegdat(floor(trialchoicearm(1)*factor):ceil(trialchoicearm(end)*factor))-4500,'color',[0 0 0]);
            set(gca,'xlim',[0 2500],'ytick',[(0:1000:13000)-6000]);
          grid
      
        subplot(2,1,2)
          hold on
          grid
           plot(powerdat(trialreturnarm(1):trialreturnarm(end),channel),'color',[0 0 1]);
        plot(powerdat(trialcenterarm(1):trialcenterarm(end),channel),'color',[1 0 0]);
        plot(powerdat(trialchoicepoint(1):trialchoicepoint(end),channel),'color',[0 1 0]);
        plot(powerdat(trialchoicearm(1):trialchoicearm(end),channel),'color',[0 0 0]);
        set(gca,'xlim',[0 round(2500/factor)]);
   
        %plot(returnarm(trialreturnarm,1),returnarm(trialreturnarm,2),'.','color',[0 0 1],'markersize',7);
        %plot(centerarm(trialcenterarm,1),centerarm(trialcenterarm,2),'.','color',[1 0 0],'markersize',7);
        %plot(choicepoint(trialchoicepoint,1),choicepoint(trialchoicepoint,2),'.','color',[0 0 0],'markersize',7);
        %plot(choicearm(trialchoicearm,1),choicearm(trialchoicearm,2),'.','color',[0 1 1],'markersize',7);
        %set(gca,'xlim',[0 368],'ylim',[0 240]);    
        ntrials = ntrials + 1;
        fprintf('n=%d : ',ntrials);
        input('next?'); 
    end
end
fprintf('total n=%d : ',ntrials);

