function [daughter,fourier_factor,coi,dofmin] = ...
	wave_bases(mother,k,scale,param);

mother = upper(mother);
n = length(k);ns= length(scale);
scale =scale(:); k =k(:)';
if (strcmp(mother,'MORLET'))  %-----------------------------------  Morlet
	if (param == -1), param = 6.;, end
	k0 = param;
    hside = (k > 0.); % Heaviside step function
    hside = repmat(hside(:)',ns,1);
    expnt = -(DirectProd(scale,k) - k0).^2/2.*hside;
    %expnt = -(scale.*k - k0).^2/2.*(k > 0.); was 
	norm = sqrt(repmat(scale,1,n)*k(2))*(pi^(-0.25))*sqrt(n);    % total energy=N   [Eqn(7)]
	daughter = norm.*exp(expnt);
	daughter = daughter.*hside;     
	fourier_factor = (4*pi)/(k0 + sqrt(2 + k0^2)); % Scale-->Fourier [Sec.3h]
	coi = fourier_factor/sqrt(2);                  % Cone-of-influence [Sec.3g]
	dofmin = 2;                                    % Degrees of freedom
end
return