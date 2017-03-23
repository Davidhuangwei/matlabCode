function srtdR = gtm_sort(R)
% Sorts the columns of argument matrix R in increasing order.
%
% Synopsis:	srtdR = gtm_sort(R)
%
% Arguments:	R -	an (unsorted)  matrix
%
% Return:	srtdR - the corresponding sorted  matrix
%
% Notes:	The m-file implementation is simply an alias
%		for MATLAB's built-in sort function. However,
%		if a corresponding mex-file exists, this will 
%		be used instead; experience has shown that a
%		C-implementation of (e.g.) quicksort works much
%		faster.
%

% Version:	The GTM Toolbox v1.0 beta
%
% Copyright:	The GTM Toolbox is distributed under the GNU General Public 
%		Licence (version 2 or later); please refer to the file 
%		licence.txt, included with the GTM Toolbox, for details.
%
%		(C) Copyright Markus Svensen, 1996

srtdR = sort(R);
