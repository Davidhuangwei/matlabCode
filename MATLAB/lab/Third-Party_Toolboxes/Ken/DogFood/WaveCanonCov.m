% WaveCanonCov
%
% does a canonical correlation analysis on
% intra/extra spikes

% load up data

% X is intra cellular spikes
X = squeeze( SpikeExtract('d1512101.dat', 'IntraSpikes.res', 6, 5, 20, 100) )';
% Y is (filtered) extra cellular
Y = squeeze( SpikeExtract('tetrode.fil', 'IntraSpikes.res', 4, 2, 20, 100) )';

% Make covariance matrices
XSize = size(X, 2);
YSize = size(Y, 2);

BigCov = cov([X, Y]);
CXX = BigCov(1:XSize, 1:XSize);
CYY = BigCov(XSize+1:end, XSize+1:end);
CXY = BigCov(1:XSize, XSize+1:end);

% make -1/2 powers ...

CXXMH = CXX ^ -0.5;
CYYMH = CYY ^ -0.5;

% matrix to do svd on ...
M = CXXMH * CXY * CYYMH;

% do svd
[c s d] = svd(M);

% then calculate a and b

a = CXXMH * c;
b = CYYMH *d;
R2 = diag(s);

% now plot covariance of waves with original data
clf
subplot(2,1,1)
plot(( a(:,1:2)' *CXX*(diag(var(X))^0))')
% superimpose a mean spike
hold on
plot(mean(X, 1)/20, 'k--');
subplot(2,1,2)
plot(( b(:,1:2)' *CYY*(diag(var(Y))^0))')
% superimpose a mean spike
hold on
plot((mean(Y, 1)+2048)/10, 'k--');
