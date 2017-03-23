% Clean = RemoveStimulusArtefacts(Intra, Drive, StepThresh, RemoveSize)
%
% given a intracellular trace and an intracellular drive
% command, this program tries to remove stimulus artefacts
%
% it only works if the artefacts are all the same - i.e. you
% have current steps of all the same size.
%
% StepThresh is the threshold for the diff(Drive) for detecting
% a step.
%
% Before and After give the size of the chunk on either side of
% the step to remove

% The programs calculates the median of the upwards artefacts,
% and subtracts it from upwards and adds it to downwards steps
% (upward is used because there is less likely to be a spike at
% that time)

function Clean = RemoveStimulusArtefacts(Intra, Drive, StepThresh, Before, After)

n = length(Intra);

if nargin<3
	StepThresh = 2000;
end
if nargin<4
	Before = 10;
end
if nargin<5
	After = 20;
end

dStep = diff(Drive);
StepOn = LocalMinima(-dStep, 2, -StepThresh);
StepOff = LocalMinima(dStep, 2, -StepThresh);

Artefacts = GetSegs(Intra, StepOn-Before, Before+After + 1, []);

MedArt = median(Artefacts, 2);
MedArt = MedArt - MedArt(1);

Clean = Intra(:);

for t = StepOn
	if (t>Before & t<=n-After);
		Clean(t-Before:t+After) = Clean(t-Before:t+After) - MedArt;
   end
end

for t = StepOff
	if (t>Before & t<=n-After);
		Clean(t-Before:t+After) = Clean(t-Before:t+After) + MedArt;
   end
end
