% NN_SIM            influencde of connectivity on tuning pattern.

% 12-feb-04 ES

% we assume two tuning curves with constant variance, dc, and gain
% therefore we model them as cosine functions, varying their resposnes
% between 0 and 1.
% we further assumer that all synapses have equal strengths
% in order to simplify calculations, we bound output between 0 and 1.

function nn_sim

% plotting parameters

global NicePlot
if isempty( NicePlot )
    NicePlot = 0;
end
if NicePlot
    TFS = 12;
    XYFS = 12;
else
    TFS = 8;
    XYFS = 7;
end
PRESENT = 0;

% inlines

calc_tc = inline('0.5 + 0.5 * cos( theta - pd )', 'theta', 'pd' );
wmean = inline( '( w(1) .* x1 + w(2) .* x2  ) ./ ( w(1) + w(2) )', 'x1', 'x2', 'w' );
   
% simulation parameters

theta = [ 0 : 0.05 : 2 * pi ]';          % sampling resolution
pd1 = pi;                               % PD of TC1
pd2 = pi/3;                             % PD of TC2
ws = 0 : 0.025 : 1;                      % synaptic weights
wEX = [ 0.4 0.8 ];                      % weights for example
nbins = 20;%length( theta ) / 3;        % phase plane plots

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create 2 tuning curves with differnt means

tc1 = calc_tc( theta, pd1 );
tc2 = calc_tc( theta, pd2 );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% assume FF excitatory connections
% instead of modulating the respnses of the presynaptic neurons, i modulate
% the sypatses (conmpletely equivalent mathematically).

nw = length( ws );
for i = 1 : nw
    for j = 1 : nw
        w1 = ws( i );
        w2 = ws( j );
        w = [ w1 w2 ];
        if all( w == 0 )
            fprintf( 1, '[%d %d]: cannot evaluate for %s\n', i, j, num2str( w ) );
            vFF( i, j ) = NaN;
            phiFF( i, j ) = NaN;
            continue;
        end
        tcm = wmean( tc1, tc2, w );
        [ rm, phim ] = comp_rs( theta, tcm );
        vFF( i, j ) = 1 - rm;
        phiFF( i, j ) = phim;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now assume FF excitatory connections with simple reciprocal inhibitions
% that is, each cell modulates the input the post-synaptic cell receivec
% from the other cell

for i = 1 : nw
    for j = 1 : nw
        w1 = ws( i );
        w2 = ws( j );
        w = [ w1*(1-w2) w2*(1-w1) ];
        if all( w == 0 )
            fprintf( 1, '[%d %d]: cannot evaluate for %s\n', i, j, num2str( w ) );
            vRI( i, j ) = NaN;
            phiRI( i, j ) = NaN;
            continue;
        end
        tcm = wmean( tc1, tc2, w );
        [ rm, phim ] = comp_rs( theta, tcm );
        vRI( i, j ) = 1 - rm;
        phiRI( i, j ) = phim;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the results

% example

[ r1, phi1 ] = comp_rs( theta, tc1 );
[ r2, phi2 ] = comp_rs( theta, tc2 );
v1 = 1 - r1;
v2 = 1 - r2;

wFF = [ wEX(1) wEX(2) ];
wRI = [ wEX(1)*(1-wEX(2)) wEX(2)*(1-wEX(1)) ];
tcmFF = wmean( tc1, tc2, wFF );
[ rmFF, phimFF ] = comp_rs( theta, tcmFF );
tcmRI = wmean( tc1, tc2, wRI );
[ rmRI, phimRI ] = comp_rs( theta, tcmRI );

figure, 
subplot( 2, 4, 1 ), dir_mean( theta, tc1, 'compass' ); axe_title( sprintf( 'TC1' ), [], [], TFS, XYFS );
subplot( 2, 4, 2 ), dir_mean( theta, tc2, 'compass' ); axe_title( sprintf( 'TC2' ), [], [], TFS, XYFS );
subplot( 2, 4, 5 ), dir_mean( theta, tcmFF, 'compass' ); axe_title( sprintf( 'FF, w = [%0.3g %0.3g]', wEX(1), wEX(2) ), [], [], TFS, XYFS );
subplot( 2, 4, 6 ), dir_mean( theta, tcmRI, 'compass' ); axe_title( sprintf( 'RI, w = [%0.3g %0.3g]', wEX(1), wEX(2) ), [], [], TFS, XYFS );
subplot( 1, 2, 2 )
plot( theta, tc1, ':b', theta, tc2, ':r', theta, tcmFF , 'g', theta, tcmRI , 'k' )
separators( phi1, [], [ 0 0 1 ] );
separators( phi2, [], [ 1 0 0 ] );
separators( phimFF, [], [ 0 1 0 ] );
separators( phimRI, [], [ 0 0 0 ] );
legend( 'TC1', 'TC2', 'FF', 'RI' )
xlim( [ 0 2*pi] )

% as a function of the weights
[ x y ] = meshgrid( ws, ws );
figure
subplot( 2,2,1 ); 
contour( x, y, phiFF, [ 0 : 0.1 : 2*pi ] ), axis square, colorbar, axe_title( 'phi FF', [], [], TFS, XYFS );
subplot( 2,2,2 );
contour( x, y, vFF, [ 0 : 0.01 : 1 ] ), axis square, colorbar, axe_title( '1-R FF', [], [], TFS, XYFS );
subplot( 2,2,3 ); 
contour( x, y, phiRI, [ 0 : 0.1 : 2*pi ] ), axis square, colorbar, axe_title( 'phi RI', [], [], TFS, XYFS );
subplot( 2,2,4 );
contour( x, y, vRI, [ 0 : 0.01 : 1 ] ), axis square, colorbar, axe_title( '1-R RI', [], [], TFS, XYFS );

if PRESENT
    [ x y ] = meshgrid( ws, ws );
    figure
    subplot( 2,2,2 ); 
    contour( x, y, phiFF, [ 0 : 0.1 : 2*pi ] ), axis square, colorbar, axe_title( 'phi FF', [], [], TFS, XYFS );
    subplot( 2,2,4 ); 
    contour( x, y, phiRI, [ 0 : 0.1 : 2*pi ] ), axis square, colorbar, axe_title( 'phi RI', [], [], TFS, XYFS );
    
    figure
    subplot( 2,2,1 );
    contour( x, y, vFF, [ 0 : 0.01 : 1 ] ), axis square, colorbar, axe_title( '1-R FF', [], [], TFS, XYFS );
    subplot( 2,2,3 );
    contour( x, y, vRI, [ 0 : 0.01 : 1 ] ), axis square, colorbar, axe_title( '1-R RI', [], [], TFS, XYFS );
    colormap cool
end

% [ x y ] = meshgrid( ws, ws );
% figure
% subplot( 2,2,1 ); 
% contourf( x, y, phiFF ), axis square, colorbar, axe_title( 'phi FF' );
% subplot( 2,2,2 );
% contourf( x, y, vFF ), axis square, colorbar, axe_title( '1-R FF' );
% subplot( 2,2,3 ); 
% contourf( x, y, phiRI ), axis square, colorbar, axe_title( 'phi RI' );
% subplot( 2,2,4 );
% contourf( x, y, vRI ), axis square, colorbar, axe_title( '1-R RI' );

% phase planes
[ cmatFF xbins ybins ] = bin_2d( phiFF(:), vFF(:), nbins, nbins ); 
[ cmatRI xbins ybins ] = bin_2d( phiRI(:), vRI(:), nbins, nbins ); 
%[ xx yy ] = meshgrid( xbins, ybins );
figure, 
subplot( 2, 1, 1 );
imagesc( xbins, ybins, cmatFF / sum( sum( cmatFF ) ) )
%contourf( xx,yy, cmatFF / sum( sum( cmatFF ) ) )
axis xy, colorbar, axis square
xlabel( 'phi' ), ylabel( '1-R' )
axe_title( 'FF', [], [], TFS, XYFS );
subplot( 2, 1, 2 );
imagesc( xbins, ybins, cmatRI / sum( sum( cmatRI ) ) )
%contourf( xx,yy, cmatRI / sum( sum( cmatRI ) ) )
axis xy, colorbar, axis square
xlabel( 'phi' ), ylabel( '1-R' )
axe_title( 'RI', [], [], TFS, XYFS );
colormap( flipud( gray ) )

% figure, 
% subplot( 2, 1, 1 ), 
% plot( phi1, v1, 'ob', phi2, v2, 'or', phiFF(:), vFF(:), '.k' ), xlabel( 'phi' ), ylabel( '1-R' )
% legend( 'tc1', 'tc2', 'w mean' )
% subplot( 2, 1, 2 ), 
% plot( phi1, v1, 'ob', phi2, v2, 'or', phiRI(:), vRI(:), '.k' ), xlabel( 'phi' ), ylabel( '1-R' )
% legend( 'tc1', 'tc2', 'w mean' )

return