function [Sta, p_val] = CInd_test_new_withGPm(x, y, z, width, bss)
% [Sta, p_val] = CInd_test_new_withGPm(x, y, z, width, bss)
% To test if x and y are independent.
% INPUT:
%   The number of rows of x and y is the sample size.
%   alpha is the significance level (we suggest 1%).
%   width contains the kernel width.
% Output:
%   Cri: the critical point at the p-value equal to alpha obtained by bootstrapping.
%   Sta: the statistic Tr(K_{\ddot{X}|Z} * K_{Y|Z}).
%   p_val: the p value obtained by bootstrapping.
%   Cri_appr: the critical value obtained by Gamma approximation.
%   p_apppr: the p-value obtained by Gamma approximation.
% If Sta > Cri, the null hypothesis (x is independent from y) is rejected.
% Copyright (c) 2010-2011  ...
% All rights reserved.  See the file COPYING for license terms.
% x=pi-x;
% y=pi-y;
% z=pi-z;
% Controlling parameters
IF_unbiased = 0;
IF_GP = 1;
Approximate = 1;
Bootstrap = 1; % Note: set to 0 to save time if you do not use simulation to generate the null !!!
[nbs,ns]=size(bss);
jr=size(x,1)/nbs;
BSta=zeros(ns,1);

T = length(y); % the sample size
% Num_eig = floor(T/4); % how many eigenvalues are to be calculated?
Num_eig = T;
T_BS = 5000; % 5000
lambda = 1E-3; % the regularization paramter  %%%%Problem
Thresh = 1E-5;
% normalize the data 
% if isreal(x)
% x = x * diag(1./std(x));
% x = x - repmat(mean(x,1), T, 1);
% else 
%     x=bsxfun(@times,x,conj(fangle(mean(fangle(x),1))));
% end
% if isreal(y)
% y = y * diag(1./std(y));
% y = y - repmat(mean(y,1), T, 1);
% else 
%     y=bsxfun(@times,y,conj(fangle(mean(fangle(y),1))));
% end
% if isreal(z)
% z = z * diag(1./std(z));
% z = z - repmat(mean(z,1), T, 1);
% else 
%     z=bsxfun(@times,z,conj(fangle(mean(fangle(z),1))));
% end
x=zscore(x);
y=zscore(y);
z=zscore(z);
D = size(z, 2);
logtheta_x = []; logtheta_y = [];  df_x = []; df_y = [];
Cri = []; Sta = []; p_val = []; Cri_appr = []; p_appr = [];

if width ==0
    if T <= 200  
        width = 1.2; % 0.8
    elseif T < 1200
         width = 0.7; % 0.5
%        width = 0.8;
    else
        width = 0.4; % 0.3
    end
%      width = sqrt(2)*medbw(x, 1000); %use median heuristic for the band width.
end
theta = 1/(width^2 * D); % I use this parameter to construct kernel matices. Watch out!! width = sqrt(2) sigma  AND theta= 1/(2*sigma^2)

H =  eye(T) - ones(T,T)/T; % for centering of the data in feature space
% Kx = kernel([x z], [x z], [theta,1]); Kx = H * Kx * H;
Kx = kernel([x z/2], [x z/2], [theta,1]); Kx = H * Kx * H;
% Ky = kernel([y z], [y z], [theta,1]); %Ky = Ky * H;
% Kx = kernel([x], [x], [theta,1]); %Kx = Kx * H; %%%%Problem
Ky = kernel([y], [y], [theta,1]); Ky = H * Ky * H;  %%%%Problem
% later with optimized hyperparameters

if IF_GP
    % learning the hyperparameters
    [eig_Kx, eix] = eigdec((Kx+Kx')/2, min(400, floor(T/4))); % /2
    [eig_Ky, eiy] = eigdec((Ky+Ky')/2, min(200, floor(T/5))); % /3
    % disp('  covfunc = {''covSum'', {''covSEard'',''covNoise''}};')
    covfunc = {'covSum', {'covSEard','covNoise'}};
    logtheta0 = [log(width * sqrt(D)) * ones(D,1) ; 0; log(sqrt(0.1))];%*ones(D,1)
%     fprintf('Optimizing hyperparameters in GP regression...\n');
    %     [logtheta_x, fvals_x, iter_x] = minimize(logtheta0, 'gpr_multi', -150, covfunc, z, 1/std(eix(:,1)) * eix);
    %     [logtheta_y, fvals_y, iter_y] = minimize(logtheta0, 'gpr_multi', -150, covfunc, z, 1/std(eiy(:,1)) * eiy);
    % -200 or -350?
    
    %old gpml-toolbox
    %
    IIx = find(eig_Kx > max(eig_Kx) * Thresh); eig_Kx = eig_Kx(IIx); eix = eix(:,IIx);
    IIy = find(eig_Ky > max(eig_Ky) * Thresh); eig_Ky = eig_Ky(IIy); eiy = eiy(:,IIy);
    [logtheta_x, fvals_x, iter_x] = minimize(logtheta0, 'gpr_multi', -350, covfunc, z, 2*sqrt(T) *eix * diag(sqrt(eig_Kx))/sqrt(eig_Kx(1)));
    [logtheta_y, fvals_y, iter_y] = minimize(logtheta0, 'gpr_multi', -350, covfunc, z, 2*sqrt(T) *eiy * diag(sqrt(eig_Ky))/sqrt(eig_Ky(1)));
    
    covfunc_z = {'covSEard'};% iso
    Kz_x = feval(covfunc_z{:}, logtheta_x, z);
    Kz_y = feval(covfunc_z{:}, logtheta_y, z);
    
    % Note: in the conditional case, no need to do centering, as the regression
    % will automatically enforce that.
    
    % Kernel matrices of the errors
    P1_x = (eye(T) - Kz_x*pdinv(Kz_x + exp(2*logtheta_x(end))*eye(T)));
    Kxz = P1_x* Kx * P1_x';
    P1_y = (eye(T) - Kz_y*pdinv(Kz_y + exp(2*max(logtheta_y(end),-5))*eye(T)));
    Kyz = P1_y* Ky * P1_y';
    % calculate the statistic
    Sta = trace(Kxz * Kyz);
    
    if Bootstrap
        ox=x;
        for kk=1:ns
            rsps=bsxfun(@plus,bss(:,kk)*jr,1:jr);
            x=ox(rsps(:));
            Kx= kernel([x z/2], [x z/2], [theta,1]); Kx = H * Kx * H;
            Kxz = P1_x* Kx * P1_x';
            % calculate the statistic
            BSta(kk) = trace(Kxz * Kyz);
        end
    end
    p_val = sum(BSta>Sta)/ns;
    % degrees of freedom
%     df_x = trace(eye(T)-P1_x);
%     df_y = trace(eye(T)-P1_y);
else
    Kz = kernel(z, z, [theta,1]); Kz = H * Kz * H; %*4 % as we will calculate Kz
    % Kernel matrices of the errors
    P1 = (eye(T) - Kz*pdinv(Kz + lambda*eye(T)));
    Kxz = P1* Kx * P1';
    Kyz = P1* Ky * P1';
    % calculate the statistic
    Sta = trace(Kxz * Kyz);
    if Bootstrap
        ox=x;
        for kk=1:ns
            x=circshift(ox,bss(k));
            Kx= kernel([x z/2], [x z/2], [theta,1]); Kx = H * Kx * H;
            Kxz = P1* Kx * P1';
            % calculate the statistic
            BSta(kk) = trace(Kxz * Kyz);
        end
    end
    p_val = sum(BSta>Sta)/ns;
    % degrees of freedom
%     df = trace(eye(T)-P1);
end

