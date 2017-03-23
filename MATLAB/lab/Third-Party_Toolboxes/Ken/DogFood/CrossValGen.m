% Score = CrossValGen(Data, TrainFn, TestFn, nChunks, nParams)
%
% does a cross-validation analysis in general circumstance
%
% Data should be an array or data points (can also be an array of structs)
% which will be indexed by Data(Range,:).  So don't give a row vector!
%
% Param = TrainFn(Data) is a function which takes a set of data and
% produces an output giving fit parameters.  In the case that TrainFn produces
% more than one output, set nParams to the number of outputs
%
% Score = TestFn(Data,Param) is a function that produces a number evaluating
% the fit of the parameters Param on dataset Data.  This can be a log-likelihood
% but doesn't have to be.  If nParams>1, it will be called TestFn(Data,Param1,Param2,...)
%
% nChunks is the number of cross-validation chunks to use (default 10).
%
% The output is the sum of the scores on each chunk

function Score = CrossValGen(Data, TrainFn, TestFn, nChunks, nParams)

if nargin<4; nChunks = 10; end
if nargin<5; nParams = 1; end

nData = size(Data,1);

% ASSIGN CHUNK NUMBERS TO DATA
% when assigning chunks if the number of data points does not divide ...
% take the first n with 1 more than the last nCV-n
nPerChunkSmall = floor(nData/nChunks);
nBigChunks = mod(nData,nChunks);
nSmallChunks = nChunks - nBigChunks;
ChunkNo = [];
for i=1:nChunks
	if i<=nBigChunks
		ChunkNo = [ChunkNo ; i*ones(nPerChunkSmall+1,1)];
    else
		ChunkNo = [ChunkNo ; i*ones(nPerChunkSmall,1)];
    end
end

% NOW THE MAIN LOOP
Score = 0;
for i=1:nChunks
    TrainingSet = Data(find(ChunkNo~=i),:);
    TestSet = Data(find(ChunkNo==i),:);
    Param = cell(nParams,1);
    [Param{:}] = feval(TrainFn, TrainingSet);
    Score = Score + sum(feval(TestFn, TestSet, Param{:}));
end

% keyboard   