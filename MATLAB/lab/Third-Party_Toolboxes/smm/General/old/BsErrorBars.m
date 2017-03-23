function varargout = BsErrBars(centroidFunc,percConf,Resamp,func,resampArgNum,varargin)
% function varargout = BsErrBars(centroidFunc,percConf,Resamp,func,resampArgNum,varargin)
% tag:bootstrap
% tag:resampling
% tag:error bars
varargout = cell(nargout,1);
bsData = cell(nargout,1);
[bsData{:}] = BsFunc(Resamp,func,resampArgNum,varargin)
for j=1:length(bsData)
    varargout{j} = squeeze(centroidFunc(bsData{j}));
    lowErr = bsData{j}(find(bsData{j}<=
    varargout{j}

temp = cell(nargout,1);
% saveData = zeros(nResamp,length(varargin{resampArgNum}));
origData = varargin{resampArgNum};
for j=1:nResamp
    randData = randsample(origData,length(origData),'true');
%     saveData = cat(1,saveData,shiftdim(randData,-1));
    varargin{resampArgNum} = randData;
    [temp{:}] = func(varargin{:});
    for k=1:length(temp)
        varargout{k} = cat(1,varargout{k},shiftdim(squeeze(temp{k}),-1));
    end
end
% keyboard
return