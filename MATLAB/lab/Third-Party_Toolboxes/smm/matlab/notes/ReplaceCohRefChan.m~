goodDir = 'RemVsRun_noExp_MinSpeed0Win1250_LinNearCSD121.csd/';
newDir = 'RemVsRun_temp_noExp_MinSpeed0Win1250_LinNearCSD121.csd/';
oldCh = 'ch13';
newCh = 'ch62';
fileBaseMat = LoadVar('AllFiles');

files = {...
    'cohSpec.mat',...
    'crossSpec.mat',...
    'phaseSpec.mat',...
    }
vars = {...
    'cohSpec',...
    'crossSpec',...
    'phaseSpec',...
    }
for k=1:size(fileBaseMat,1)
    for j=1:length(files)
        if ~exist([fileBaseMat(k,:) '/' goodDir files{j} '.backup'],'file')
            eval(['!cp ' fileBaseMat(k,:) '/' goodDir files{j} ' ' fileBaseMat(k,:) '/' goodDir files{j} '.backup'])
        end
        if ~exist([fileBaseMat(k,:) '/' newDir files{j} '.backup'],'file')
            eval(['!cp ' fileBaseMat(k,:) '/' newDir files{j} ' ' fileBaseMat(k,:) '/' newDir files{j} '.backup'])
        end
       
        goodVar = LoadVar([fileBaseMat(k,:) '/' goodDir files{j}]);
        fields = fieldnames(goodVar.yo);
        newVar = LoadVar([fileBaseMat(k,:) '/' newDir files{j}]);
        
        if newVar.fo ~= goodVar.fo
            fprintf('ERROR: newVar.fo ~= goodVar.fo')
            keyboard
        end

        newVar.yo.(oldCh) = goodVar.yo.(oldCh);
        goodVar.yo.(newCh) = newVar.yo.(newCh);

        goodVar.yo = rmfield(goodVar.yo,oldCh);
        goodVar.yo = orderfields(goodVar.yo,[{newCh}; fields(2:6)]);

        eval([vars{j} '=goodVar']);
        save([fileBaseMat(k,:) '/' goodDir files{j}],SaveAsV6,vars{j});
        eval([vars{j} '=newVar']);
        save([fileBaseMat(k,:) '/' newDir files{j}],SaveAsV6,vars{j});
    end
end


files = {...
    'gammaCohMean60-120Hz.mat',...
    'gammaCohMedian60-120Hz.mat',...
    'gammaPhaseMean60-120Hz.mat',...
    'thetaCohMean4-12Hz.mat',...
    'thetaCohMedian4-12Hz.mat',...
    'thetaCohPeakLMF4-12Hz.mat',...
    'thetaCohPeakSelChF4-12Hz.mat',...
    'thetaPhaseMean4-12Hz.mat',...
    }
vars = {...
    'gammaCohMean',...
    'gammaCohMedian',...
    'gammaPhaseMean',...
    'thetaCohMean',...
    'thetaCohMedian',...
    'thetaCohPeakLMF',...
    'thetaCohPeakSelChF',...
    'thetaPhaseMean',...
    }
for k=1:size(fileBaseMat,1)
    for j=1:length(files)
        if ~exist([fileBaseMat(k,:) '/' goodDir files{j} '.backup'],'file')
            eval(['!cp ' fileBaseMat(k,:) '/' goodDir files{j} ' ' fileBaseMat(k,:) '/' goodDir files{j} '.backup'])
        end
        if ~exist([fileBaseMat(k,:) '/' newDir files{j} '.backup'],'file')
            eval(['!cp ' fileBaseMat(k,:) '/' newDir files{j} ' ' fileBaseMat(k,:) '/' newDir files{j} '.backup'])
        end
       
        goodVar = LoadVar([fileBaseMat(k,:) '/' goodDir files{j}]);
        fields = fieldnames(goodVar)
        newVar = LoadVar([fileBaseMat(k,:) '/' newDir files{j}]);
        
        newVar.(oldCh) = goodVar.(oldCh);
        goodVar.(newCh) = newVar.(newCh);

        goodVar = rmfield(goodVar,oldCh);
        goodVar = orderfields(goodVar,[{newCh}; fields(2:6)]);

        eval([vars{j} '=goodVar']);
        save([fileBaseMat(k,:) '/' goodDir files{j}],SaveAsV6,vars{j});
        eval([vars{j} '=newVar']);
        save([fileBaseMat(k,:) '/' newDir files{j}],SaveAsV6,vars{j});
    end
end
