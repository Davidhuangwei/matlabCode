chan1 = 1;
nChan = 16
nRows = 5;
figure
for i = 1:nChan
    subplot(nRows,nChan,i+nChan*0);
    hist((returnArmPowMat(:,i+chan1-1)));
    title(['chan' num2str(i+chan1-1)],'fontsize',5)
    set(gca,'FontSize',5)
    subplot(nRows,nChan,i+nChan*1);
    hist((centerArmPowMat(:,i+chan1-1)));
    set(gca,'FontSize',5)
    subplot(nRows,nChan,i+nChan*2);
    hist((TjunctionPowMat(:,i+chan1-1)));
    set(gca,'FontSize',5)
    subplot(nRows,nChan,i+nChan*3);
    hist((goalArmPowMat(:,i+chan1-1)));
    set(gca,'FontSize',5)
    subplot(nRows,nChan,i+nChan*4);
    hist(([returnArmPowMat(:,i+chan1-1); centerArmPowMat(:,i+chan1-1); TjunctionPowMat(:,i+chan1-1); goalArmPowMat(:,i+chan1-1)]));
    set(gca,'FontSize',5)
end
text(0,0,{'sm9603 alter','(ThetaPower)',['chans ' num2str(chan1) ':' num2str(chan1+nChan-1)],'returnArm','centerArm','Tjunction','goalArm','allArms'})
figure
for i = 1:nChan
    subplot(nRows,nChan,i+nChan*0);
    hist(10*log10(returnArmPowMat(:,i+chan1-1)));
    title(['chan' num2str(i+chan1-1)],'fontsize',5)
    set(gca,'FontSize',5)
    subplot(nRows,nChan,i+nChan*1);
    hist(10*log10(centerArmPowMat(:,i+chan1-1)));
    set(gca,'FontSize',5)
    subplot(nRows,nChan,i+nChan*2);
    hist(10*log10(TjunctionPowMat(:,i+chan1-1)));
    set(gca,'FontSize',5)
    subplot(nRows,nChan,i+nChan*3);
    hist(10*log10(goalArmPowMat(:,i+chan1-1)));
    set(gca,'FontSize',5)
    subplot(nRows,nChan,i+nChan*4);
    hist(10*log10([returnArmPowMat(:,i+chan1-1); centerArmPowMat(:,i+chan1-1); TjunctionPowMat(:,i+chan1-1); goalArmPowMat(:,i+chan1-1)]));
    set(gca,'FontSize',5)
end
text(0,0,{'sm9603 alter','10*log10(ThetaPower)',['chans ' num2str(chan1) ':' num2str(chan1+nChan-1)],'returnArm','centerArm','Tjunction','goalArm','allArms'})

PrintFullColor([1 2],0,[11 4],0)