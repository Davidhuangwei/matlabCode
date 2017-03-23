function gtm_dstg(T, Y, m)
% Calculate the squared distances between two sets of data points. 
%
%		This function calculates distances between all data 
%		points in the two data sets T and Y and returns
%		them via the global variable matrix gtmGlobalDIST.
%
%		In addition, the minimum and maximum value of each 
%		column in gtmGlobalDIST may be calculated and 
%		returned via the global variables gtmGlobalMinDist
%		and gtmGlobalMaxDist.
%
% Synopsis:	gtm_dstg(T, Y, m)
% 		gtm_dstg(T, Y)
%
% Arguments:	T, Y -	data set matrices in which each row is a
%			data point; dimensions N-by-D and K-by-D
%			respectively
%
%		m - 	mode of calculation; the default mode is m = 0
%			(see gtmGlobalMinDist/MaxDist below)
%
% Global variables:	gtmGlobalDIST -	Matrix containing the calculated 
%			distances; dimension K-by-N; DIST(k,n) contains the
%			squared distance between T(n,:) and Y(k,:).
%			This matrix is assumed to be pre-allocated; if this
%			is not the case, performance deteriorates
%			dramatically
%			
%			gtmGlobalMinDist, gtmGlobalMaxDist - vectors 
%			containing the minimum and maximum of each 
%			column in DIST, respectively; 1-by-N; 
%			calculated iff m > 0.
%			
% Notes:	This m-file provides this help comment and a MATLAB
%		implementation of the distance calculation. If, 
%		however, a mex-file with the same name is present
%		in the MATLABPATH, this will be called for doing
%		the calculation. As this is a computationally 
%		demanding step of the algorithm, an efficient
%		mex-file implementation will improve the 
%		performance of the GTM training algorithm.
%		A mex-file implementation will have pre-allocated
%		global matrices as an absolute requirement. 
%
% See also:	gtm_dist
%

% Version:	The GTM Toolbox v1.0 beta
%
% Copyright:	The GTM Toolbox is distributed under the GNU General Public 
%		Licence (version 2 or later); please refer to the file 
%		licence.txt, included with the GTM Toolbox, for details.
%
%		(C) Copyright Markus Svensen, 1996

if (nargin == 3)
  if (m < 0)
    error(['Invalid value for mode: ', num2str(m)]);
  else
    mode = m;
  end
elseif (nargin == 2)
  mode = 0;
else
  error('Wrong number of input arguments');
end

[N, tD] = size(T);
[K, yD] = size(Y);

if (yD ~= tD)
  error('Mismatch in number of columns between T and Y.');
end

global gtmGlobalDIST;
if (isempty(gtmGlobalDIST))
  fprintf('gtm_dstg -- Warning: gtmGlobalDIST empty.\n');
end

% Summing over components of matrices, we can make use of a 'matrix 
% version' of the identity: (a - b)^2 == a^2 + b^2 - 2*a*b, 
% which yields faster execution. When T and Y consist of single columns 
% (which may be the case with calls from gtm_gbf), this has to be handled 
% as a special case. 
if yD > 1
  gtmGlobalDIST = Y*T';
  tt = sum(T'.^2);
  yy = sum(Y'.^2);
  gtmGlobalDIST = yy'*ones(1,N) + ones(K,1)*tt - 2*gtmGlobalDIST;
else
  for n=1:N
    for k=1:K
      gtmGlobalDIST(k,n) = sum((T(n,:) - Y(k,:)).^2);
    end
  end
end


if (mode > 0)
  global gtmGlobalMinDist;
  global gtmGlobalMaxDist;
  gtmGlobalMinDist = min(gtmGlobalDIST);
  gtmGlobalMaxDist = max(gtmGlobalDIST);
end
