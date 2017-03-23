%%%% make backups %%%%
   animalDirs = {...
        '/BEEF01/smm/sm9601_Analysis/analysis03/',...
        '/BEEF01/smm/sm9603_Analysis/analysis04/',...
        '/BEEF02/smm/sm9614_Analysis/analysis02'...
        '/BEEF02/smm/sm9608_Analysis/analysis02/',...
        };
chanInfoDir = 'ChanInfo/';
chanLocCell = {'Min','Full'};
fileExtCell = {'.eeg','_LinNear.eeg','_LinNearCSD121.csd'};
for j=1:length(animalDirs)
    fprintf('\n%s',animalDirs{j})
    cd(animalDirs{j});
    for k=1:length(chanLocCell)
        for m=1:length(fileExtCell)
    evalText = ['!cp ' chanInfoDir 'ChanLoc_' chanLocCell{k} fileExtCell{m} '.mat ' ...
        chanInfoDir 'ChanLoc_' chanLocCell{k} fileExtCell{m} '.mat.backup'];
    fprintf('\n%s',evalText)
    eval(evalText);
        end
    end
end
    




%%%% rename %%%%%

   animalDirs = {...
        '/BEEF01/smm/sm9601_Analysis/analysis03/',...
        '/BEEF01/smm/sm9603_Analysis/analysis04/',...
        '/BEEF02/smm/sm9614_Analysis/analysis02'...
        '/BEEF02/smm/sm9608_Analysis/analysis02/',...
        };
chanInfoDir = 'ChanInfo/';
chanLocCell = {'Min','Full'};
fileExtCell = {'.eeg','_LinNear.eeg','_LinNearCSD121.csd'};
for j=1:length(animalDirs)
    fprintf('\n%s',animalDirs{j})
    cd(animalDirs{j});
    for k=1:length(chanLocCell)
        for m=1:length(fileExtCell)
            if exist([chanInfoDir 'ChanLoc_' chanLocCell{k} fileExtCell{m} '.mat'],'file')
                chanLoc = LoadVar([chanInfoDir 'ChanLoc_' chanLocCell{k} fileExtCell{m} '.mat']);
                newFields = {'or','ca1Pyr','rad','lm','mol','gran','hil','ca3Pyr'};
                oldFields = fieldnames(chanLoc);
                for n=[1:6 8 7]
                    chanLoc2.(newFields{n}) = chanLoc.(oldFields{n});
                end
                chanLoc = chanLoc2;
                save([chanInfoDir 'ChanLoc_' chanLocCell{k} fileExtCell{m} '.mat'],...
                    SaveAsV6,'chanLoc');
            end
       end
    end
end







chanLoc = LoadVar([chanInfoDir 'ChanLoc_' chanLocCell{k} fileExtCell{m} '.mat'])



animalDirs = {...
        '/BEEF01/smm/sm9601_Analysis/analysis03/',...
        '/BEEF01/smm/sm9603_Analysis/analysis04/',...
        '/BEEF02/smm/sm9614_Analysis/analysis02'...
        '/BEEF02/smm/sm9608_Analysis/analysis02/',...
        };
chanInfoDir = 'ChanInfo/';

chanLocCell = {'Min','Full'};
fileExtCell = {'.eeg'};
k=1;
m=1;

chanLoc = LoadVar([chanInfoDir 'ChanLoc_' chanLocCell{k} fileExtCell{m} '.mat'])
newFields = {'or','ca1Pyr','rad','lm','mol','gran','hil','ca3Pyr'}
oldFields = fieldnames(chanLoc);
for n=[1:6 8 7]
    chanLoc2.(newFields{n}) = chanLoc.(oldFields{n});
end
chanLoc2





