function [ y ] = GetNyquist(alpha,Periode,temps)

for (it=1:length(temps))

	t = temps(it);
	
if (t==0)
   y(it) = 4*alpha/(pi*sqrt(Periode))*(1+(1-alpha)/(4*alpha)*pi);

elseif or(t==Periode/(4*alpha),t==-Periode/(4*alpha))
   y(it) = alpha/sqrt(Periode) * (cos(pi/(4*alpha))+sin(pi/(4*alpha))) /sqrt(2) + ...
	  2*alpha/(pi*sqrt(Periode))*sin((1-alpha)*pi/(4*alpha)); 
else
   y(it) = 4*alpha./(pi * sqrt(Periode) .* (1-(4*alpha.*t/Periode).^2)) .* ...
    (cos((1+alpha)*pi.*t/Periode) + sin((1-alpha)*pi.*t/Periode).* ...
     (4*alpha.*t/Periode).^(-1) );   
end
end
