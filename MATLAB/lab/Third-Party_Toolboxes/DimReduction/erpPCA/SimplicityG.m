% SimplicityG - subfunction used by Varimax4M to compute rotation criterion for input matrix
%
% Usage: [G] = SimplicityG (Y)
%
% Input argument:
%        Y = variables-by-factors loadings matrix
%
% Output argument:
%        G = simplicity criterion for input loadings matrix
%
% Copyright (C) 2003 by Jürgen Kayser (Email: kayserj@pi.cpmc.columbia.edu)
% GNU General Public License (http://www.gnu.org/licenses/gpl.txt)
% Updated: $Date: 2003/12/16 14:59:00 $ $Author: jk $

function [G] = SimplicityG (Y);

g = 0; 
for i = 1:size(Y,2); for j = 1:size(Y,2);
  if (i ~= j)  
     g = g + sum( (Y(:,i).^2).*(Y(:,j).^2)) - ...
                  ( (1/size(Y,1)) * ( sum(Y(:,i).^2) * sum(Y(:,j).^2) ) );
  end 
end; end
G = g;