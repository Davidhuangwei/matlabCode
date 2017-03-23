% R2K               estimate K of Von-Mises given R.
%
% call              [ K, INFO ] = R2K( R, EXACT )
%
% gets              R       resultant of circular distribution
%                   EXACT   chooses method:
%                               -1      approximation
%                               {0}     simplex
%                                1      simplex, minimizes square error to <eps
%
% returns           K       concentration parameter
%                   INFO    numerical details
%
% calls             K2R
%
% algorithm         minimize square error by simplex.

% reference: Mardia (1972) p.122-123

% 29-jul-04 ES


function [ k, info ] = r2k( R, exact )

nargs = nargin;
if nargs < 1, error( '1 argument' ); end
if any( R < 0 ) | any( R > 1 ), k = NaN * ones( size( R ) ); return, end
if nargs < 2 | isempty( exact ), exact = 0; end

if exact == 1
    opts = optimset( 'TolX', eps, 'MaxFunEvals', 1e9, 'MaxIter', 500, 'Display', 'off' ); 
else
    opts = [];
end

R = R( : );

switch exact
    case { 0, 1 }
        sqerr = inline( '( R - k2r( k ) ) .^ 2' , 'k', 'R' );
        for i = 1 : length( R )    
            [ k( i ), FVAL, EXITFLAG, OUTPUT ] = fminsearch( sqerr, 1, opts, R( i ) );
            if nargout > 1
                info( i ).k = k( i );
                info( i ).error = FVAL;
                info( i ).converged = EXITFLAG;
                info( i ).details = OUTPUT;
            end
        end
    case { -1 }
        verysmall_r = inline( '2 * R', 'R' );        % 0.2
        small_r = inline( '1/6 * R .* ( 12 + 6 * R .^ 2 + 5 * R .^ 4 )', 'R' ); % 0.45
        large_r = inline( '1 / ( 2 * ( 1 -  R) - ( 1 - R ) .^ 2 - ( 1 - R ) .^ 3 )', 'R' );  % 0.99
        verylarge_r = inline( '1 / 2 ./ ( 1 -  R )', 'R' );
        for i = 1 : length( R )
            if R( i ) < 0.2
                k( i ) = verysmall_r( R );
            elseif R( i ) < 0.45
                k( i ) = small_r( R );
            elseif R( i ) < 0.99
                k( i ) = large_r( R );
            else
                k( i ) = verylarge_r( R );
            end
        end
    otherwise
        error( 'bad method' )
end

return