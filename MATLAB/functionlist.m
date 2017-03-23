function functionlist
% to record functions I write
% 
% <----:: Independence tests and Kernel related functions by YY ::-------->
% 
% ******* Independence test: 
% 
% kCI: [Sta, p_val] = CInd_test_new_withGP(x, y, z, alpha, width)
% KCIcausal_new: function used to calculate kernal based conditional
%                   independcy. Now can be used in complex numbers. 
% nTE: [nte, me, ste, h, XBins, YBins, ZBins, Pos]=nTE(X,Y,Z,npmt)
%       normalized transform entropy. base on histc3 
% 
% ******* Kernel related: 
% 
% nkernel: Kx=nkernel(x,y,par)to define my kernels.
% some useful function: 
% A = accumarray(subs,val) --> A(subs)=val; NB: vectors
% 
% ******* Regression: 
% linear regression: [Ress, A]=BasicRegression(x,y) linear vector regression.
% GP regression: ny=GaussionProcessRegression(x,y,width,lambda, nx)
%
% see also: ICArelated, TimeSequencyProcessing(basic & CSD related),
% Independence test: CInd_test_new_withGP.m, KCIcausal_new, nTE
% Kernel related: nkernel.m
% Regression: BasicRegression, GaussionProcessRegression
% relatedspcripts: caunetG.m, ec2cas_theta1.m, ecs2ca_tz.m, ec2cas_theta2.m,
