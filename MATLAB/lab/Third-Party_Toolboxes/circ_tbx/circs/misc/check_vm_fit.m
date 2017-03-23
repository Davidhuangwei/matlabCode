% CHECK_VM_FIT      for a circular sample.
%
% call              P = CALC_VM_CI( THETA, F, BINSIZE )
%
% gets              THETA, F    directions and amplitudes
%                   BINSIZE     of circular histogram (relevant for
%                                   non-histogrammed input)
%
% return            P           result of a LR test of independence

% calls             CIRC_HIST, GTEST, COMP_RS, VMF, R2K

% reference: Mardia (1972) p.124-125

% 29-jul-04 ES

% obs_h = [ 26 22 26 30 29 18 14 11 12 5 5 11 ]';
% check_vm_fit( ( 15 : 30 : 360 )' * pi / 180, obs_h )

function [ p, info ] = check_vm_fit( theta, f, binsize, graphics )

% arguments, constants

nargs = nargin;
if nargs < 2 | isempty( theta ) | isempty( f ), error( '2 arguments' ), end
theta = theta( : );
f = f( : );
n = sum( f );
if ~isequal( length( theta ), length( f ) ), error( 'input size mismatch' ), end
%if any( f ~= round( f ) ), error( 'use integer Fs' ), end
if any( ( round( f  ) - f ) .^ 2 > eps ), error( 'use integer Fs' ), end
if nargs < 3 | isempty( binsize ), binsize = 30; end            % degrees
if nargs < 4 | isempty( graphics ), graphics = 0; end

mcr = 0.001;                                                    % Monte-Carlo resolution (radians)

% parameter estimations

[ theta tidx ] = sort( theta );                                 % sort by angles
f = f( tidx );                                                  % 
[ R phi ] = comp_rs( theta, f );                                % estimate mean
k = r2k( R );                                                   % estimate concentration

% monte carlo distribution based on estimators

xcdf = ( mcr : mcr : 2 * pi )';                                 % angles
ypdf = vmf( [ 0 1 phi k ], xcdf );                              % point probabilities
ycdf = cumsum( ypdf );
ycdf = ycdf / ycdf( end );                                      % cdf

% evaluate distribution at sample's points

if all( f == 1 )
    binsize = binsize * pi / 180;                                   % bin sizes in radians
    edges = ( 0 : binsize : 2 * pi )';                              % edges of circular histogram
else
    edges = [ 0; mean( [ theta [ theta( 2 : end ); 2 *pi ] ], 2 ) ];    % half-way between samples
    edges( end ) = 2 * pi;
end
xcdf_idx = floor( edges( 2 : end ) / mcr );                     % corresponding indices of xcdf
if any( ( edges( 2 : end ) - xcdf( xcdf_idx ) ) > mcr )         % make sure no errors accumulated
    error( 'internal error' )
end
cumexp = ycdf( xcdf_idx ) * n;                                  % expected cumulative frequencies
expc_h = [ cumexp( 1 ); diff( cumexp ) ];                       % observed frequencies (binned)

% histogram of observations

if all( f == 1 )
    [ obs_h i e ] = circ_hist( theta, edges );
else
    obs_h = f;
end

% evaluate probability

[ p gstat ] = gtest( [ obs_h expc_h ] );

% graphics

if graphics
    newplot
    plot( xcdf, ycdf ), 
    separators( edges( 2 : end ), [], [], 'x' ), 
    separators( ycdf( xcdf_idx ), [], [ 0 0 0 ], 'y' )
end

if nargout > 1
    info.obs_h = obs_h;
    info.expc_h = expc_h;
    info.phi = phi;
    info.R = R;
    info.k = k;
    info.n = n;
    info.gstat = gstat;
    info.p = p;
    info.theta = theta;
end

return