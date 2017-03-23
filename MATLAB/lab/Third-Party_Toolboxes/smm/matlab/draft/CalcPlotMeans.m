function outCell = CalcPlotMeans(categDataCell,numbers)
keyboard

for i=1:size(categDataCell{1},2) %for each column
    categs{i} = FindUniqueStrings(categDataCell{1}(:,i));
end
keyboard
