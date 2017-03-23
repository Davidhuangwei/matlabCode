%   CHECK_MRAO      Check modified Rao's test.
%
%       call:   CHECK_MRAO(N,REPS)
%
%       See also RAO_TEST, MRAO_TEST.

% directional statistics package
% Dec-2001 ES

function check_mrao(n,rep);

theta = rand(n,1)*2*pi;
f = rand(n,1);

[h0,p] = mrao_test(theta,f,0.05);
dir_mean(theta,f,'compass');
xlabel(num2str(p));

[h0,pr] = rao_test(theta,0.05); 
dir_mean(theta,ones(n,1),'compass');
xlabel(num2str(pr));