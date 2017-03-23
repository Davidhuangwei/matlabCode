% CIRC_HIST         histogram mod 2pi.
%
% call              [ H, IDX, EDGES ] = CIRC_HIST( THETA, BINS )
%
% gets              THETA       angles
%                   BINS        either number of bins {6} (then, bin
%                                   centers are at equally spaced points)
%                               or the bin edges themselves
%
% returns           H           histogram
%                   IDX         indices of THETA, s.t. H( j ) = length( THETA( idx == j ) )
%                   EDGES       bin edges
%
% calls             nothing

% 21-mar-04 ES

% revisions
% 29-jul-04 external bins (edges) supported

function [ h, idx, edges ] = circ_hist( theta, bins )

nargs = nargin;
if nargs < 2 | isempty( bins ), bins = 6; end

if prod( size( bins ) ) > 1
    bins = sort( mod( bins(:), 2 * pi ) );  % make sure legal
    edges = unique( [ bins; 2 * pi ] );     % add end
    e = 0;
else
    edges = 0 : 2 * pi / bins : 2 * pi;     % create bin edges
    e = pi / bins;                          % half bin
end

theta = theta( : );
theta = mod( theta, 2 * pi );               % unit circle
x = mod( theta + e, 2 * pi );               % shift by half bin size
[ h idx ] = histc( x, edges );                % use histc

switch ndims( x )                           % end is always empty
    case 1
        h( end ) = [];                      
    case 2
        h( end, : ) = [];
end

return