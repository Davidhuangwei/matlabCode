% [LikRat, Params] = PPCrossVal(Res, IndVars, TrainFn, TestFn, nCrossVal, GoodRanges)
%
% Does a cross-validation test on spike train prediction.  The time available
% is divided into nCrossVal equal chunks.  For each chunk, a set of parameters
% (eg place fields) are created from the rest of the data, and used to compute
% a log likelihood on the chunk.  For each chunk, the log likelihood is also
% computed by assuming a constant firing rate.  The difference for all chunks
% are added and returned as LikRat.  Logs are to base 2.  LikRat will have units
% bits/ResUnit.
%
% Input variables:
%
% Res is the spike train of a single cell, to be predicted and tested.
%
% IndVars is a structure containing the independent variables that are used to
% make the prediction.  It is passed to user supplied functions only, so its
% format is up to you
%
% TrainFn is a string containing the name of the user-supplied function used for
% training.  It is called as Params=TrainFn(Res, IndVars, TrainRange).  Res and
% IndVars passed on exactly as they were input.  TrainRange the time range from
% which the parameters should be derived.  PPCrossVal returns optional second argument
% giving Params computed for each chunk.
%
% TestFn is a string containing the name of the user-supplied function used for
% testing.  It is called as [f t]=TestFn(Param, IndVars, TestRange).  Param is
% the output of TrainFn.  IndVars are passed as input.  TestRange is the time
% range on which the the predictions should be made.  The output, f should should
% be a predicted firing rate at a set of points t.  The points of t are up to you:
% f will be linearly interpolated between them.
%
% nCrossVal is the number of chunks to divide into.
%
% GoodRanges gives the times which should be used.  You can use this to exclude
% any times with camera failure etc.  The division into chunks is done evenly on
% the time span from the start of the first good range to the end of the last,
% and the chunks are then intersected with GoodRanges.

function LikRat = PPCrossVal(Res, IndVars, TrainFn, TestFn, nCrossVal, GoodRanges)

LikRat = 0;
FirstTime = min(GoodRanges(:,1));
LastTime = max(GoodRanges(:,2));

global CHUNK; % tut tut - global variables
for CHUNK=1:nCrossVal
	
	% compute training and test time ranges
	ChunkStart = FirstTime + (LastTime-FirstTime)*(CHUNK-1)/nCrossVal;
	ChunkEnd = FirstTime + (LastTime-FirstTime)*CHUNK/nCrossVal;
	
	TestRange0 = [ChunkStart ChunkEnd];
	TestRange = IntersectRanges(TestRange0, GoodRanges);
	
	if (CHUNK==1)
		TrainRange0 = [ChunkEnd LastTime];
	elseif (CHUNK==nCrossVal)
		TrainRange0 = [FirstTime ChunkStart];
	else
		TrainRange0 = [FirstTime ChunkStart; ChunkEnd LastTime];
	end
	
	TrainRange = IntersectRanges(TrainRange0, GoodRanges);
	
	
	% compute firing rate from training set
	fRate = sum(WithinRanges(Res, TrainRange)) / sum(TrainRange(:,2) - TrainRange(:,1));
	
	% compute prediction parameters from training set
	Param = feval(TrainFn, Res, IndVars, TrainRange);
	
	% evaluate prediction on test set
	[f t] = feval(TestFn, Param, IndVars, TestRange);
	f = f(:); t = t(:); % make column vectors
	% subtract amount from poisson process
%	Delta =  PPLogL(Res, f, t, TestRange) - PPLogL(Res, fRate, [], TestRange);
    Lik1 = PPLogL(Res, f, t, TestRange);
    Lik2 = PPLogL(Res, fRate, [], TestRange);
    Delta = Lik1-Lik2;

	nSpikes =sum(WithinRanges(Res, TestRange));
	TotTime = sum(diff(TestRange,[],2));
 fprintf('%f bits per (sec?), %f per spike\n', 20000*Delta/TotTime, Delta/nSpikes);
if 0
	% evaluate on training set, just for fun.
	[fT tT] = feval(TestFn, Param, IndVars, TrainRange);
	fT = fT(:); tT = tT(:); % make column vectors
	% subtract amount from poisson process
	DeltaT =  PPLogL(Res, fT, tT, TrainRange) - PPLogL(Res, fRate, [], TrainRange);
    fprintf('training set: %f per (sec?)\n', 20000*DeltaT/sum(diff(TrainRange,[],2)));
end
	
	LikRat(CHUNK) = Delta;
    Params(CHUNK) = Param;
    
    if 0
        % plot stuff
        figure(2)
        clf
        plot(t/2e4, f*2e4); 
        hold on
        plot([min(t), max(t)]/2e4, [fRate, fRate]*2e4, '--');
        
        xlabel('time (s)'); ylabel('Predicted Firing Rate (Hz)');
        PlotRes = Res(find(Res>=min(TestRange(:)) & Res<=max(TestRange(:))));
        plot(repmat(PlotRes(:)'/2e4,2,1), repmat([-3 -.5]', 1, length(PlotRes)), 'k');
        axis tight
        plot(xlim, [0 0], 'k-');
        pause
    end
end
	
fprintf('Mean info: %f bits/s\n', sum(LikRat)*20000/sum(diff(GoodRanges,[],2)));