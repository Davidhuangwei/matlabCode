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
    dspow = ((bload(dspowname,[nchannels inf],0,'int16')')/100);
    [dspm n] = size(dspow);
    eegdat = readmulti([filebasemat(i,:) '.eeg'],nchannels,channel);
    filtname = [filebasemat(i,:) '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.filt'];
    filtdat = readmulti(filtname,nchannels,channel);
    powname = [filebasemat(i,:) '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBpow'];
    powdat = readmulti(powname,nchannels,channel)/100;
    
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
          plotbegin = 1;
          plotend = 1+range([floor(trialreturnarm(1)*factor) ceil(trialreturnarm(end)*factor)]);
          plot(plotbegin:plotend,filtdat(floor(trialreturnarm(1)*factor):ceil(trialreturnarm(end)*factor)),'Linewidth',10,'color',[0 1 1]);
          plot(plotbegin:plotend,eegdat(floor(trialreturnarm(1)*factor):ceil(trialreturnarm(end)*factor)),'color',[0 0 1]);
          
          subplot(2,1,2)
           hold on
          plot((plotbegin:plotend)./factor,powdat(floor(trialreturnarm(1)*factor):ceil(trialreturnarm(end)*factor)),'Linewidth',1,'color',[0 1 1]);
            
          subplot(2,1,1)
          hold on
          plotbegin = plotend;
          plotend = plotbegin + range([floor(trialcenterarm(1)*factor) ceil(trialcenterarm(end)*factor)]);
          plot(plotbegin:plotend,filtdat(floor(trialcenterarm(1)*factor):ceil(trialcenterarm(end)*factor)),'Linewidth',10,'color',[0 1 1]);
          plot(plotbegin:plotend,eegdat(floor(trialcenterarm(1)*factor):ceil(trialcenterarm(end)*factor)),'color',[1 0 0]);
                     
          subplot(2,1,2)
           hold on
          plot((plotbegin:plotend)./factor,powdat(floor(trialcenterarm(1)*factor):ceil(trialcenterarm(end)*factor)),'Linewidth',1,'color',[0 1 1]);
            
          subplot(2,1,1)
          hold on        
          plotbegin = plotend;
          plotend = plotbegin + range([floor(trialchoicepoint(1)*factor) ceil(trialchoicepoint(end)*factor)]);
          plot(plotbegin:plotend,filtdat(floor(trialchoicepoint(1)*factor):ceil(trialchoicepoint(end)*factor)),'Linewidth',10,'color',[0 1 1]);
          plot(plotbegin:plotend,eegdat(floor(trialchoicepoint(1)*factor):ceil(trialchoicepoint(end)*factor)),'color',[0 1 0]);
                    
          subplot(2,1,2)
           hold on
          plot((plotbegin:plotend)./factor,powdat(floor(trialchoicepoint(1)*factor):ceil(trialchoicepoint(end)*factor)),'Linewidth',1,'color',[0 1 1]);
            
          subplot(2,1,1)
          hold on          
          plotbegin = plotend;
          plotend = plotbegin + range([floor(trialchoicearm(1)*factor) ceil(trialchoicearm(end)*factor)]);
          plot(plotbegin:plotend,filtdat(floor(trialchoicearm(1)*factor):ceil(trialchoicearm(end)*factor)),'Linewidth',10,'color',[0 1 1]);
          plot(plotbegin:plotend,eegdat(floor(trialchoicearm(1)*factor):ceil(trialchoicearm(end)*factor)),'color',[0 0 0]);
          
           set(gca,'ytick',[(0:1000:4000)-2000],'xlim',[0 max([5000 plotend])],'xtick',[0:500:5000],'ylim',[-2000 2000]);
          grid
          
          subplot(2,1,2)
           hold on
          plot((plotbegin:plotend)./factor,powdat(floor(trialchoicearm(1)*factor):ceil(trialchoicearm(end)*factor)),'Linewidth',1,'color',[0 1 1]);
            
       
        subplot(2,1,2)
          hold on
          plotbegin = 0;
          plotend = range([trialreturnarm(1) trialreturnarm(end)]);
          plot(plotbegin:plotend,dspow(trialreturnarm(1):trialreturnarm(end),channel),'color',[0 0 1]);
          plotbegin = plotend;
          plotend = plotbegin + range([trialcenterarm(1) trialcenterarm(end)]);
          plot(plotbegin:plotend,dspow(trialcenterarm(1):trialcenterarm(end),channel),'color',[1 0 0]);
          plotbegin = plotend;
          plotend = plotbegin + range([trialchoicepoint(1) trialchoicepoint(end)]);
          plot(plotbegin:plotend,dspow(trialchoicepoint(1):trialchoicepoint(end),channel),'color',[0 1 0]);
          plotbegin = plotend;
          plotend = plotbegin + range([trialchoicearm(1) trialchoicearm(end)]);
          plot(plotbegin:plotend,dspow(trialchoicearm(1):trialchoicearm(end),channel),'color',[0 0 0]);
          set(gca,'xlim',[0 round(max([5000/factor plotend]))],'xtick',[0:500:5000]./factor,'ylim',[45 60],'ytick', [45:2:60]);
          grid
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

