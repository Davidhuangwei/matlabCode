% function MakeSpectAnalDirLinks(fileBaseCell,spectAnalBaseCell,linkDirBase,fileExtCell)
function MakeSpectAnalDirLinks(fileBaseCell,spectAnalBaseCell,linkDirBase,fileExtCell)

cwd = pwd;
for j=1:length(fileBaseCell)
    cd(fileBaseCell{j})
    for k=1:length(spectAnalBaseCell)
        for m=1:length(fileExtCell)
            if exist([spectAnalBaseCell{k} fileExtCell{m}],'dir')
                fOpt = '';
                if exist([linkDirBase fileExtCell{m}],'dir')
                    inText = [];
                    while ~strcmp(inText,'n') & ~strcmp(inText,'y')
                        inText = input(['FILE EXISTS: ' [linkDirBase fileExtCell{m}] ', OVERWRITE? y/n: '],'s');
                    end
                    if strcmp(intext,'y')
                        fOpt = 'f';
                    end
                end
                evalText = ['!ln -s' fOpt ' ' spectAnalBaseCell{k} fileExtCell{m}...
                    ' ' linkDirBase fileExtCell{m}];
                EvalPrint(evalText,0);
            else
                warning('MakeSpectAnalDirLinks:directoryMissing',...
                    ['Directory ' SC(pwd) [spectAnalBaseCell{k} fileExtCell{m}] ' does not exist']);
            end
        end
    end
    cd(cwd)
end
                    
     
return

analDirs = {...
            %'/BEEF02/smm/sm9614_Analysis/analysis02/',...
            %'/BEEF02/smm/sm9608_Analysis/analysis02',...
            %'/BEEF01/smm/sm9601_Analysis/analysis03/',...
            '/BEEF01/smm/sm9603_Analysis/analysis04/',...
            };
fileExtCell = {...
                %'.eeg',...
                '_LinNearCSD121.csd',...
                %'_NearAveCSD1.csd',...
                }      
remAnalName = 'CalcRemSpectra_temp_allTimes_Win1250';
for j=1:length(analDirs)
    cd(analDirs{j})
    files = [LoadVar('RemFiles')];
    for k=1:size(files,1)
        fprintf('\n%s',files(k,:))
        cd(files(k,:))
        for m=1:length(fileExtCell)
            cd([remAnalName fileExtCell{m}])
            fprintf('\n%s',[remAnalName fileExtCell{m}])
            times = LoadVar('time');
            in  = 'y';
            if exist('mazeLocation.mat','file')
                in = input('\nmazeLocation.mat exists. Overwrite? y/[n]: ','s');
            end
            if strcmp(in,'y')
                mazeLocation = repmat([1 1 1 1 1 1 1 1 1],length(times),1);
                save('mazeLocation.mat',SaveAsV6,'mazeLocation');
            end
            if exist('trialType.mat','file')
                in = input('\trialType.mat exists. Overwrite? y/[n]: ','s');
            end
            if strcmp(in,'y')
                trialType = repmat([1 1 1 1 1 1 1 1 1 1 1 1 1],length(times),1);
                save('trialType.mat',SaveAsV6,'trialType');
            end           
            cd ..
        end
        cd ..
    end
end


