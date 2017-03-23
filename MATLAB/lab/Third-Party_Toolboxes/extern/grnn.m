function [predc,sep] = grnn(cal,cconc,pred,actc,smooth)
% PROBNN  generalized regression neural network
% Author:	Ron Shaffer
% 		Naval Research Laboratory
%		shaffer@ccf.nrl.navy.mil
% Revisions:	Version 1.0 4/10/96 Original Code
%
% [predc,sep] = grnn(cal,cconc,pred,pconc,smooth)
% predc:	Predicted concentrations
% sep:		Squared error of prediction
% cal:		Calibration data
% cconc:	concentrations for calibration data
% pred:		prediction data
% pconc:	concentrations for prediction data
% smooth:	smoothing factor
% NOTE:  Use this code at your own risk because the author assumes no liability! 

%
% GRNN algorithm implemented here was derived from:
% D.F. Specht, A General Regression Neural Network, IEEE Transactions on 
% Neural Networks, 2, 1991, 568-576.
%

%
% set constants
%
[ncal,ndim] = size(cal);
[nprd,junk] = size(pred);
nhcel = ncal;
smooth_sqr = smooth * smooth;
%
% move calibration and prediction data to work arrays
%
workt = cal;
workp = pred;
%
% move calibration data to hidden units (calibration is finished)
%
hcel = workt;
%
% now perform prediction by propagating prediction patterns through network
% 
for i = 1:nprd
%
% 	distance calculation
%
	for j = 1:nhcel
		distmat(i,j) = sum(abs(hcel(j,1:ndim) - workp(i,1:ndim)));
	end
end
%
% now compute weighting functions s(x) and h(x)  	
%
weight = exp(-distmat/smooth_sqr);
%
h = weight'*cconc;
s = sum(weight');
predc = h./s';
%
% compute sep
%
sep = sqrt((sum((predc-actc).^2))/nprd);

	