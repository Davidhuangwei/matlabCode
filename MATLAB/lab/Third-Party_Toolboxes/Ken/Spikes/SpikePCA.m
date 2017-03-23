% Fets = SpikePCA(Spk, PCs)
%
% Produces a set of feature vectors from a set of spikes and a set of PCs
%

function Fets = SpikePCA(Spk, PCs)

nSpikes = size(Spk,3);
nChannels = size(Spk, 1);
SpkSampls = size(Spk, 2);
nPCA = size(PCs, 2);

if size(PCs,3) == 1
	% we are looking at a OnePCASet situation
	% make a single vector of all spikes
	fprintf('Rearranging data...\n');
	AllSpikes = reshape(permute(Spk,[3 1 2]), nSpikes*nChannels, SpkSampls);
	
	%subtract out mean
	AllSpikes = AllSpikes - repmat(mean(AllSpikes,1), nSpikes*nChannels, 1);
	
	%now make feature matrix
	fprintf('Calculating features...\n');
	Fets = AllSpikes * PCs;
	Fets = reshape(Fets, [nSpikes,nChannels, nPCA]);
	Fets = permute(Fets, [1 3 2]);
	Fets = reshape(Fets, [nSpikes, nPCA*nChannels]);
else
	% go through channels
	for Channel=1:nChannels
		ChannelSpikes = squeeze(Spk(Channel, :, :))';
		
		ChannelPCs = PCs(:,:,Channel);
		
		% now make feature vector
		ChannelFets = ChannelSpikes * ChannelPCs;
		
		% now add both of these to the output variables
		Fets(:,(Channel-1)*nPCA + 1 : Channel*nPCA) = ChannelFets;
		
	end;
end;