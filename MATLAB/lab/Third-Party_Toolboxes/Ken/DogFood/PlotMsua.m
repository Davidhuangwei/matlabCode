% PlotMsua(FileBase)
% plots the spikes in the .msua file (Mean Spike Unfiltered on All channels)
% the appropriate location is read from .par and .par.1 files

function PlotMsua(FileBase)

Par = LoadPar([FileBase '.par']);

% create "fake" elec gp out of unused channels
Par.ElecGp{length(Par.ElecGp)+1} = setdiff(0:Par.nChannels-1, vertcat(Par.ElecGp{:}))

% Par0 = Par;
% Par.ElecGp{3} = [Par0.ElecGp{3}(4); Par0.ElecGp{4}(2);  Par0.ElecGp{3}([6 3 5 2 1 7])];
% Par.ElecGp{4} = Par0.ElecGp{4}([6 1 5 3 4 7]);

Msua = LoadSpk([FileBase '.msua'], Par.nChannels);

% find maximum peak to peak amp
p2p = sq(max(Msua,[],2)) - sq(min(Msua,[],2));

xr = 1:size(Msua,2);
ySpacing = 2^12;
xSpacing = size(Msua,2) * 4/3;

cla; hold on
for c=1:size(Msua,3) % loop over cells
%for c=33:size(Msua,3) % loop over cells
    cla
	for e=1:length(Par.ElecGp) % loop over trodes
		for ch=1:length(Par.ElecGp{e})
            MyMean = mean(Msua(Par.ElecGp{e}(ch)+1, :, c));
			plot(xr + xSpacing*e, Msua(Par.ElecGp{e}(ch)+1, :, c)-MyMean + ySpacing*ch);
		end
	end
    fprintf('Cell %2d\n', c);
    pause
end