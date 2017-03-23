% VM_EST_SIM

function res = vm_est_sim

theta = [1/6 0 5/6:-1/6:1/3]'*2*pi;
tc1 = vmf( [ 0 1 pi 1 ], theta );
mode = 'constrained';

% change offsets
fprintf( 1, '\noffsets' )
d = 0 : 0.01 : 5;
for i = 1 : length( d )
    if ~mod( i, 20 ), fprintf( 1, '.' ), end
    tc2 = vmf( [ d( i ) 1 pi 1 ], theta ); 
    [ m( i ) s( i ) r( i ) p( i ) ] = vm_est( tc1, tc2, mode, -1 );
    R( i ) = comp_rs( theta, tc2 );
end
res( 1 ) = struct( 'mode', 'offset', 'vals', d, 'R', R, 'myu', m, 'sigma', s, 'R2', r, 'p', p );
clear m s r p R

% change gains
fprintf( 1, '\ngains' )
g = 0.01 : 0.01 : 5;
for i = 1 : length( g )
    if ~mod( i, 20 ), fprintf( 1, '.' ), end
    tc2 = vmf( [ 0 g( i ) pi 1 ], theta ); 
    [ m( i ) s( i ) r( i ) p( i ) ] = vm_est( tc1, tc2, mode, -1 );
    R( i ) = comp_rs( theta, tc2 );
end
res( 2 ) = struct( 'mode', 'gain', 'vals', g, 'R', R, 'myu', m, 'sigma', s, 'R2', r, 'p', p );
clear m s r p R

% change pds
fprintf( 1, '\npds' )
pd = 0 : 0.01 : 2 * pi;
for i = 1 : length( pd )
    if ~mod( i, 20 ), fprintf( 1, '.' ), end
    tc2 = vmf( [ 0 1 pd( i ) 1 ], theta ); 
    [ m( i ) s( i ) r( i ) p( i ) ] = vm_est( tc1, tc2, mode, -1 );
    R( i ) = comp_rs( theta, tc2 );
end
res( 3 ) = struct( 'mode', 'pd', 'vals', pd, 'R', R, 'myu', m, 'sigma', s, 'R2', r, 'p', p );
clear m s r p R

% change kappas
fprintf( 1, '\nkappas' )
k = 0.01 : 0.01 : 10;
for i = 1 : length( k )
    if ~mod( i, 20 ), fprintf( 1, '.' ), end
    tc2 = vmf( [ 0 1 pi k( i ) ], theta ); 
    [ m( i ) s( i ) r( i ) p( i ) ] = vm_est( tc1, tc2, mode, -1 );
    R( i ) = comp_rs( theta, tc2 );
end
res( 4 ) = struct( 'mode', 'k', 'vals', k, 'R', R, 'myu', m, 'sigma', s, 'R2', r, 'p', p );
clear m s r p R

params = [ 0 1 pi 1 ];

figure, 
subplot( 4, 3, 1 ), plot( res( 1 ).vals, res( 1 ).myu, '.-' ), xlabel( res( 1 ).mode ), ylabel( 'myu' ); separators( params( 1 ) );
subplot( 4, 3, 2 ), plot( res( 1 ).vals, res( 1 ).sigma, '.-' ), xlabel( res( 1 ).mode ), ylabel( 'sigma' ); separators( params( 1 ) );
subplot( 4, 3, 3 ), plot( res( 1 ).myu, res( 1 ).sigma, '.' ), xlabel( 'myu' ), ylabel( 'sigma' ); circ( 0, 1, range( xlim ) / 20, [ 1 0 0 ] ); axis equal

subplot( 4, 3, 4 ), plot( res( 2 ).vals, res( 2 ).myu, '.-' ), xlabel( res( 2 ).mode ), ylabel( 'myu' ); separators( params( 2 ) );
subplot( 4, 3, 5 ), plot( res( 2 ).vals, res( 2 ).sigma, '.-' ), xlabel( res( 2 ).mode ), ylabel( 'sigma' ); separators( params( 2 ) );
subplot( 4, 3, 6 ), plot( res( 2 ).myu, res( 2 ).sigma, '.' ), xlabel( 'myu' ), ylabel( 'sigma' ); circ( 0, 1, range( xlim ) / 20, [ 1 0 0 ] ); axis equal

subplot( 4, 3, 7 ), plot( res( 3 ).vals, res( 3 ).myu, '.-' ), xlabel( res( 3 ).mode ), ylabel( 'myu' ); separators( params( 3 ) );
subplot( 4, 3, 8 ), plot( res( 3 ).vals, res( 3 ).sigma, '.-' ), xlabel( res( 3 ).mode ), ylabel( 'sigma' ); separators( params( 3 ) );
subplot( 4, 3, 9 ), plot( res( 3 ).myu, res( 3 ).sigma, '.' ), xlabel( 'myu' ), ylabel( 'sigma' ); circ( 0, 1, range( xlim ) / 20, [ 1 0 0 ] ); axis equal

subplot( 4, 3, 10 ), plot( res( 4 ).vals, res( 4 ).myu, '.-' ), xlabel( res( 4 ).mode ), ylabel( 'myu' ); separators( params( 4 ) );
subplot( 4, 3, 11 ), plot( res( 4 ).vals, res( 4 ).sigma, '.-' ), xlabel( res( 4 ).mode ), ylabel( 'sigma' ); separators( params( 4 ) );
subplot( 4, 3, 12 ), plot( res( 4 ).myu, res( 4 ).sigma, '.' ), xlabel( 'myu' ), ylabel( 'sigma' ); circ( 0, 1, range( xlim ) / 20, [ 1 0 0 ] ); axis equal

return