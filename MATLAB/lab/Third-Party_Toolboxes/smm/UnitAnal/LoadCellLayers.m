function cellTypeCell = LoadCellTypes(cellTypeFile)

fid = fopen(cellTypeFile);

j=1;
while 1
    temp = fgetl(fid);
    if temp == -1
        break
    else
        spaces = strfind(temp,' ');
        cellTypeCell{j,1} = str2num(temp(1:spaces(1)-1));
        cellTypeCell{j,2} = str2num(temp(spaces(1)+1:spaces(2)-1));
        cellTypeCell{j,3} = temp(spaces(2)+1:end);
%         cellTypeCell{j,4} = str2num(temp(spaces(3)+1:end));
    end
    j=j+1;
end
