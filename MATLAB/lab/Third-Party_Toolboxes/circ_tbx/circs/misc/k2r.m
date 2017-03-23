% K2R               ratio of 1st to 0th order modified bessel of first kind.
%
% call              A = K2R( K )
%
% calls             nothing
%
% called by         R2K
%
% algorithm         analytic.

% reference: Mardia 1972, p. 122

% 29-jul-04 ES

function a = k2r( k )

a = besseli( 1, k ) ./ besseli( 0, k );

return