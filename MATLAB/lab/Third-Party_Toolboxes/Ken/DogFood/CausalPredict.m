% CausalPredict(x,y,lag)
%
% constructs a causal filter to predict y from x.
% everything is done quick and nasty in the time domain.

function [R, Filter, Prediction] = CausalPredict(x,y,lag);

xc = xcov([x(:), y(:)], lag, 'unbiased');

C = xc(lag+2:end,2);

D = toeplitz(xc(lag+1:lag*2,1));

Filter = [0; D\C];

%if (nargout>=2)
	Prediction = filter(Filter, 1, x);
%end;

RM = corrcoef(y(lag+1:end), Prediction(lag+1:end));
R = RM(1,2);
%disp(R);
plot(Filter);
drawnow