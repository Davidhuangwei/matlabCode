i=1
while i<36
    in = input('q?:','s');
    if strcmp(in,'q')
        break
    else
        figure(1)
        clf
        hold on
        plot(depStruct.goalArm(:,37),'.')
        plot(depStruct.goalArm(:,36),'r.')
        plot(i,depStruct.goalArm(i,37),'g.')
        plot(i,depStruct.goalArm(i,36),'m.')
        figure(2)
        clf
        hold on
        plot(squeeze(eegStruct.goalArm(i,37,:)))
        plot(squeeze(eegStruct.goalArm(i,36,:)),'r')
        set(gca,'ylim',[-5000 5000]);
    end
    i = i + 1;
end

happy = keepDepStruct;
happy = cell2mat(keepDepStruct);
clf
chanMat = MakeChanMat(6,16);
for i=1:16
    for j=1:6
        subplot(16,6,(i-1)*6+j);
        hold on
        plot(happy(chanMat(i,j)).returnArm,'b.')
        plot(happy(chanMat(i,j)).centerArm,'r.')
        plot(happy(chanMat(i,j)).Tjunction,'g.')
        plot(happy(chanMat(i,j)).goalArm,'k.')
        fprintf('%i,',chanMat(i,j))
        set(gca,'ylim',[-3 3])
    end
end

clf
chanMat = MakeChanMat(6,16);
for i=1:16
    for j=1:6
        subplot(16,6,(i-1)*6+j);
        hold on
        plot(happy2.returnArm(:,chanMat(i,j)),'b.')
        plot(happy2.centerArm(:,chanMat(i,j)),'r.')
        plot(happy2.Tjunction(:,chanMat(i,j)),'g.')
        plot(happy2.goalArm(:,chanMat(i,j)),'k.')
        fprintf('%i,',chanMat(i,j))
    end
end

i=1
while i<36
    in = input('q?:','s');
    if strcmp(in,'q')
        break
    else
        figure(1)
        clf
        hold on
        plot(depStruct.goalArm(:,37),'.')
        plot(depStruct.goalArm(:,36),'r.')
        plot(i,depStruct.goalArm(i,37),'g.')
        plot(i,depStruct.goalArm(i,36),'m.')

        figure(2)
        clf
        hold on
        grid on
%         plot(squeeze(eegStruct.returnArm(i,36,:)),'m')
%         plot(squeeze(eegStruct.centerArm(i,36,:))-5000,'m')
%         plot(squeeze(eegStruct.Tjunction(i,36,:))-10000,'m')
        plot(squeeze(eegStruct.goalArm(i,36,:))-10000,'m')
%         plot(squeeze(eegStruct.returnArm(i,37,:)),'g')
%         plot(squeeze(eegStruct.centerArm(i,37,:))-5000,'g')
%         plot(squeeze(eegStruct.Tjunction(i,37,:))-10000,'g')
        plot(squeeze(eegStruct.goalArm(i,37,:))-10000,'g')
        set(gca,'ylim',[-20000 -5000]);

        figure(3)
        clf
        hold on
        plot(fs,squeeze(waveStruct.goalArm(i,36,:)),'m')
        plot(fs,squeeze(waveStruct.goalArm(i,37,:)),'g')
         set(gca,'xlim',[1 30]);
        set(gca,'ylim',[55 80]);

        figure(4)
        clf
        hold on
        [thetaY,thetaF]= mtpsd(squeeze(eegStruct.goalArm(i,36:37,:))',1250,1250,626,0,2,[],[]);
        %[wave,fo,t,s,wb] = Wavelet(squeeze(eegStruct.goalArm(i,36:37,:))',[],[],8);
         plot(thetaF,10*log10(abs(thetaY(:,1)).^2),'m')
         plot(thetaF,10*log10(abs(thetaY(:,2)).^2),'g')
         set(gca,'xlim',[1 30]);
        set(gca,'ylim',[115 150]);
 
   end
    i = i + 1;
end

        subplot(1,2,2);
        hold on
        plot(squeeze(eegStruct.returnArm(i,33,:)))
        plot(squeeze(eegStruct.centerArm(i,33,:))-5000,'r')
        plot(squeeze(eegStruct.Tjunction(i,33,:))-10000,'g')
        plot(squeeze(eegStruct.goalArm(i,33,:))-15000,'k')
        set(gca,'ylim',[-20000 5000]);
 
%         plot(squeeze(eegStruct.returnArm(i,36,:)),'color',[0 0 1]*0.5)
%         plot(squeeze(eegStruct.centerArm(i,36,:))-5000,'color',[1 0 0]*0.5)
%         plot(squeeze(eegStruct.Tjunction(i,36,:))-10000,'color',[0 1 0]*0.5)
%         plot(squeeze(eegStruct.goalArm(i,36,:))-15000,'color',[0 0 1]*0.5)
% 
%         plot(squeeze(eegStruct.returnArm(i,37,:)),'color',[0 0 1])
%         plot(squeeze(eegStruct.centerArm(i,37,:))-5000,'color',[1 0 0])
%         plot(squeeze(eegStruct.Tjunction(i,37,:))-10000,'color',[0 1 0])
%         plot(squeeze(eegStruct.goalArm(i,37,:))-15000,'color',[0 0 1])
        %plot(squeeze(eegStruct.returnArm(i,37,:)),'color',[1 0 0]*0.5)
        %plot(squeeze(eegStruct.centerArm(i,37,:))-5000,'r')
        %plot(squeeze(eegStruct.Tjunction(i,37,:))-10000,'g')
        %plot(squeeze(eegStruct.goalArm(i,37,:))-15000,'k')
        
for ch=1:96
    depStructSub = GetStructMatSub(depStruct,[2,ch]);
    happy(ch) = DayZscoreTemp(depStructSub,{1:20,21:38});
end
happy2 = MatStruct2StructMat(happy);


for i=1:4
    subplot(1,4,i);
    imagesc(Make2DPlotMat(squeeze(categMeans{:}(i,1,:)),MakeChanMat(6,16)));
    set(gca,'clim',[-1 1])
    colorbar
end

