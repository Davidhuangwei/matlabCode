% function varargout = BsErrBars(centroidFunc,percConf,nResamp,func,resampArgNum,varargin)
% calculates error bars on the bootstrap resampled data calculated using
% BsFunc 
% tag:bootstrap
% tag:resampling
% tag:error bars
function varargout = BsErrBars(centroidFunc,percConf,nResamp,func,resampArgNum,varargin)
varargout = cell(nargout,1);
bsData = cell(nargout,1);
[bsData{:}] = BsFunc(nResamp,func,resampArgNum,varargin{:});
for j=1:length(bsData)
    varargout{j} = squeeze(centroidFunc(bsData{j}));
    for k=1:size(squeeze(shiftdim(bsData{j},1)),1);
%         [n x] = hist(bsData{j}(:,k),100);
%         confBars(:,k) = cat(1,x(100-percConf+1),x(percConf));
        confBars(:,k) = cat(1,prctile(bsData{j}(:,k),100-percConf),...
            prctile(bsData{j}(:,k),percConf));
    end
    varargout{j} = cat(1,varargout{j},confBars);
end
return
