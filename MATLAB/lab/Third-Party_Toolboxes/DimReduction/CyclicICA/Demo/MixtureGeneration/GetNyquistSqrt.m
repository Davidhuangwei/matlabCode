function [ y ] = GetNyquist(alpha,Periode,t)

if (t==0)
   y = 4*alpha/(pi*sqrt(Periode))*(1+(1-alpha)/(4*alpha)*pi);

elseif or(t==Periode/(4*alpha),t==-Periode/(4*alpha))
   y = alpha/sqrt(Periode) * (cos(pi/(4*alpha))+sin(pi/(4*alpha))) /sqrt(2) + ...
	  2*alpha/(pi*sqrt(Periode))*sin((1-alpha)*pi/(4*alpha)); 
else
   y = 4*alpha./(pi * sqrt(Periode) .* (1-(4*alpha.*t/Periode).^2)) .* ...
    (cos((1+alpha)*pi.*t/Periode) + sin((1-alpha)*pi.*t/Periode).* ...
     (4*alpha.*t/Periode).^(-1) );   
end

