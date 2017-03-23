function outStruct = CellArray2Struct(inCell)
%function outStruct = CellArray2Struct(inCell)
%Each row of inCell delineates a branch of outStruct ending in the
%in the data at inCell(i,end)
%The inverse of Struct2CellArray

outStruct = [];
for i=1:size(inCell,1)
    evalText = ['outStruct'];
    for j=1:size(inCell,2)-1
        evalText = [evalText  '.' inCell{i,j} ''];
    end
    keyboard
    evalText = [evalText '=inCell{' num2str(i) ',end};'];
    eval(evalText);
end
