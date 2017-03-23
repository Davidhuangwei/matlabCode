function ExtractGlmCoh09(depVarCell,spectAnalDir,fileExt,chanLocVersion,analRoutine,analDirs,varargin)
[saveDir statsDir] = DefaultArgs(varargin,{'/u12/smm/public_html/NewFigs/REMPaper/UnitFieldMetaAnal/','GlmWholeModel08'});
prevWarn = SetWarnings({'off','MATLAB:divideByZero'});
%for paper
% nonSigSat = 0.15
% nonSigVal = 1

chanInfoDir = 'ChanInfo/';

depVarPoss = {...
    'gammaCohMean60-120Hz',...
    'gammaCohMean40-100Hz',...
    'gammaCohMean40-120Hz',...
    'gammaCohMean50-100Hz',...
    'gammaCohMean50-120Hz',...
    'thetaCohMean6-12Hz',...
    'thetaCohPeakSelChF6-12Hz',...
    'thetaCohMedian6-12Hz',...
    'gammaCohMedian60-120Hz',...
    'thetaCohPeakLMF6-12Hz',...
    'gammaCohMean40-100Hz',...
    'thetaCohMean4-12Hz',...
    'thetaPhaseMean4-12Hz',...
    'thetaPhaseMean6-12Hz',...
    'gammaPhaseMean40-100Hz',...
    'gammaPhaseMean40-120Hz',...
   };


depVarCell = intersect(depVarCell,depVarPoss);

anatNames = fieldnames(LoadVar([analDirs{1}{1} 'ChanInfo/ChanLoc_' chanLocVersion fileExt]));

for a=1:length(depVarCell)
    depVar = depVarCell{a}

    if ~isempty([strfind(depVar,'Phase') strfind(depVar,'phase')])
        depVarType = 'phase';
        selChanNames = fieldnames(LoadVar([analDirs{1}{1} 'ChanInfo/SelChan' fileExt]));
        selChanBool = 1;
    elseif ~isempty([strfind(depVar,'Coh') strfind(depVar,'coh')])
        depVarType = 'coh';
        selChanNames = fieldnames(LoadVar([analDirs{1}{1} 'ChanInfo/SelChan' fileExt]));
        selChanBool = 1;
    elseif ~isempty([strfind(depVar,'Pow') strfind(depVar,'pow')]);
        depVarType = 'pow';
        selChanNames = {''};
        selChanBool = 0;
    else
        depVarType = 'undef';
        selChanNames = {''};
        selChanBool = 0;
    end
    
    dataStruct = GlmResultsLoad01(depVar,chanLocVersion,spectAnalDir,fileExt,analRoutine,analDirs,statsDir,selChanBool);
    dataStruct = GlmResultsCatAnimal(dataStruct,1,depVarType);
    
    
    outCell = {};
    varNames = fieldnames(dataStruct.coeffs);
    for k=1:length(anatNames)
        for m=1:length(selChanNames)
            tempMean = [];
            tempstd = [];
            for j=2:length(varNames)
                tempMean(j) = mean(dataStruct.coeffs.(varNames{j}){k,m},1);
                tempStd(j) = std(dataStruct.coeffs.(varNames{j}){k,m},1);
            end
            for j=2:length(varNames)
                outCell = cat(1,outCell,...
                    cat(2,anatNames(k),selChanNames(m),varNames(j),...
                    tempMean(j)/mean(tempStd)));
            end
        end
    end
    outCell = cat(2,repmat(depVarCell(a),[size(outCell,1),1]),...
        repmat({Dot2Underscore(fileExt)},[size(outCell,1),1]),...
        outCell);

    outDir = [saveDir SC(analRoutine(1:end-3))];
    mkdir(outDir)
    save([outDir depVarCell{a} ...
        Dot2Underscore(fileExt) '.mat'],SaveAsV6,'outCell');
end



% 
% outCell = {};
%     varNames = fieldnames(dataStruct.coeffs);
%     for j=2:length(varNames)
%     for k=1:length(anatNames)
%         for m=1:length(selChanNames)
%             outCell = cat(1,outCell,...
%                 cat(2,anatNames(k),selChanNames(m),varNames(j),...
%                 mean(dataStruct.coeffs.(varNames{j}){k,m},1)));
%         end
%     end
%     end
%     outCell = cat(2,repmat(depVarCell(a),[size(outCell,1),1]),outCell);
%             
%     outDir = [saveDir SC(analRoutine(1:end-3))];
%     mkdir(outDir)
%         save([outDir depVarCell{a} '.mat'],SaveAsV6,'outCell');
end
