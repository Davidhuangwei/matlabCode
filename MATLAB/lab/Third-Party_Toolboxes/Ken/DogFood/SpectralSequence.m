% Order = SpectralSequence(Mat, Mode)
%
% attempts to do linear arrangement by spectral sequencing
%
% if Mode=1, Mat is treated as a matrix of similarities
% if Mode=2, Mat is treated as a matrix of dissimilarities
% Modes 3 and 4 are the same but (dis)similarities are rank ordered

function order = SpectralSequence(Mat0, Mode)

Mat = Mat0;

if nargin<2
    Mode = 1;
end

if Mode>2
    Mat = reshape(RankOrder(Mat(:)), size(Mat));
    Mode = Mode-2;
end

% start by wiping diagonal of (dis)similarity matrix
Mat = Mat-diag(diag(Mat));

laplacian = diag(sum(Mat))-Mat;

[v d] = eig(laplacian);
[dummy eigorder] = sort(diag(d));

switch (Mode)
case 1
    [dummy order] = sort(v(:,eigorder(2)));
case 2
    [dummy order] = sort(v(:,eigorder(end)));
end

imagesc(Mat(order,order));
drawnow
return

% generate distances
x = randn(10,2);
dist = squareform(pdist(x,'euclid'));