% abs_phase_dif compute & correct absolute phase differences 
% inputs: X,Y are equal size matrices of angles (in radians)  
% output: DXY - X-Y corrected to circularity & absolute value   
% 09nov04 IA absf
function DXY = abs_phase_dif(X,Y,absf) 
if nargin<2 error('2 inputs needed'); end
if nargin<3 | isempty(absf), absf=1; end

if ~isequal(size(X),size(Y)), error('unequal sizes'); end
difXY = X-Y; 
if absf 
difXY=mod(difXY,2*pi); % all positive but some are >pi 
DXY=min(abs(difXY),abs(2*pi-difXY));
else 
    DXY = difXY; 
end 
return 