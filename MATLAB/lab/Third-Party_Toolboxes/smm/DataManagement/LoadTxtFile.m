% function outCell = LoadTxtFile(textFile)
% Loads textFile with each line occupying a row of a column cell array
% tag:text
% tag:load
% tag:txt
% tag:cell array
% tag:file

function outCell = LoadTxtFile(textFile)

fid = fopen(textFile);

j=1;
while 1
    temp = fgetl(fid);
    if temp == -1
        break
    else
    outCell{j,1} = temp;
    end
    j=j+1;
end
