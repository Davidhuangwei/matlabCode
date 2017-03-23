% 
%  covary - For vectors, covary(X) returns the variance of X.
%           For matrices, covary(X)is a row vector containing the
%           variance of each column of X.
%           
%           covary(X) normalizes by N-1 where N is the sequence length.  
%           This makes covary(X) the best unbiased estimate of the 
%           covariance if X are from a normal distribution.
%
%           Does not require the Matlab Signal Processing Toolbox

function covout = covary(data)

data = data - mean(mean(data));
if size(data,1) == 1
    data = data';   % make column vector
end
covout = sum(data.*data)/(size(data,1)-1);


