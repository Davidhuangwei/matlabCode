function stimoverlay(filebase,begintime,endtime,channels,autosave,notes)

if ~exist('notes')
    notes = '';
end
if ~exist('autosave')
    autosave = 0;
end

datsampl=20000;
eegsampl = 1250;
data = readmulti([filebase '.dat'],97,channels(1));
dataseg = data((begintime*datsampl):(endtime*datsampl),:);
clear data;

% calculate stim peaks
%for i=1:floor(length(dataseg(:,1))/10/datsampl)
%    stims(i) = (i-1)*10*datsampl + find(dataseg(((i-1)*10*datsampl+1):i*10*datsampl,1)==min(dataseg(((i-1)*10*datsampl+1):i*10*datsampl,1)));
%end

stimindex = 1;
stims = [];
for i=2*datsampl:10*datsampl:length(dataseg(:,1))-12*datsampl
    localmin = i-1 + find(dataseg(i:i+10*datsampl-1,1)==min(dataseg(i:i+10*datsampl-1,1)));
    localmax = i-1 + find(dataseg(i:i+10*datsampl-1,1)==max(dataseg(i:i+10*datsampl-1,1)));
    localmin(1)-localmax(1);
    %if abs(localmin(1)-localmax(1)) < 10
        stims(stimindex) = localmax(1);
        stimindex = stimindex + 1;    
        %end
end

eeg = readmulti([filebase '.eeg'],97,channels);
eegseg = eeg((begintime*eegsampl):(endtime*eegsampl),:);

% firfiltb = fir1(floor(0.25*eegsampl)*2,[4/eegsampl*2,20/eegsampl*2]);
% filtseg = Filter0(firfiltb,eegseg);

%filter with cheby
forder = 4;
Ripple = 20;
lowcut = 4;
highcut = 20;
[b a] = Scheby2(forder, Ripple, [lowcut highcut]/eegsampl*2);
filtseg = Sfiltfilt(b,a,eegseg);

figure(1)
clf
plot(dataseg(:,1))
hold on
plot(1:round(datsampl/eegsampl):length(dataseg), eegseg(:,1),'r')
plot(1:round(datsampl/eegsampl):length(dataseg), filtseg(:,1),'g')
plot(stims,dataseg(stims,1),'.','markersize',10,'color',[0 0 0])
title([filebase ': channel ' num2str(channels(1)) ' - ' notes]);
datstims = stims;
stims = round(stims*eegsampl/datsampl); % convert to eeg sampling

figure(2)
clf;
xdisp = 1*eegsampl; 
traceOffset = 5000;
for j=1:length(channels)
    for i=1:length(stims)
        hold on; 
        plot(filtseg((stims(i)-xdisp):(stims(i)+xdisp),j)-j*traceOffset,'color', [mod(j,2) 0 0]); 
    end
end
title([filebase ': channels ' num2str(channels(1)) '-'  num2str(channels(end)) ' - ' notes]);
set(gca,'xlim',[-xdisp xdisp], 'ylim', [-traceOffset*(length(channels)+1) 0]);
set(gca, 'xtick', [-xdisp -0.75*xdisp -0.5*xdisp -0.25*xdisp 0 0.25*xdisp 0.5*xdisp 0.75*xdisp xdisp], 'xticklabel', [-1*xdisp/eegsampl -0.75*xdisp/eegsampl -0.5*xdisp/eegsampl -0.25*xdisp/eegsampl 0*xdisp/eegsampl 0.25*xdisp/eegsampl 0.5*xdisp/eegsampl 0.75*xdisp/eegsampl 1*xdisp/eegsampl]);
grid on;


figure(3)
clf;
xdisp = 50*datsampl/1000; 
traceOffset = 10000;
for j=1:length(channels)
    data = readmulti([filebase '.dat'],97,channels(j));
    dataseg = data((begintime*datsampl):(endtime*datsampl),:);
    clear data;
    for i=1:length(stims)
        hold on; 
        plot(dataseg(datstims(i):(datstims(i)+xdisp))-j*traceOffset,'color', [mod(j,2) 0 0]); 
    end
    clear dataseg;
end
title([filebase ': channels ' num2str(channels(1)) '-'  num2str(channels(end)) ' - ' notes]);
set(gca,'xlim',[0 xdisp], 'ylim', [-traceOffset*(length(channels)+1.5) 0.5*traceOffset]);
set(gca, 'xtick', [0*xdisp  0.25*xdisp 0.5*xdisp 0.75*xdisp xdisp], 'xticklabel', [0*xdisp*1000/datsampl 0.25*xdisp*1000/datsampl 0.5*xdisp*1000/datsampl 0.75*xdisp*1000/datsampl 1*xdisp*1000/datsampl]);
grid on;

if ~autosave
    while 1,
        i = input('Save to disk? (yes/no):', 's');
        if strcmp(i,'yes') | strcmp(i,'no'), break; end
    end
    if i(1) == 'y'
        fprintf('Saving %s\n', [filebase '_stims.mat']);
        
        datstims = datstims + begintime*datsampl-1;
stims = round(datstims*eegsampl/datsampl); 
        save([filebase '_stims.mat'],'stims','datstims');
    end
end
