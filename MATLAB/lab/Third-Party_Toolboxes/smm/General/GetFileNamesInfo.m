function fileNamesInfo = GetFileNamesInfo(fileBaseCell,varargin)
%function fileNamesInfo = GetFileNamesInfo(fileBaseCell,varargin)
%fileNameFormat = DefaultArgs(varargin,{[]});

fileNameFormat = DefaultArgs(varargin,{[]});
if ~isempty(fileNameFormat)
    if fileNameFormat == 1,
        fileNamesInfo = [fileBaseCell{1}([1 2:4 5 6:8]) '-' fileBaseCell{end}([1 2:4 5 6:8])];
    elseif fileNameFormat == 0,
        fileNamesInfo = [fileBaseCell{1}([1:7 10:12 14 17:19]) '-' fileBaseCell{end}([7 10:12 14 17:19])];
    elseif fileNameFormat == 2,
        fileNamesInfo = [ fileBaseCell{1}(1:end) '-' fileBaseCell{end}(8:10)];
    end
else
    if strcmp(fileBaseCell{1}([1:6]),'sm9603') | strcmp(fileBaseCell{1}([1:6]),'sm9601'),
        fileNamesInfo = [fileBaseCell{1}([1:7 10:12 14 17:19]) '-' fileBaseCell{end}([7 10:12 14 17:19])];
    elseif strcmp(fileBaseCell{1}([1:6]),'sm9608') | strcmp(fileBaseCell{1}([1:6]),'sm9614'),
        fileNamesInfo = [ fileBaseCell{1}(1:end) '-' fileBaseCell{end}(8:10)];
    end
end

return