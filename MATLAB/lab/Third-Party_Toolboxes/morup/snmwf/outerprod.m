function T=outerprod(FACT)
% The outer products:
%
% Written by Morten Mørup
%
% T=sum_f (U1f o U2f o U3f o ...o UNf) where Uif is a vector corresponding 
% to the f'th factor of the i'th dimension.
%
% Usage:
%   T=outerprod(FACT)
%
% Input:
%   FACT   Cell array containing the factor-vectors corresponding to 
%          the loadings of each dimensions in a PARAFAC model, i.e. Ui=FACT{i}
% Output: 
%   T      The multi-way array created from the outer product
%
% Copyright (C) Morten Mørup and Technical University of Denmark, 
% September 2006
%                                          
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

T=0;
for i=1:size(FACT{1},2)
    Y=1;
    for j=1:length(FACT)
        U=FACT{j};
        Y=tmult(Y,U(:,i),j);
    end
    T=T+Y;
end
 


