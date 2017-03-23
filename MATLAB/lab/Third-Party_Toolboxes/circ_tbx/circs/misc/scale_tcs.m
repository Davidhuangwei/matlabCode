% SCALE_TCS     scale TC to get rid of linear effects.
%
% call          X1S = SCALE_TCS( X1, X2 )
%               [ ..., GAIN, OFFSET, STATS, CINT, C, P, MSG ] = SCALE_TCS( ..., TH, GRAPHICS )
%
% gets          X1, X2          matrices of trials; directions in columns,
%                               trials in rows
%               TH              threshold regression p-value to determine
%                               fit {0.05}
%               GRAPHICS        flag {0}
%
% returns       X1S             first matrix scaled (X1S = GAIN * X1 + OFFSET)
%               GAIN, OFFSET    scaling parameters
%               STATS           of REGRESS: [R2 F p]
%               CINT            CI of GAIN, OFFSET
%               C               4 cc between TCs: before (Pearson's,
%                               Spearman's) and after
%               P               of H0: C==0
%               MSG             text border situations
%
% calls         MY_MEAN
%
% does          1. rotate TCs s.t. peaks are aligned
%               2. linear regression between the 2 (non-negative correlation coefficient)
%               3. shift back and scale
%
% note          that if the 2 TCs are % identical but scaled, then
%                   X2 = GAIN * X1 + OFFSET, or
%                   X2 == X1S

% 16-feb-04 ES

% revisions
% 08-mar-04 i/o
% 02-may-04 output BINT, MSG

%function [ x1s, gain, offset, stats, c, p ] = scale_tcs( x1, x2, TH, graphics )
function [ x1s, gain, offset, stats, bint, c, p, msg ] = scale_tcs( x1, x2, TH, graphics )

nargs = nargin;
if nargs < 2, error( '2 arguments' ); end
if nargs < 3 | isempty( TH ), TH = 0.05; end
if nargs < 4 | isempty( graphics ), graphics = 0; end

[ r cols ] = size( x1 );
if cols == 1
    x1 = x1';
    x2 = x2';
    [ r cols ] = size( x1 );
end
if cols ~= size( x2, 2 )
    error( 'cannot scale' )
end

msg = '';
gain = 1;
offset = 0;

% calculate means
% m1 = mean( x1, 1 )';
% m2 = mean( x2, 1 )';
m1 = my_mean( x1, 1 )';
m2 = my_mean( x2, 1 )';

% find maximum of each
i1 = find( m1 == max( m1 ) );
i2 = find( m2 == max( m2 ) );
i1 = i1( 1 );
i2 = i2( 1 );

% rotate s.t. peak of each is first
idx1 = [ i1 : cols 1 : i1 - 1 ]';
idx2 = [ i2 : cols 1 : i2 - 1 ]';
if isequal( idx1, idx2 ), msg = sprintf( '%ssame peak\n', msg ); end

% find regression slope
[ b bint rs rint stats ] = regress( m2(idx2), [ m1(idx1) ones( cols, 1 ) ] );

% determine significance (clip negative slope)
if stats(3) < TH
    if b( 1 ) < 0
        msg = sprintf( '%snegative slope (gain=%0.3g)\n', msg, b( 1 ) );
        gain = 1;
    else
        gain = b( 1 );
    end
    offset = b( 2 );
else
    msg = sprintf( '%snon-significant fit (p=%0.3g)\n', msg, stats(3) );
end

% round numerical errors
if gain ~= 1 & abs( 1 - gain ) < eps
    msg = sprintf( '%sgain within numerical error (%0.3g)\n', msg, gain );
    gain = 1;
end
if offset & abs( offset ) < eps
    msg = sprintf( '%soffset within numerical error (%0.3g)\n', msg, offset );
    offset = 0;
end

% check confidence limits
if bint( 1, 1 ) < 1 & bint( 1, 2 ) > 1
    msg = sprintf( '%snote: unit slope within ci (gain=%0.3g, [%0.3g %0.3g])\n'...
        , msg, b( 1 ), bint( 1, 1 ), bint( 1, 2 ) );
%    gain = 1;
end
if bint( 2, 1 ) < 0 & bint( 2, 2 ) > 0
    msg = sprintf( '%snote: zero offset within ci (offset=%0.3g, [%0.3g %0.3g])\n'...
        , msg, b( 2 ), bint( 2, 1 ), bint( 2, 2 ) );
%    offset = 0;
end        

% scale
x1s = x1 * gain + offset;

% make sure we didn't get negative values
if any( any( x1s < 0 ) )
    x1s = x1;
    msg = sprintf( '%scannot scale (offset = %0.3g)\n', b( 2 ), msg );
    gain = 1;
    offset = 0;
end

if nargout >= 6 | graphics
    c = NaN * ones( 1, 4 );
    p = c;
    % calculate cc before and after the scaling
    [ c(1) p(1) ] = call_corrcoef( m1, m2, 'pearson' );
    [ c(2) p(2) ] = call_corrcoef( m1, m2, 'spearman' );
    if ~isequal( [ gain offset ], [ 1 0 ] )
        [ c(3) p(3) ] = call_corrcoef( gain*m1+offset, m2, 'pearson' );
        [ c(4) p(4) ] = call_corrcoef( gain*m1+offset, m2, 'spearman' );
    end
end

if graphics > 0
    newplot
    plot( m1, m2, '.' )
    hold on, plot( gain*m1+offset, m2, '.r' )
    legend( 'original', 'scaled' )
    LIM = [ 0 dmax( dmax( gain*m1+offset, m2, 1 ), m1, 1 ) ];
    xlim( LIM ), ylim( LIM )
    lsline
    axe_title( sprintf( 'x1hat = %0.3g * x1 + %0.3g (r2=%0.3g, p=%0.3g)\nPearson=%0.3g (%0.3g); Spearman=%0.3g (%0.3g)'...
        , gain, offset, stats(1), stats(3), c(3), p(3), c(4), p(4) ) );
end

if ~isempty( msg ) & graphics >= 0
    disp( msg )
end

return

function [ c, p ] = call_corrcoef( x1, x2, mode )
if nargin < 3 | isempty( mode )
    mode = 'pearson';
end
mode = lower( mode );
if strcmp( mode, 'spearman' )
    x1 = tiedrank( x1(:) );
    x2 = tiedrank( x2(:) );
end
[ ctmp ptmp ] = corrcoef( [ x1(:) x2(:) ] );
c = ctmp( 1, 2 );
p = ptmp( 1, 2 );
return

% example
L = load( 'r:\results\emg\sca\emg_sca1_04dec02.mat' );
[ C, c2d, c2o, c2i ] = get_cils( 'diana' );
idx1 = c2o( L.tvec ) == 1;
idx2 = c2o( L.tvec ) == 2;
for m = 1 : 8
    x = L.M{m}; 
    disp('****************************')
    for e = 1 : 7
        fprintf( 1, '%s: %d\n', L.muscles{m}, e )
        [ x1s gain( m, e ) offset( m, e ) stats ] = scale_tcs(...
            v2n( x( e, idx1 ), c2d( L.tvec( idx1 ) ) )...
            , v2n( x( e, idx2 ), c2d( L.tvec( idx2 ) ) )...
            , 0.05...
            , 0 );
        r2( m, e ) = stats( 1 );
        p( m, e ) = stats( 3 );
    end
end