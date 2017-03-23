function outData = FurcateData(furcateVec,data,varargin)
furcateFunc = DefaultArgs(varargin,{@round});

tempData = [];
for j=1:length(furcateVec)
    tempData = cat(1,tempData,shiftdim(clip(data,min(furcateVec),max(furcateVec))-furcateVec(j),-1));
end
[minVal minInd] = min(furcateFunc(abs(tempData)*10^6),[],1);
minInd = shiftdim(minInd,1);
outData = furcateVec(minInd);


