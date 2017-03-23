% Est = EstPPLogL(f, t, Ranges)
%
% Estimates what the maximum information gain of a spike train would be, if
% you knew everything what the firing rate over time was.

function Est = EstPPLogL(f, t, Ranges)

% check for constant firing rate
if length(f)==1
	Est = 0;
	return;
end

% check f is positive
if any(f<0)
	error('f must be positive');
end


% initialize
nRanges = size(Ranges, 1);
fInt = 0; Est = 0;

for r=1:nRanges

	% find where t is in range
	
	tMin = Ranges(r,1); tMax = Ranges(r,2);
	InRange = find(t>=Ranges(r,1) & t<=Ranges(r,2));
	
	% extend t and f to full range if necessary
	t1 = t(InRange); f1 = f(InRange);
	if t1(1)>tMin
		t1 = [tMin; t1];
		f1 = [f1(1); f1];
	end
	if t1(end)<tMax	
		t1 = [t1; tMax];
		f1 = [f1; f1(end)];
	end
	
	Est = Est+trapz(t1,f1.*log(f1+eps));
	fInt = fInt+trapz(t1,f1);
end

% calculate expected average firing rate

TotTime = sum(diff(Ranges, [], 2));
f0 = fInt/TotTime;

% subtract term for constant firing rate
Est = Est-TotTime*f0*log(f0);

% make it in bits
Est = Est /log(2);
