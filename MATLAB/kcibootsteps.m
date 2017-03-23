
% calculate the eigenvalues
% Due to numerical issues, Kxz and Kyz may not be symmetric:
[eig_Kxz, eivx] = eigdec((Kxz+Kxz')/2,Num_eig);
[eig_Kyz, eivy] = eigdec((Kyz+Kyz')/2,Num_eig);
% prod_F = (eivx.^2)' * (eivy.^2); %%% new method
% % calculate Cri...
% % first calculate the product of the eigenvalues
% eig_prod = stack( (eig_Kxz * ones(1,Num_eig)) .* (ones(Num_eig,1) * eig_Kyz'));
% II = find(eig_prod > max(eig_prod) * Thresh);
% eig_prod = eig_prod(II); %%% new method
% eiv_prod = stack( prod_F ); %%% new method
% eiv_prod = eiv_prod(II);

% calculate the product of the square root of the eigvector and the eigen
% vector
IIx = find(eig_Kxz > max(eig_Kxz) * Thresh);
IIy = find(eig_Kyz > max(eig_Kyz) * Thresh);
eig_Kxz = eig_Kxz(IIx);
eivx = eivx(:,IIx);
eig_Kyz = eig_Kyz(IIy);
eivy = eivy(:,IIy);

eiv_prodx = eivx * diag(sqrt(eig_Kxz));
eiv_prody = eivy * diag(sqrt(eig_Kyz));
clear eivx eig_Kxz eivy eig_Kyz
% calculate their product
Num_eigx = size(eiv_prodx, 2);
Num_eigy = size(eiv_prody, 2);
Size_u = Num_eigx * Num_eigy;
uu = zeros(T, Size_u);
for i=1:Num_eigx
    for j=1:Num_eigy
        uu(:,(i-1)*Num_eigy + j) = eiv_prodx(:,i) .* eiv_prody(:,j);
    end
end
if Size_u > T
    uu_prod = uu * uu';
else
    uu_prod = uu' * uu;
end

if Bootstrap
    eig_uu = eigdec(uu_prod,min(T,Size_u));
    II_f = find(eig_uu > max(eig_uu) * Thresh);
    eig_uu = eig_uu(II_f);
end
Cri=-1;
p_val=-1;
if Bootstrap
    % use mixture of F distributions to generate the Null dstr
    if length(eig_uu) * T < 1E6
        %     f_rand1 = frnd(1,T-2-df, length(eig_prod),T_BS);
        %     Null_dstr = eig_prod'/(T-1) * f_rand1;
        f_rand1 = chi2rnd(1,length(eig_uu),T_BS);
        if IF_unbiased
            Null_dstr = T^2/(T-1-df_x)/(T-1-df_y) * eig_uu' * f_rand1; %%%%Problem
        else
            Null_dstr = eig_uu' * f_rand1;
        end
    else
        % iteratively calcuate the null dstr to save memory
        Null_dstr = zeros(1,T_BS);
        Length = max(floor(1E6/T),100);
        Itmax = floor(length(eig_uu)/Length);
        for iter = 1:Itmax
            %         f_rand1 = frnd(1,T-2-df, Length,T_BS);
            %         Null_dstr = Null_dstr + eig_prod((iter-1)*Length+1:iter*Length)'/(T-1) * f_rand1;
            f_rand1 = chi2rnd(1,Length,T_BS);
            if IF_unbiased
                Null_dstr = Null_dstr + T^2/(T-1-df_x)/(T-1-df_y) *... %%%%Problem
                    eig_uu((iter-1)*Length+1:iter*Length)' * f_rand1;
            else
                Null_dstr = Null_dstr + ... %%%%Problem
                    eig_uu((iter-1)*Length+1:iter*Length)' * f_rand1;
            end
            
        end
        %         frnd(1,T-2-df, length(eig_prod) - Itmax*Length,T_BS);
    end
    %         % use chi2 to generate the Null dstr:
    %         f_rand2 = chi2rnd(1, length(eig_prod),T_BS);
    %         Null_dstr = eig_prod'/(TT(epoch)-1) * f_rand2;
    sort_Null_dstr = sort(Null_dstr);
    Cri = sort_Null_dstr(ceil((1-alpha)*T_BS));
    p_val = sum(Null_dstr>Sta)/T_BS;
end





Cri_appr=-1;
p_appr=-1;
if Approximate
%     %     mean_appr = sum(eig_prod.* eiv_prod);
%     %     mean_appr = sum(eig_uu);
%     mean_appr = trace(uu_prod);
%     %     var_appr = 2*sum( (eig_uu).^2 );
%     var_appr = 2*trace(uu_prod^2);
%     k_appr = mean_appr^2/var_appr;
%     theta_appr = var_appr/mean_appr;
    Cri_appr = Cri;%gaminv(1-alpha, k_appr, theta_appr);
    p_appr = p_val;%1-gamcdf(Sta, k_appr, theta_appr);
end
