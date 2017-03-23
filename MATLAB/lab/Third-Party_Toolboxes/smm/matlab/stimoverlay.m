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
xmid = 3; % * eegsampl
xdisp = 1; % * eegsampl
traceOffset = 5000;
for j=1:length(channels)
    for i=1:length(stims)
        hold on; 
        plot(filtseg((stims(i)-xmid*eegsampl):(stims(i)+xmid*eegsampl),j)-j*traceOffset,'color', [mod(j,2) 0 0]); 
    end
end
title([filebase ': channels ' num2str(channels(1)) '-'  num2str(channels(end)) ' - ' notes]);
set(gca,'xlim',[(xmid-xdisp)*eegsampl (xmid+xdisp)*eegsampl], 'ylim', [-traceOffset*(length(channels)+1) 0]);
set(gca, 'xtick', [(xmid-xdisp)*eegsampl (xmid-0.75*xdisp)*eegsampl (xmid-0.5*xdisp)*eegsampl (xmid-0.25*xdisp)*eegsampl (xmid)*eegsampl (xmid+0.25*xdisp)*eegsampl (xmid+0.5*xdisp)*eegsampl (xmid+0.75*xdisp)*eegsampl (xmid+xdisp)*eegsampl], 'xticklabel', [-1 -0.75 -0.5 -0.25 0 0.25 0.5 0.75 1]);
grid on;
%plot([5.3*eegsampl 5.3*eegsampl],[-(1+length(channels))*4000 0],'b:')

figure(3)
clf;
xmid = 62/1250; % * eegsampl
xdisp = 62/1250; % * eegsampl
traceOffset = 10000;
for j=1:length(channels)
    for i=1:length(stims)
        hold on; 
        plot(eegseg((stims(i)-xmid*eegsampl):(stims(i)+xmid*eegsampl),j)-j*traceOffset,'color', [mod(j,2) 0 0]); 
    end
end
title([filebase ': channels ' num2str(channels(1)) '-'  num2str(channels(end)) ' - ' notes]);
set(gca,'xlim',[(xmid)*eegsampl (xmid+xdisp)*eegsampl], 'ylim', [-traceOffset*(length(channels)+1.5) 0.5*traceOffset]);
set(gca, 'xtick', [(xmid)*eegsampl (xmid+0.25*xdisp)*eegsampl (xmid+0.5*xdisp)*eegsampl (xmid+0.75*xdisp)*eegsampl (xmid+xdisp)*eegsampl], 'xticklabel', [0 0.25*xdisp*1000 0.5*xdisp*1000 0.75*xdisp*1000 1*xdisp*1000]);
grid on;

if ~autosave
    while 1,
        i = input('Save to disk? (yes/no):', 's');
        if strcmp(i,'yes') | strcmp(i,'no'), break; end
    end
    if i(1) == 'y'
        fprintf('Saving %s\n', [filebase '_stims.mat']);
        
        
        save([filebase '_stims.mat'],'stims','datstims');
    end
end
