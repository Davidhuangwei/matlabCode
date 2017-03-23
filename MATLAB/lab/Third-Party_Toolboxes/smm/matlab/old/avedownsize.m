function averaged = avedownsize(powdat, whldat)
% resamples powdat by averaging to return a matrix the same size as whldat

[pdm n] = size(powdat);
[whlm n] = size(whldat);

factor = pdm/whlm;
averaged = zeros(whlm, 1);

for i = 1:(whlm)
    averaged(i) = mean(powdat((floor((i-1)*factor)+1):floor((i)*factor)));
   
    %averaged(i) = mean(powdat(max(1,floor((i-1)*factor-factor/2)):min(pdm,floor(i*factor-factor/2)-1)));
end

return
