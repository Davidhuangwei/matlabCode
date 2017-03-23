function CalcRunningSpectra8_2_CalcRunningSpectra9(fileBaseMat);

oldDirBase = 'CalcRunningSpectra8';
newDirBase = 'CalcRunningSpectra9';

%dirExt = {'_noExp_MidPoints_MinSpeed0Win626_LinNear.eeg'}

dirExt = {'_noExp_MidPoints_MinSpeed0Win626.eeg';...
          '_noExp_MidPoints_MinSpeed0Win626_LinNearCSD121.csd';...
          %'_noExp_MidPoints_MinSpeed0Win626_NearAveCSD1.csd';...
          '_noExp_MidPoints_MinSpeed0Win626_LinNear.eeg'};

for j=1:size(fileBaseMat,1)
    fprintf('%s\n',fileBaseMat(j,:));
    for k=1:length(dirExt)
        cd(fileBaseMat(j,:))
        if exist([newDirBase dirExt{k}],'dir')
            %fprintf('%s\n',['!rm -rf ' newDirBase dirExt{k}]);
            eval(['!rm -rf ' newDirBase dirExt{k}]);
        end
        eval(['!cp -r ' oldDirBase dirExt{k} ' ' newDirBase dirExt{k}]);
        cd([newDirBase dirExt{k}]);
        
        load('powSpec.mat','-mat')
        powSpec.fo = flipdim(powSpec.fo,2);
        powSpec.yo = flipdim(powSpec.yo,3);
        load('cohSpec.mat','-mat')
        cohSpec.fo = flipdim(cohSpec.fo,2);
        load('phaseSpec.mat','-mat')
        phaseSpec.fo = flipdim(phaseSpec.fo,2);
        load('crossSpec.mat','-mat')
        crossSpec.fo = flipdim(crossSpec.fo,2);
              
        fo = cohSpec.fo;
        
        load('infoStruct.mat')
        thetaFreqRange = infoStruct.thetaFreqRange;
        gammaFreqRange = infoStruct.gammaFreqRange;
        
        selChanNames = fieldnames(cohSpec.yo);
        for m=1:length(selChanNames)
            cohSpec.yo.(selChanNames{m}) = flipdim(cohSpec.yo.(selChanNames{m}),3);
            phaseSpec.yo.(selChanNames{m}) = flipdim(phaseSpec.yo.(selChanNames{m}),3);
            crossSpec.yo.(selChanNames{m}) = flipdim(crossSpec.yo.(selChanNames{m}),3);
            
            cohSpec.yo.(selChanNames{m}) = atanh((cohSpec.yo.(selChanNames{m})-0.5)*1.999);
            
            thetaCohMedian.(selChanNames{m}) = ...
                squeeze(median(cohSpec.yo.(selChanNames{m})(:,:,find(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))),3));
            
            thetaCohMean.(selChanNames{m}) = ...
                squeeze(mean(cohSpec.yo.(selChanNames{m})(:,:,find(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))),3));
            
            gammaCohMedian.(selChanNames{m}) = ...
                squeeze(median(cohSpec.yo.(selChanNames{m})(:,:,find(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))),3));
            
            gammaCohMean.(selChanNames{m}) = ...
                squeeze(mean(cohSpec.yo.(selChanNames{m})(:,:,find(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))),3));
        end
        save(['powSpec.mat'],SaveAsV6,'powSpec');
        save(['cohSpec.mat'],SaveAsV6,'cohSpec');
        save(['phaseSpec.mat'],SaveAsV6,'phaseSpec');
        save(['crossSpec.mat'],SaveAsV6,'crossSpec');
        save(['thetaCohMedian' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaCohMedian');
        save(['thetaCohMean' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaCohMean');
        save(['gammaCohMedian' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaCohMedian');
        save(['gammaCohMean' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaCohMean');
        clear powSpec;
        clear cohSpec;
        clear phaseSpec;
        clear crossSpec;
        clear thetaCohMedian;
        clear thetaCohMean;
        clear gammaCohMedian;
        clear gammaCohMean;
        cd ..
        cd ..
    end
end

        