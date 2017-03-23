% TrackCells(FileBase1, FileBase2, ElecNo)
% 
% Attempts to track cells between sessions by finding pairs of clusters with similar
% waveforms.

function TrackCells(FileBase1, FileBase2, ElecNo)

% load spike waveforms
Par1 = LoadPar1([FileBase1 '.par.' num2str(ElecNo)]);
Spk1 = LoadSpk([FileBase1 '.spk.' num2str(ElecNo)], Par1.nSelectedChannels, Par1.WaveSamples, inf);
Clu1 = LoadClu([FileBase1 '.clu.' num2str(ElecNo)]);
nClu1 = max(Clu1);

Par2 = LoadPar1([FileBase2 '.par.' num2str(ElecNo)]);
Spk2 = LoadSpk([FileBase2 '.spk.' num2str(ElecNo)], Par2.nSelectedChannels, Par2.WaveSamples, inf);
Clu2 = LoadClu([FileBase2 '.clu.' num2str(ElecNo)]);
nClu2 = max(Clu2);

VecSize = Par1.nSelectedChannels * Par1.WaveSamples;
if (Par1.nSelectedChannels ~= Par2.nSelectedChannels | Par1.WaveSamples ~=Par2.WaveSamples)
	error('the two files are not the same in # channels and samples');
end

% calculate means and covariances
clear Mean1 Mean2 iCov1 iCov2
for c=2:nClu1
	MySpikes = Spk1(:,:,find(Clu1 == c));
	MyVex = reshape(MySpikes, [VecSize, length(MySpikes)])';
	Mean1(:,c) = mean(MyVex)';
	iCov1(:,:,c) = inv(cov(MyVex));
end

for c=2:nClu2
	MySpikes = Spk2(:,:,find(Clu2 == c));
	MyVex = reshape(MySpikes, [VecSize, length(MySpikes)])';
	Mean2(:,c) = mean(MyVex)';
	iCov2(:,:,c) = inv(cov(MyVex));
end

% now compute K-L divergences ...
for c1=2:nClu1
	for c2=2:nClu2
		k12 = KL(Mean1(:,c1), iCov1(:,:,c1), Mean2(:,c2), iCov2(:,:,c2));
		k21 = KL(Mean2(:,c2), iCov2(:,:,c2), Mean1(:,c1), iCov1(:,:,c1));
	end
end

% subfunction to compute K-L divergences from means and inverse covariance matrices
function kl = KL(M1, iC1, M2, iC2)
delta = M1(:) - M2(:);
kl =  .5*log(det(iC2))/log(det(iC1)) ...
	+ .5*trace(inv(iC1)*(iC2-iC1)) ...
	+ .5*delta' * iC2 * delta;