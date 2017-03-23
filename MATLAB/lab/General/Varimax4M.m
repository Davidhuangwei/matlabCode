% Varimax4M - Varimax rotation as described by Harman (1967, pp. 304-308)
%             and implemented by BMDP-4M (Dixon, 1992, pp. 602-603),
%             using the simplicity criterion G instead of Vmax
%
% Usage: [Y, G] = Varimax4M ( X, maxit, tol, norm)
%
%    Only arguments X and Y requested.
%
% Input arguments:
%        X = variables-by-factors loadings matrix
%    maxit = maximum number of iterations
%            (default = 100)
%      tol = convergence criterion threshold for rotation
%            (default = 1e-4)
%     norm = perform Kaiser's normalization
%            (default = 1 = normalize)
%
% Output arguments:
%        Y = Varimax-rotated variables-by-factors loadings matrix
%        G = simplicity criterion for each iteration (Dixon, 1992)
%        V = Varimax criterion for each iteration (Harman, 1967)
%            (computations for V are only listed in comments)
%
% Terminology following Harman (1967), Dixon (1992), and Park (2003)
%    p = number of variables (rows)
%    m = number of factors (columns)
%    X = initial p-by-m matrix
%    Y = rotated p-by-m matrix
%    h = communalities of the variables (rows)
% 
% References
% ----------
%    Dixon WJ (Ed.) (1992). BMDP Statistical Software Manual: To 
%       Accompany the 7.0 Software Release. University of California 
%       Press, Berkeley, CA.
%    Harman HH (1967). Modern Factor Analysis (2nd ed). University of 
%       Chicago Press, Chicago.
%    Park T (March 2003). A note on terse coding of Kaiser's Varimax 
%       rotation using complex number representation. (http://www.orie.
%       cornell.edu/~trevor/Research/vnote.pdf)
%
% Copyright (C) 2003 by J�rgen Kayser (Email: kayserj@pi.cpmc.columbia.edu)
% GNU General Public License (http://www.gnu.org/licenses/gpl.txt)
% Updated: $Date: 2003/06/27 07:05:00 $ $Author: jk $
%

function [Y, G] = Varimax4M ( X, maxit, tol, norm)

disp(sprintf('-------- Varimax Rotation (4M) ------------'));

[p, m] = size(X);
disp(sprintf('Matrix rows:          %21d',[p]));
disp(sprintf('Matrix columns:       %21d',[m]));

if nargin < 2 
   maxit = 100;
end
disp(sprintf('Max. # of iterations: %21d',[maxit]));

if nargin < 3
   tol = 1e-4;
end
disp(sprintf('Convergence criterion:%21.10f',[tol]));

if nargin < 4 
   norm = 1;
end

if norm                     % Kaiser's normalization across the rows
   disp(sprintf('Kaiser''s normalization:%20s',['YES']));
   h = sqrt( sum(X.^2,2) ); % communality column vector
   H = repmat( h, [1, m] ); % communality normalization matrix
   Y = X ./ H;              % normalize X by rows
   Y(isnan(Y)) = X(isnan(Y));
else
   disp(sprintf('Kaiser''s normalization:%20s',['NO']));
   Y = X;
end

g = SimplicityG(Y);

it = 0;
G = [it g tol];
Gold = g;     % previous simplicity criterion
YY = Y;       % rotated matrix at begin of current iteration
disp(['     #         Simplicity G     Convergence']);
disp(sprintf('%6d   %18.8f  %14.8f',[it g tol]));

% V = [it (p * sum(sum(Y.^4)) - sum(sum(Y.^2).^2))];

for it = 1:maxit
    tic
  for i = 1:m-1
    for j = i+1:m

% Determine optimal angle phi to rotate columns i,j (Harman, 1967, p. 307)
%       tic;
%       x = Y(:,i);                     
%       y = Y(:,j);         
%       u = x.^2 - y.^2;
%       v = 2 * x .* y;
%       w = u.^2 - v.^2;
%       A = sum(u);
%       B = sum(v);
%       C = sum(w);
%       D = 2 * sum(u .* v);
%       fn = D - 2 * (A * B) / p;
%       fd = C - (A^2 - B^2) / p;
%       t = atan2(fn,fd)/4;
%       toc;
% The above computations result in exactly the same t value if replaced
% by the the following terse code statement, which computes the rotation
% angle phi as the angle in the complex plane (Park, 2003); bit faster
      %  tic;
        t = angle(sum(complex(Y(:,i),Y(:,j)).^4)/p ...
                   - (sum(complex(Y(:,i),Y(:,j)).^2)/p)^2) / 4;
      %  toc;   
% rotate the two vectors ...
        XY = [Y(:,i) Y(:,j)] * [cos(t) -sin(t); sin(t) cos(t)];
% ... and replace the two columns in the matrix
        Y(:,i) = XY(:,1);
        Y(:,j) = XY(:,2);
        
    end
  end
  fprintf('rotation took %f\n',toc);
  tic;
  g = SimplicityG(Y);
  fprintf('Simplicity took %f\n',toc);
  disp(sprintf('%6d   %18.8f  %14.8f',[it g (Gold - g)]));

  if (Gold - g) < tol
     if Gold < g           % if the previous solution was better
         Y = YY;           % report the previous one
     else                  
         G(end+1,:) = [it g (Gold - g)];
     end
     break
  end
  
  YY = Y;
  G(end+1,:) = [it g (Gold - g)];
  Gold = g;
  
end;

if norm
   Y = Y .* H;             % reverse Kaiser's normalization
end
disp(sprintf('-------------------------------------------'));
