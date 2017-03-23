function outStruct = GlmResultsCatAnimal(inStruct,varargin)
% function outStruct = CatAnimalGlmResults(inStruct,diagonalizeBool,depVarType)
[diagonalizeBool depVarType] = DefaultArgs(varargin,{0,' '});
outStruct = inStruct;
analNames = fieldnames(inStruct);
for j=1:length(analNames)
    varNames = fieldnames(inStruct.(analNames{j}));
    for r=1:length(varNames)
            outStruct.(analNames{j}).(varNames{r}) = cell(size(inStruct.(analNames{j}).(varNames{r}){1}));
        for k=1:length(inStruct.(analNames{j}).(varNames{r}))
            for n=1:size(inStruct.(analNames{j}).(varNames{r}){k},1)
                for p=1:size(inStruct.(analNames{j}).(varNames{r}){k},2)
                    outStruct.(analNames{j}).(varNames{r}){n,p} = cat(1,...
                        outStruct.(analNames{j}).(varNames{r}){n,p},...
                        inStruct.(analNames{j}).(varNames{r}){k}{n,p});
                end
            end
        end
    end
end
if diagonalizeBool
    for q=1:length(analNames)
        varNames = fieldnames(inStruct.(analNames{q}));
        for r=1:length(varNames)
            catData = {};
            temp1 = outStruct.(analNames{q}).(varNames{r});
            temp2 = flipud(rot90(temp1));
            
%%%%%%%%%%%%%%%%%%%%% hack code for combining layers %%%%%%%%%%%%%%%%%%%%%%%%%%%%           
%             for j=1:size(temp1,1)
%     test(j,:) = cat(2,{cat(1,temp1{j,1:4})},{cat(1,temp1{j,5:7})},{cat(1,temp1{j,8})});
% end
% temp1 = test;
% for j=1:size(temp2,2)
%     test(:,j) = cat(1,{cat(1,temp2{1:4,j})},{cat(1,temp2{5:7,j})},{cat(1,temp2{8,j})});
% end
% temp2 = test;     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            for j=1:size(temp1,1)
                for k=1:size(temp1,2)
                    if j==k % don't duplicate diagonal measurements
                        temp2{j,k} = [];
                    end
                    if strcmp(depVarType,'phase') & (strcmp(analNames{q},'coeffs') | strcmp(analNames{q},'categMeans'))
                        temp2{j,k} = -temp2{j,k}; % phases are opposite
                    end
                    if isempty(find([j k] > size(catData)))
                        catData{j,k} = cat(1,catData{j,k},temp1{j,k},temp2{j,k});
                    else
                        catData{j,k} = cat(1,temp1{j,k},temp2{j,k});
                    end
                end
            end
            outStruct.(analNames{q}).(varNames{r}) = catData;
        end
    end
end
return
       