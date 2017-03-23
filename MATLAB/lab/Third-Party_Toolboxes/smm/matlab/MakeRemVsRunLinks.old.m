% function MakeRemVsRunLinks(varargin)
% analName = 'RemVsRun04_allTheta_MinSpeed0wavParam6Win1250';
% remAnalName = 'CalcRemSpectra06_allTimes_wavParam6Win1250';
% runAnalName = 'CalcRunningSpectra15_allTheta_MinSpeed0wavParam6Win1250';
% [analDirs fileExtCell analName remAnalName runAnalName] = ...
%     DefaultArgs(varargin,{analDirs fileExtCell analName remAnalName runAnalName});
function MakeRemVsRunLinks(varargin)
analName = 'RemVsRun04_allTheta_MinSpeed0wavParam6Win1250';
remAnalName = 'CalcRemSpectra06_allTimes_wavParam6Win1250';
runAnalName = 'CalcRunningSpectra15_allTheta_MinSpeed0wavParam6Win1250';
[analDirs fileExtCell analName remAnalName runAnalName] = ...
    DefaultArgs(varargin,{{} {} analName remAnalName runAnalName});
%function MakeRemVsRunLinks(analDirs fileExtCell analName remAnalName runAnalName)
% analDirs = {...
%     '/BEEF01/smm/sm9601_Analysis/2-13-04/analysis/',...
%     '/BEEF01/smm/sm9601_Analysis/2-14-04/analysis/',...
%     '/BEEF01/smm/sm9601_Analysis/2-15-04/analysis/',...
%     '/BEEF01/smm/sm9601_Analysis/2-16-04/analysis/',...
%     '/BEEF01/smm/sm9603_Analysis/3-20-04/analysis/',...
%     '/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/',...
%     '/BEEF02/smm/sm9608_Analysis/7-15-04/analysis/',...
%     '/BEEF02/smm/sm9608_Analysis/7-16-04/analysis/',...
%     '/BEEF02/smm/sm9608_Analysis/7-17-04/analysis/',...
%     '/BEEF02/smm/sm9614_Analysis/4-16-05/analysis/',...
%     '/BEEF02/smm/sm9614_Analysis/4-17-05/analysis/',...
%     };
% fileExtCell = {...
%     '.eeg',...
%     '_LinNearCSD121.csd',...
%     %'_NearAveCSD1.csd',...
%     };
           
% analName = 'RemVsRun04_noExp_MinSpeed5wavParam6Win6250';
% remAnalName = 'CalcRemSpectra06_allTimes_wavParam6Win6250';
% runAnalName = 'CalcRunningSpectra15_noExp_MinSpeed5wavParam6Win6250';
% analName = 'RemVsRun05_noExp_MinSpeed5wavParam6Win1250';
% remAnalName = 'CalcRemSpectra06_allTimes_wavParam6Win1250';
% runAnalName = 'CalcRunningSpectra14_noExp_MinSpeed5wavParam6Win1250';

% analName = 'RemVsRun04_allTheta_MinSpeed0wavParam6Win1250';
% remAnalName = 'CalcRemSpectra06_allTimes_wavParam6Win1250';
% runAnalName = 'CalcRunningSpectra15_allTheta_MinSpeed0wavParam6Win1250';

% 
% [analDirs fileExtCell analName remAnalName runAnalName] = ...
%     DefaultArgs(varargin,{analDirs fileExtCell analName remAnalName runAnalName});

for j=1:length(analDirs)
    cd(analDirs{j})
    files = [LoadVar('FileInfo/RemFiles');LoadVar('FileInfo/MazeFiles')];
    for k=1:length(files)
        fprintf('\n%s',files{k})
        cd(files{k})
        for m=1:length(fileExtCell)
            %pwd
            %fprintf([analName fileExtCell{m}])
            %exist([analName fileExtCell{m}],'file')
            %exist([analName fileExtCell{m}],'dir')
            %ls([analName fileExtCell{m}])
            %if exist([analName fileExtCell{m}],'file') | exist([analName fileExtCell{m}],'dir')
                fprintf('\n%s',['!rm -r ' analName fileExtCell{m}])
                eval(['!rm -r ' analName fileExtCell{m}])
            %end
            if exist([remAnalName fileExtCell{m}],'dir')
                fprintf('\n%s',['!ln -s ' remAnalName fileExtCell{m} ' ' analName fileExtCell{m}])
                eval(['!ln -s ' remAnalName fileExtCell{m} ' ' analName fileExtCell{m}]);
            end
            if exist([runAnalName fileExtCell{m}],'dir')
                fprintf('\n%s',['!ln -s ' runAnalName fileExtCell{m} ' ' analName fileExtCell{m}])
               eval(['!ln -s ' runAnalName fileExtCell{m} ' ' analName fileExtCell{m}]);
            end
        end
        cd ..
    end
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


