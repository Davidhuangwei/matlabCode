% function k=kurt(data)
%
% Calculates kurtosis or normalized 4th moment of an input data vector
% Given a matrix, returns a row vector giving the kurtosis' of the columns
% (Ref: "Numerical Recipes," p. 612)
%

% Martin Mckeown, CNL / Salk 10/2/96
% 2/28/97 - made to return separate kurtosis estimates of columns -Scott Makeig

function [k] = kurt(data)

[r,c]=size(data);
if r==1,
	kdata = data';  % if a row vector, make into a column vector
    r = c;
else
    kdata = data;
end
%fprintf('size of kdata = [%d,%d]\n',size(kdata,1),size(kdata,2));

mn = mean(kdata);              % find the column means
diff = kdata-ones(r,1)*mn;     % remove the column means
dsq = diff.*diff;              % square the data

k =  (sum(dsq.*dsq)./std(kdata).^4)./r - 3;

