function outputCell = tempPars(inputCell)

outputCell = {};

if length(inputCell)>1
	for i=1:length(inputCell{1})
		returned = tempPars(inputCell(2:end));
		outputCell = cat(1,outputCell,cat(2,repmat(inputCell{1}(i),size(returned,1),1),returned));
	end
	

else
	outputCell = inputCell{1}(:);

end
return



