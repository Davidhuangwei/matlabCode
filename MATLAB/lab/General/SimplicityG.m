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
% Copyright (C) 2003 by J�rgen Kayser (Email: kayserj@pi.cpmc.columbia.edu)
% GNU General Public License (http://www.gnu.org/licenses/gpl.txt)
% Updated: $Date: 2003/12/16 14:59:00 $ $Author: jk $

function [G] = SimplicityG (Y);

A = Y.^2;
B = A'*A;
G1 = sum(B(:))-sum(diag(B));

C = sum(B);
G2 = 1/size(Y,1) * (sum(C * repmat(C,size(Y,2),1)) - sum(C.^2));

G = G1-G2;
