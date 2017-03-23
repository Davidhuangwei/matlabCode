files = ls2('*.mat')

for i=1:size(files,1)
    load(files{i});
    fileBaseCell = mat2cell(fileBaseMat,repmat(1,size(fileBaseMat,1),1),size(fileBaseMat,2))
    beginTimes = beginTimeMat;
    save([files{i}(1:end-4) '_old.mat'],'fileBaseMat','beginTimeMat');
    save(files{i},'fileBaseCell','beginTimes');
end
