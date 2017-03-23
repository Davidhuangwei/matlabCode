% [FalsePos FalseNeg DiffClu] = ClusteringErrors(Clu, IntraClu, nSpikesCorrect, CorrectClu, CorrectIntraClu)
%
% Evaluate false positive and negative %ages of a clustering
% FalsePos and FalseNeg return the percentages.
% DiffClu (optional output argument) returns a vector enumerating 
% the classification of each spike.  1 - correct negative
% 2 - false negative.  3 - false positive.  4 - correct positive
%
% Clu and IntraClu may be arrays or filenames giving the cluster file to 
% evaluate and the correct file.
%
% nSpikesCorrect is the correct number of spikes - which should be
% more than the number of lines in the IntraClu file because
% some correct spikes are not detected.
% IT HAS NO DEFAULT SO YOU DON'T FORGET IT!
%
% CorrectClu and CorrectIntraClu are the cluster numbers to examine
% in the CluFile and the IntraCluFile.
%
% Default values are 2 for CorrectIntraClu
% and whichever has the most correct spikes for CorrectClu


function [FalsePos, FalseNeg, DiffClu] = ClusteringErrors(Clu, IntraClu, nSpikesCorrect, CorrectClu, CorrectIntraClu)

% replace filenames with arrays, if necessary

if (ischar(Clu))
	Clu = LoadClu(Clu);
end;

if (ischar(IntraClu))
	IntraClu = LoadClu(IntraClu);
end;

% make crosstab

[Table Vals1 Vals2] = CrossTab(Clu, IntraClu);

% default value for CorrectIntraClu
if (nargin<5 | isempty(CorrectIntraClu))
	CorrectIntraClu = 2;
end;


% default value for CorrectClu
if (nargin<4 | isempty(CorrectClu))
	% set CorrectClu to be that that has the largest overlap
	[ignore CorrectClu] = max(Table(:,CorrectIntraClu));
end;


nFound = Table(CorrectClu, CorrectIntraClu);
nFalse = sum(Table(CorrectClu,:)) - nFound;

FalsePos = 100*nFalse / (nFalse+nFound);

FalseNeg = 100*(nSpikesCorrect - nFound)/nSpikesCorrect;

if (nargout >=3)
	DiffClu = 1 + 2*(Clu == Vals1(CorrectClu)) + (IntraClu == CorrectIntraClu);
end;