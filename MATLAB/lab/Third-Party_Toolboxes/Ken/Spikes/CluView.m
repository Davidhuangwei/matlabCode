% CluView(FileBase, ElecNo)
%
% Goes through clusters in order and displays
% ACG, waveforms, and some projections.

function CluView(FileBase, ElecNo)

Par = LoadPar([FileBase '.par']);
Par1 = LoadPar1([FileBase '.par.' num2str(ElecNo)]);
Fet = LoadFet([FileBase '.fet.' num2str(ElecNo)]);
Clu = LoadClu([FileBase '.clu.' num2str(ElecNo)]);
Res = load([FileBase '.res.' num2str(ElecNo)]);
Spk = LoadSpk([FileBase '.spk.' num2str(ElecNo)], Par1.nSelectedChannels, Par1.WaveSamples);

nSpikes = length(Res);

% make spacing matrix for plotting spikes

SpaceMat = repmat((1:Par1.nSelectedChannels)', 1, Par1.WaveSamples);
SpaceMat = SpaceMat * range(Spk(:))/2;

for c=2:max(Clu)
	% Plot Waveforms
	MySpikes = find(Clu==c);
	nMySpikes = length(MySpikes);
	figure(1)
	clf
	set(gcf, 'position', [5 50 200 700]) ;
	axis off;
	
	Spikes2Plot = MySpikes(round(1:nMySpikes/50:nMySpikes));
	n2Plot = length(Spikes2Plot);
	
	tmp = Spk(:,:,Spikes2Plot) + repmat(SpaceMat,[1 1 n2Plot]);
	
	tmp2 = reshape(permute(tmp, [2 1 3]), ...
			[Par1.WaveSamples, Par1.nSelectedChannels*n2Plot]) ; 
			
	plot(tmp2, 'k');
	
	% Plot ACG
	figure(2)
	clf
	set(gcf, 'position', [210 350 400 400])    
	
	CCG(Res(MySpikes), 1, 20, 30, 1e6/Par.SampleTime);
	
	% Scatter plot of features
	figure(3)
	clf
	set(gcf, 'position', [620, 350, 400, 400]);
	
	switch Par1.nSelectedChannels
		case 1
			FetCombo = [1 2 ; 2 3 ; 3 4 ; 1 4];
		case 2
			FetCombo = [1 6 ; 2 7 ; 3 8 ; 4 9];
		case 3
			FetCombo = [1 5 ; 5 9 ; 1  9  ; 2 6];
		case 4		
			FetCombo = [1 4 ; 4 7 ; 7 10 ; 10 1];
		otherwise 
			FetCombo = [1 4 ; 4 7 ; 7 10 ; 10 1];
	end
	
	axes('position', [0 0 .5 .5]);
	Scat(Fet(:,FetCombo(1,:)), MySpikes);
	axis off
	
	axes('position', [0 .5 .5 .5]);
	Scat(Fet(:,FetCombo(2,:)), MySpikes);
	axis off
	
	axes('position', [.5 0 .5 .5]);
	Scat(Fet(:,FetCombo(3,:)), MySpikes);
	axis off
	
	axes('position', [.5 .5 .5 .5]);
	Scat(Fet(:,FetCombo(4,:)), MySpikes);
	axis off
	
	fprintf('Cluster %d\n', c);
	pause
end
			
function Scat(x, p)
	cla; hold on;
	plot(x(:,1), x(:,2), 'k.', 'MarkerSize', 1);
	plot(x(p,1), x(p,2), 'r.', 'MarkerSize', 2);
