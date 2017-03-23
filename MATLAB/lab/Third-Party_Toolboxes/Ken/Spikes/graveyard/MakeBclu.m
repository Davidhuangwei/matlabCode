% MakeBclu(DataBase, BurstTimeWindow)
%
% a script that makes a .bclu file for every file in the data base
% giving the number within the burst for the spikes
% it uses the program BurstCount.C
%
% files produced are :
% .bclu - number within burst
% .bbclu - 10*cluster number + number within burst
%
% NB these are .clu file format - so the first line is the maximum value
% also be warned that the .bclu file will contain zeros (for spikes not
% in a burst).
%
% BurstTimeWindow defaults to 120 (6 ms @ 20kHz);

function MakeBclu(DataBase, BurstTimeWindow)

if nargin<2
	BurstTimeWindow = 120;
end

% loop thru cells
for F = DataBase

	% display where we are
	disp([F.Directory '/' F.FileBase]);

	Res = load([F.Directory '/' F.FileBase '.res']);
	Clu = LoadClu([F.Directory '/' F.FileBase '.clu']);
	
	% set bclu file to be all ones to begin with
	BClu = zeros(size(Clu));
	
	for Cell=2:max(Clu)
		MySpikes = find(Clu==Cell);
		% run BurstCount.C
		msave('tmp.res', Res(MySpikes));
		cmd = sprintf(['!/u5/b/ken/bin/BurstCount -ResFile tmp.res '...
				'-OutFile tmp.out -BurstTimeWindow %d '...
				'-MaxSpikes %d >& tmp.efile'], BurstTimeWindow, length(MySpikes) ...
		);
		
		fprintf('running %s\n', cmd);
		eval(cmd);
		BurstNo = load('tmp.out');

		BClu(MySpikes) = BurstNo;
	end
	
	% save .bclu file
	
	SaveClu([F.Directory '/' F.FileBase '.bclu'], BClu);
	SaveClu([F.Directory '/' F.FileBase '.bbclu'], BClu + 10*Clu);
end