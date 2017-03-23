analDirs = {...
    '/BEEF01/smm/sm9601_Analysis/2-13-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-14-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-15-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-16-04/analysis/',...
    '/BEEF01/smm/sm9603_Analysis/3-20-04/analysis/',...
    '/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-15-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-16-04/analysis/',...
    '/BEEF02/smm/sm9614_Analysis/4-16-05/analysis/',...
    '/BEEF02/smm/sm9614_Analysis/4-17-05/analysis/',...
    }
analDirs = {...
    '/BEEF03/smm/drugs/DrugsAnal/sm9608_448-455/analysis/',...
    '/BEEF03/smm/drugs/DrugsAnal/sm9614_564-575/analysis/',...
    '/BEEF03/smm/drugs/DrugsAnal/sm9614_544-557/analysis/',...
    }


analDirs = {...
    '/BEEF03/smm/drugs/DrugsAnal/sm9614_564-575/analysis/',...
    '/BEEF02/smm/sm9614_Analysis/4-16-05/analysis/',...
    '/BEEF02/smm/sm9614_Analysis/4-17-05/analysis/',...
};
fileExtCell = {...
    '.eeg',...
    '_LinNearCSD121.csd',...
    }

spectDir = 'CalcRunningSpectra11_noExp*'

mkdir('ChanInfo')
for j=1:length(analDirs)
    files = dir([analDirs{j} 'sm96*']);
    for k=1:length(files)
        if exist([analDirs{j} files(k).name spectDir
        if ~exist(files(k).name,'dir')
            mkdir(files(k).name)
        end
    end
end
for k=1:length(fileExtCell)
    for j=1:length(analDirs)
        
        files = dir([analDirs{j} 'sm96*']);
        for m=1:length(files)
            if exist([analDirs{j} files(m).name spectDir fileExtCell{k}])
                if ~exist(files(m).name,'dir')
                    mkdir(files(m).name)
                end
                eval(['!cp ' analDirs{j} files(m).name spectDir fileExtCell{k} ' ' files(m).name]);
            end
        end

        oldChanLoc = LoadVar([analDirs{j} 'ChanInfo/ChanLoc' fileExtCell{k} '.mat']);
        oldSelChan = LoadVar([analDirs{j} 'ChanInfo/SelChan' fileExtCell{k} '.mat']);
        oldBadChan = LoadVar([analDirs{j} 'ChanInfo/BadChan' fileExtCell{k} '.txt']);
        anatLayers = fieldNames(oldChanLoc);
        for m=1:length(anatLayers)
            nShanks = length(oldChanLoc.(anatLayers{m}));
            for n=1:nShanks
                chans = setdiff(oldChanLoc.(anatLayers{m}){n},union(oldSelChan.(anatLayers{m}),oldBadChan));
                if isempty(chans)
                    chanLoc.(anatLayers{m}){n} = [];
                    MakeEmpty
                else
                    if j==1 | ~isempty(chanLoc.(anatLayers{m}){n})
                        chanLoc.(anatLayers{m}){n} = (m-1)*nShanks+n;
                    end
                    MakeNewChans
                end
            end
        end
    end
    save(['ChanInfo/ChanLoc' fileExtCell{k} '.mat'],SaveAsV6,'chanLoc');
    clear chanLoc






