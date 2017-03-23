% cirmean - calculates mean phase and radius of a given
%           circular statistics
%
% function [theta, r]  = circmean(data);
% (data has to be in the unit of radians)

function [theta, r]  = nancircmean(xdata,varargin);
[dim] = DefaultArgs(varargin,{1});

% convert the data into complex represenation

% if length(data_rad)==0
% 	theta = 0;
% 	r = 0;
% 	return;
% end

%data = data_rad(find(~isnan(data_rad)));

data = xdata(find(~isnan(data)));

datai = exp(data * i);

datas = sum(datai);
r = abs(datas)./repmat(size(data,1),1,size(data,2));
theta = angle(datas);

