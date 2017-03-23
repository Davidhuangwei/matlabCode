% CIRC_HIST2            circular 2-dimensional histogram.
%
% calls                 FIRFILT, CIRC, MYJET
%
% called by             MAKE_BSC_PLOTS

% 11-may-04 ES

% 03-jul-04 newplot and not figure
% 04-jul-04 normtype added, enforcef deleted; generic function now

function [ dhist, bins ] = circ_hist2( v, dir, binsize, theta, map, smoothf, normtype, bins );

% arguments

nargs = nargin;
if nargs < 2, error( '2 arguments' ), end
if nargs < 3 | isempty( binsize ), binsize = 2; end
if nargs < 4 | isempty( theta ), theta = [1/6 0 5/6:-1/6:1/3]'*2*pi; end
if nargs < 5 | isempty( map ), map = @myjet; end            % either f.handle or matrix
if nargs < 6 | isempty( smoothf ), smoothf = 0; end         % smooth using a smoothf-points gaussian
if nargs < 7 | isempty( normtype ), normtype = 2; end       % normalization to probabilities
if nargs < 8, bins = []; end                                % bin edges for estimation of distribution

v = v( : ).';
dir = dir( : ).';

% compute histogram
if isempty( bins )
    bins = min( v ) : binsize : max( v ) + binsize;     % bin edges; assume discrete sampling for now (spike counts)
end
nbins = length( bins ) - 1;                                 % count number of bins, rather than bin edges
dirs = unique( dir );
for d = dirs( : ).'
    counts( :, d ) = histc( v( dir == d ), bins )';
end
counts( end, : ) = [];                                      % clear last bin (always empty)
if smoothf, 
    counts = firfilt( counts, calc_win( round( smoothf ) ) );
end
switch normtype
    case 0
        dhist = counts;
    case 1
        dhist = counts ./ ( ones( nbins, 1 ) * sum( counts, 1 ) );
    case 2
        dhist = counts ./ sum( sum( counts ) );
    otherwise
        error( 'bad normtype' );
end

% plot it

[ nbins ndirs ] = size( dhist );            % 
if ndirs ~= length( theta ), error( 'input size mismatch' ), end

% get discretized colors for frequencies
if isa( map, 'function_handle' )
    C = feval( map );
elseif isa( map, 'double' )
    C = map;
else
    error( 'input type mismatch' )
end
ncolors = size( C, 1 );
uvals = unique( dhist( : ) );
% use part of the color spectrum:
% cidx = round( dhist( : ) * ncolors ) + 1;
% use the entire spectrum:
cidx = round( uvals / uvals( end ) * ( ncolors - 1 ) + 1 );

% get radii of frequencies
rranges = [ 0 : 1 : nbins - 1; 1 : 1 : nbins ];     % columns are radial bounds for each band

% get angular sectors
[ theta si ] = sort( theta );
theta = mod( theta(:).', 2 * pi );
thetas = [ theta( end ) - 2 * pi theta theta( 1 ) + 2 * pi ];
dt = diff( thetas ) / 2;
tranges = [ theta - dt( 1 : ndirs ); theta + dt( 2 : ndirs + 1 ) ];
tranges = round( mod( tranges, 2 * pi ) * 180 / pi ); % convert to degrees; columns are angular bounds for each sector
tranges = tranges( :, si );

% now plot the sectors by radii
newplot
for d = 1 : ndirs
    for b = nbins : -1 : 1%1 : nbins
        % get the angles in radians in one degree resolution
        angs = tranges( :, d );
        if angs( 1 ) > angs( 2 )
            angs = angs( 1 ) : angs( 2 ) + 360;
        else
            angs = angs( 1 ) : angs( 2 );
        end
        angs = angs * pi / 180;
        % get the values
        r = rranges( 2, b );
        x = [ 0 r * cos( angs ) 0 ];
        y = [ 0 r * sin( angs ) 0 ];
        c = C( cidx( uvals == dhist( b, d ) ), : );
        % plot
        h( b, d ) = patch( x, y, c );
        set( h( b, d ), 'EdgeColor', c );
    end
end
hc = circ( 0, 0, rranges( 2, nbins ), [ 0 0 0 ] );
set( hc, 'LineWidth', 1.5 );

axis equal, axis off, colormap( C )
caxis( uvals( [ 1 end ] ) )

return