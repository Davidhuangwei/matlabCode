function h = entropy1(W, x, S, a, b, pltfun)

% Copied from heval.m.
% w = un-mixing matrix in M*K-vector
% x = mixed signal data (size K x ndata)
% h = estimated output entropy

% fprintf('entropy1 ...\n');

[M, n] = size(x);
nic = length(W(:)) / M; % nic=num rows in w = num ICs extracted
a = a(:, ones(1, n));
b = b(:, ones(1, n));

% form output data set
y = W*x;
t = tanh(y);

debug=0;
if debug==1
jsize(W,'W');
jsize(x,'x');
fprintf('nic=%d\n',nic);
end;

%Y = a.*erf(y) + b.*t; % NB: CPU and memory

% jsize(a,'a'); jsize(b,'b');

% For low kurtosis.
%a = ones(1,nic)'*1.5; b = ones(1,nic)'*(-0.5);

% For high kurtosis. should be zeros and ones!
% a = ones(1,nic)'; b = zeros(1,nic)';

dY = a/sqrt(pi) .* exp(-0.5*y.^2) + b.*(1 - t.^2); % NB: CPU and memory

clear a b t;

% get non-linear contribution to entropy
s = abs(dY) + 1e-20;

% get approximate linear contribution to entropy
C = det(W*S*W');

h = -( (1/n)*sum(sum(log(s))) + 0.5*log(C) );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
return;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
