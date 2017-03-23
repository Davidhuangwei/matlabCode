function CalcRunningGammaComod01(spectraDir,fileBaseCell,gammaFreqRange,thetaFreqRange,varargin)
%function CalcRunningSpectra12(description,fileBaseCell,fileExt,nChan,winLength,midPointsBool,thetaFreqRange,gammaFreqRange,varargin)
%[trialTypesBool,excludeLocations,minSpeed,selectedChannels] = ...
%    DefaultArgs(varargin,{[1 1 1 1 1 1 1 1 1 1 1 1 0],[1 1 1 0 0 0 0 0 0],0,load(['SelectedChannels' fileExt '.txt'])});
chanInfoDir = 'ChanInfo/';
           
fileExt = LoadField([fileBaseCell{1} '/' spectraDir '/infoStruct.fileExt']);
selChansStruct = LoadField([fileBaseCell{1} '/' spectraDir '/infoStruct.selChan']);

[batchModeBool] = ...
    DefaultArgs(varargin,{1});

% try

    selChanNames = fieldnames(selChansStruct);
    for j=1:length(selChanNames)
        selectedChannels(j) = selChansStruct.(selChanNames{j});
    end

    saveDir = spectraDir;
    currDir = pwd;

    %addpath /u12/antsiro/matlab/General
    addpath ~/matlab/sm_Copies

    bps = 2;
    %yoFreqRange = [0 500];


    %dayStruct = LoadVar('DayStruct.mat');

    for j=1:length(fileBaseCell)
%         try
            c1 = clock;
            fileBase = fileBaseCell{j};
            fprintf('Processing: %s%s\n',fileBase,fileExt);
            cd(currDir)
            cd(fileBase);

            wavParam = LoadField([spectraDir '/infoStruct.wavParam']);
            winLength = LoadField([spectraDir '/infoStruct.winLength']);
            nChan = LoadField([spectraDir '/infoStruct.nChan']);
            S0 = LoadField([spectraDir '/infoStruct.S0']);
            DJ = LoadField([spectraDir '/infoStruct.DJ']);
            J1 = LoadField([spectraDir '/infoStruct.J1']);
            whlSamp = LoadField([spectraDir '/infoStruct.whlSamp']);
            eegSamp = LoadField([spectraDir '/infoStruct.eegSamp']);

            N = winLength;


            waveXspec = [];
            waveCoh = [];
            wavePhase = [];

            fileInfo = dir([fileBase fileExt]);
            numSamples = fileInfo.bytes/nChan/bps;

            if exist([saveDir '/eegSegTime.mat'],'file')
                fprintf('Loading: %s/eegSegTime.mat\n',saveDir)
                to = LoadVar([saveDir '/eegSegTime.mat']);
             else
                Run_CalcRunningSpectra

                %                 if midPointsBool
                %                     trialMidsStruct = CalcFileMidPoints02(fileBase,0,trialTypesBool);
                %                     mazeRegionNames = fieldnames(getfield(trialMidsStruct,fileBase));
                %                     to = [];
                %                     mazeLocNames = {};
                %                     for i=1:size(mazeRegionNames,1)
                %                         to = [to; getfield(trialMidsStruct,fileBase,mazeRegionNames{i})'];
                %                         mazeLocNames = cat(2,mazeLocNames,repmat(mazeRegionNames(i),...
                %                             size(getfield(trialMidsStruct,fileBase,mazeRegionNames{i})')));
                %                     end
                %                     [to ind] = sort(to);
                %                     to = round((to-1)*eegSamp/whlSamp-winLength/2); % in eeg samples starting with 0
                %                     mazeLocNames = mazeLocNames(ind);
                %                 else
                %                     to = [0:winLength:numSamples-winLength]'; % in in eeg samples starting with 0
                %                     %to = [0:winLength:winLength]'; % in in eeg samples starting with 0
                %                 end
            end
%             try
                if ~isempty(to)
                    for i=1:length(to)
                        
                        gammaPowData = 10.^(bload([fileBase '_' num2str(gammaFreqRange(1)) '-' ...
                            num2str(gammaFreqRange(2)) 'Hz' fileExt '.100DBpow'],...
                            [nChan winLength],to(i)*nChan*bps,'int16')/1000);
                        eegData = bload([fileBase fileExt],[nChan winLength],to(i)*nChan*bps,'int16');

                        for m=1:nChan
                            [gammaTemp gammaPeriod] = xwt(gammaPowData(m,:),gammaPowData(m,:),'Pad',1,'DJ',DJ,'S0',S0,'J1',J1,'Param',wavParam);
                            gammaPow(1,m,:) = mean(gammaTemp'.*[repmat([hanning(winLength)./mean(hanning(winLength))],1,size(gammaTemp,1))],1);
                        end
                        for k=1:length(selectedChannels)
                            [temp period] = xwt(eegData(selectedChannels(k),:),eegData(selectedChannels(k),:),'Pad',1,'DJ',DJ,'S0',S0,'J1',J1,'Param',wavParam);
                            pow = mean(temp'.*[repmat([hanning(winLength)./mean(hanning(winLength))],1,size(temp,1))],1);

                            for m=1:nChan
                                [temp xSpecPeriod]= xwt(eegData(selectedChannels(k),:),gammaPowData(m,:),'Pad',1,'DJ',DJ,'S0',S0,'J1',J1,'Param',wavParam);
                                xSpec(1,k,m,:) = mean(temp'.*[repmat([hanning(winLength)./mean(hanning(winLength))],1,size(temp,1))],1);
                                coh(1,k,m,:) = atanh((sqrt(squeeze(xSpec(1,k,m,:).*conj(xSpec(1,k,m,:)))./...
                                    (pow'.*squeeze(gammaPow(1,m,:))))-0.5)*1.999);
                                phase(1,k,m,:) = complex(cos(angle(xSpec(1,k,m,:))),sin(angle(xSpec(1,k,m,:))));
                            end
                        end

                        fo = 1./period.*eegSamp;
                        fo = flipdim(fo,2);

                        if period ~= xSpecPeriod
                            ERROR_period_not_equal_to_cohPeriod
                        end
                        if exist('gammaComodCohSpec','var') & fo ~= gammaComodCohSpec.fo
                            ERROR_pSpec.fo_is_changing
                        end

                        waveXspec = cat(1,waveXspec,flipdim(xSpec,4));
                        waveCoh = cat(1,waveCoh,flipdim(coh,4));
                        wavePhase = cat(1,wavePhase,flipdim(phase,4));

                    end
                end
                size(waveCoh)
%             catch
%                 errorText = ['WARNING:  ' date '  ' mfilename '  call=('...
%                     description ',' fileBase ',' fileExt ',' num2str(nChan) ',' ...
%                     num2str(winLength) ',' num2str(midPointsBool) '\n'];
%                 ReportError(errorText,~batchModeBool)
%             end
            %%% Calculate fo bin sizes for integration %%%
            if fo(1) > fo(end)
                diffSign = -1;
            else
                diffSign = 1;
            end
            diff1 = diffSign*diff([fo(1) fo]);
            diff2 = diffSign*diff([fo fo(end)]);
            diffsum = diff1 + diff2;
            diffdiv = [1 2*ones(1,length(diffsum)-2) 1];
            binSize = permute(diffsum./diffdiv,[3 1 2]);


            %%% mean/median theta/gamma coh/phase estimates %%%
            for k=1:length(selectedChannels)
                gammaComodCrossSpec.yo.(selChanNames{k}) = squeeze(waveXspec(:,k,:,:));
                gammaComodCohSpec.yo.(selChanNames{k}) = squeeze(waveCoh(:,k,:,:));
                gammaComodPhaseSpec.yo.(selChanNames{k}) = squeeze(wavePhase(:,k,:,:));

                gammaComodThetaCohMedian.(selChanNames{k}) = squeeze(median(gammaComodCohSpec.yo.(selChanNames{k})(:,:,fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)),3));
                gammaComodThetaCohMean.(selChanNames{k}) = squeeze(sum(gammaComodCohSpec.yo.(selChanNames{k})(:,:,fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))...
                    .*repmat(binSize(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)),[size(gammaComodCohSpec.yo.(selChanNames{k}),1),size(gammaComodCohSpec.yo.(selChanNames{k}),2),1]),3)...
                    /sum(binSize(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))));
                gammaComodThetaPhaseMean.(selChanNames{k}) = squeeze(sum(gammaComodPhaseSpec.yo.(selChanNames{k})(:,:,fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))...
                    .*repmat(binSize(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)),[size(gammaComodPhaseSpec.yo.(selChanNames{k}),1),size(gammaComodPhaseSpec.yo.(selChanNames{k}),2),1]),3)...
                    /sum(binSize(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))));
            end
            gammaComodCrossSpec.fo = fo;
            gammaComodCohSpec.fo = fo;
            gammaComodPhaseSpec.fo = fo;

            figure;

            subplot(1,2,1);
            pcolor(1:length(to),gammaComodCohSpec.fo,squeeze(gammaComodCohSpec.yo.(selChanNames{1})(:,selectedChannels(2),:))');
            shading 'flat'
            set(gca,'clim',[0 1],'ylim',[0,100]);
            colorbar

            subplot(1,2,2);
            pcolor(1:length(to),gammaComodPhaseSpec.fo,angle(squeeze(gammaComodPhaseSpec.yo.(selChanNames{1})(:,selectedChannels(2),:)))');
            shading 'flat'
            set(gca,'clim',[-pi pi],'ylim',[0,100]);
            colorbar


            fprintf('Saving: %s\n',saveDir)
            set(gcf,'name',[fileBase ': ' saveDir]);

            save([saveDir '/gamma' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2))...
                'ComodCrossSpec.mat'],SaveAsV6,'gammaComodCrossSpec');
            
            save([saveDir '/gamma' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2))...
                'ComodCohSpec.mat'],SaveAsV6,'gammaComodCohSpec');
            
            save([saveDir '/gamma' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2))...
                'ComodPhaseSpec.mat'],SaveAsV6,'gammaComodPhaseSpec');
            
            save([saveDir '/gamma' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2))...
                'ComodThetaCohMedian' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],...
                SaveAsV6,'gammaComodThetaCohMedian');
            
            save([saveDir '/gamma' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2))...
                'ComodThetaCohMean' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],...
                SaveAsV6,'gammaComodThetaCohMean');
            
            save([saveDir '/gamma' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2))...
                'ComodThetaPhaseMean' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],...
                SaveAsV6,'gammaComodThetaPhaseMean');

            c2 = clock-c1;
            disp(num2str(c2))
            cd(currDir)
%         catch
%             errorText = ['ERROR:  ' date '  ' mfilename '  call=('...
%                 description ',' fileBase ',' fileExt ',' num2str(nChan) ',' ...
%                 num2str(winLength) ',' num2str(midPointsBool) '\n'];
%             ReportError(errorText,~batchModeBool)
%             cd(currDir)
%         end
    end
% catch
%     errorText = ['ERROR:  ' date '  ' mfilename '  call=('...
%         description ',' fileExt ',' num2str(nChan) ',' ...
%         num2str(winLength) ',' num2str(midPointsBool) '\n'];
%     ReportError(errorText,~batchModeBool)
% end
return

