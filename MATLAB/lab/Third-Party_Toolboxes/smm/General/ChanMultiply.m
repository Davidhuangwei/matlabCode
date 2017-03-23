function ChanMultiply(fileBaseCell,fileExt,nChan,multVect)

for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j};
    FileIn = [fileBase '/' fileBase fileExt];
    fprintf('Processing: %s\n',FileIn);
    data = bload(FileIn,[nChan inf]);
    multMat = repmat(multVect,[1 size(data,2)]);
    data = data.*multMat;
    bsave(FileIn,data);
end
    