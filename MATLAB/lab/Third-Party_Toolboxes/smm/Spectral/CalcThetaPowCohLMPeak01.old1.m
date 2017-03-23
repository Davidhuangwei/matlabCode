function CalcThetaPowCohLMPeak01(saveDir,fileBaseCell,fileExt,thetaFreqRange)

saveVarCell = {...
    'thetaPowLMPeak',...
    'thetaCohLMPeak',...
    'thetaPhaseLMPeak',...
    'thetaCohWavLMPeak',...
%     'gammaPowMean',...
%     'thetaPowMean',...
%     'gammaPowPeak',...
%     'thetaCohMedian',...
%     'gammaCohMedian',...
    };
infoStruct = [];
infoStruct = setfield(infoStruct,'fileExt',fileExt);
infoStruct = setfield(infoStruct,mfilename,mfilename);
infoStruct = setfield(infoStruct,'saveDir',saveDir);
infoStruct = setfield(infoStruct,'thetaFreqRange',thetaFreqRange);


try
    for j=1:length(fileBaseCell)
        fileBase = fileBaseCell{j};
        infoStruct = setfield(infoStruct,'fileBase',fileBase);

         dirName = [fileBase '/' saveDir '/'];
         if exist([dirName '/infoStruct.mat'],'file')
             infoStruct = MergeStructs(LoadVar([dirName '/infoStruct.mat']),infoStruct,1);
         end

        fprintf('Processing: %s; %s%s\n',mfilename,fileBase,fileExt);

        if ~exist(dirName,'dir')
            fprintf('\nERROR: %s not found\n',dirName)
        else
            load([dirName 'powSpec.mat'],'-mat')
            thetaFreqLM = LoadVar([dirName 'thetaFreqLM' num2str(thetaFreqRange(1))...
                '-' num2str(thetaFreqRange(2)) 'Hz']);
            powSpec.yo = 10.^(powSpec.yo./10);
            fo = powSpec.fo;

            [freqTemp freqInd] = FurcateData(fo,thetaFreqLM,'round');
            
            if ~isempty(thetaFreqRange)
                for k=1:length(freqInd)
                    thetaPowLMPeak(k,:) = squeeze(10.*log10(powSpec.yo(k,:,freqInd(k))));
                end
            end
            
            load([dirName 'cohSpec.mat'],'-mat')
            load([dirName 'cohWavSpec.mat'],'-mat')
            load([dirName 'phaseSpec.mat'],'-mat')
            fo = cohSpec.fo;
            selectedChannels = fieldnames(cohSpec.yo);
            
            [freqTemp freqInd] = FurcateData(fo,thetaFreqLM,'round');

  
            for m=1:length(selectedChannels)
                %selChanName = ['ch' num2str(selectedChannels(m))];
                selChanName = selectedChannels{m};
                cohYo = cohSpec.yo.(selChanName);
                cohWavYo = cohWavSpec.yo.(selChanName);
                phaseYo = phaseSpec.yo.(selChanName);
                
                if ~isempty(thetaFreqRange)
                    for k=1:length(freqInd)

                        thetaCohLMPeak.(selChanName)(k,:) = squeeze(cohYo(k,:,freqInd(k)));
                        thetaPhaseLMPeak.(selChanName)(k,:) = squeeze(phaseYo(k,:,freqInd(k)));
                        thetaCohWavLMPeak.(selChanName)(k,:) = squeeze(cohWavYo(k,:,freqInd(k)));
                    end
                end

            end
            
            fprintf('Saving: %s, %i trials\n',dirName,size(thetaPowLMPeak,1))

            save([dirName '/infoStruct.mat'],SaveAsV6,'infoStruct');
            saveBase = '';
            if ~isempty(thetaFreqRange)
                if ~isempty(intersect(saveVarCell,'thetaPowLMPeak'))
                    save([dirName saveBase 'thetaPowLMPeak' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaPowLMPeak');
                end
                if ~isempty(intersect(saveVarCell,'thetaCohLMPeak'))
                    save([dirName saveBase 'thetaCohLMPeak' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaCohLMPeak');
                end
                if ~isempty(intersect(saveVarCell,'thetaCohWavLMPeak'))
                    save([dirName saveBase 'thetaCohWavLMPeak' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaCohWavLMPeak');
                end
                if ~isempty(intersect(saveVarCell,'thetaPhaseLMPeak'))
                    save([dirName saveBase 'thetaPhaseLMPeak' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaPhaseLMPeak');
                end
            end
            clear thetaPowLMPeak;
            clear thetaCohLMPeak;
            clear thetaCohWavLMPeak;
            clear thetaPhaseLMPeak;
        end
    end
catch
    ReportError(['/u12/smm/BatchLogs/MatlabLog.txt'],...
        ['ERROR:  ' date '  mfilename  ' fileBaseCell{j} '  ' fileExt '  ' ...
        'theta=' num2str(thetaFreqRange) 'hz  ' saveDir '\n']);
    cd(currDir);
end
return

%%%%%%% testing code %%%%%%%% 
baseNames = {'thetaPowPeak6-12Hz','thetaPowIntg6-12Hz','gammaPowPeak65-100Hz','gammaPowIntg65-100Hz'};
for j=1:length(baseNames)
    test = LoadVar(['Test_' baseNames{j} '.mat']);
    old = LoadVar([baseNames{j} '.mat']);
    if abs(test-old) > 10e-10
        fprintf('ERROR: %s failed 10e-10',baseNames{j});
    else
        fprintf('aok\n')
    end
end
baseNames = {'thetaCohMedian6-12Hz','thetaCohMean6-12Hz','thetaPhaseMean6-12Hz','gammaCohMedian65-100Hz','gammaCohMean65-100Hz','gammaPhaseMean65-100Hz'};
for j=1:length(baseNames)
    test = LoadVar(['Test_' baseNames{j} '.mat']);
    old = LoadVar([baseNames{j} '.mat']);
    fields = fieldnames(test);
    for k=1:length(fields)
        if test.(fields{k}) ~= old.(fields{k})
            fprintf('ERROR: %s failed 10e-10',baseNames{j});
        else
            fprintf('aok:%s%s\n',baseNames{j},fields{k})
        end
    end
end

chan=37;
spectVar = 'powSpec.yo';
freqVar = 'powSpec.fo';
tfr = [6 12];
gfr = [40 60;40 100;40 120;50 100;50 120;60 120];
thetaPowVars = {...
    ['thetaPowMean' num2str(tfr(1)) '-' num2str(tfr(2)) 'Hz'],...
    ['thetaPowIntg' num2str(tfr(1)) '-' num2str(tfr(2)) 'Hz'],...
    };
for j=1:size(gfr,1)
gammaPowVars{j} = ['gammaPowMean' num2str(gfr(j,1)) '-' num2str(gfr(j,2)) 'Hz'];
%     ['gammaPowIntg' num2str(gfr(1)) '-' num2str(gfr(2)) 'Hz'],...
end
% gammaPowVars = {...
%     ['gammaPowMean' num2str(gfr(1)) '-' num2str(gfr(2)) 'Hz'],...
%     ['gammaPowIntg' num2str(gfr(1)) '-' num2str(gfr(2)) 'Hz'],...
%     };
for j=1:length(thetaPowVars)
    thetaPow{j} = LoadVar(thetaPowVars{j});
end
for j=1:length(gammaPowVars)
    gammaPow{j} = LoadVar(gammaPowVars{j});
end
yo = LoadField(spectVar);
fs = LoadField(freqVar);
for j=1:size(yo,1)
    figure(1)
    clf
    plot(fs,squeeze(yo(j,chan,:)),'k');
    hold on
    for k=1:length(thetaPow)
        plot(tfr,[thetaPow{k}(j,chan) thetaPow{k}(j,chan)])
    end
    for k=1:length(gammaPow)
        plot(gfr(k,:),[gammaPow{k}(j,chan) gammaPow{k}(j,chan)])
    end
    set(gca,'xlim',[0 150],'xtick',[0:20:140],'ylim',[40 90])
    grid on
    if ~isempty(input('any input breaks: ','s'))
        break
    end
end


