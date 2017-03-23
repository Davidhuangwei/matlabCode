function averaged = avedownsample(powdat, whlm)
% resamples powdat by averaging to return a vector of length whlm

[pdm n] = size(powdat);

if n~=1
    ERROR_n_not_1
end

factor = pdm/whlm;
averaged = zeros(whlm,n);

for i = 1:(whlm)
    averaged(i) = mean(powdat((floor((i-1)*factor)+1):floor((i)*factor)));
   
    %averaged(i) = mean(powdat(max(1,floor((i-1)*factor-factor/2)):min(pdm,floor(i*factor-factor/2)-1)));
end

return
