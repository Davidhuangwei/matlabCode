% MakeQualFiles(DataBase)
% goes through the files of the specified database and makes .qual files, if none exists

function MakeQualFiles(DataBase)

%%%%%%%%%%%%%%
% PARAMETERS %
%%%%%%%%%%%%%%

BurstTimeWin = 120; % counts as part of a burst if its in this time window of previous spike

%%%%%%%%
% CODE %
%%%%%%%%

%OutFp = fopen('dbase.qual', 'w');

for File = DataBase
	% extract filebase
	FileBase = [File.Directory, '/', File.FileBase];
	
	Par = File.Par;
	for ElecNo = 1:(Par.nElecGps)
		Par1 = LoadPar1([FileBase, '.par.', num2str(ElecNo)])
		Fet = LoadFet([FileBase, '.fet.', num2str(ElecNo)]);
		Clu = LoadClu([FileBase, '.clu.', num2str(ElecNo)]);
		Res = load([FileBase, '.res.', num2str(ElecNo)]);
		fprintf('done loading\n');
		
		nClusters = max(Clu);
		nSpikes = length(Clu);
		nFet = Par1.nSelectedChannels * Par1.nPCs;
				
		for c=2:nClusters
			fprintf('\ndoing cluster %d...', c);
			% find spikes in this clustr and calculate mahal dist
			MySpikes = find(Clu==c);
			nMySpikes = length(MySpikes);
			[HalfDist, WorstBurstRat, WorstBurstRatAt] = ClusterQuality(Fet(:,1:nFet), MySpikes, Res, BurstTimeWin);

			CellCount = File.ElecGp(ElecNo).FirstCell+c-2; % overall cell number
			CellType = File.Cell(CellCount).Type;
%			fprintf('%s.%d cell %d type %s nSpikes %d EqDist %f Worst bRat %f at %f\n', ...
%			fprintf(OutFp, '%s.%d cell %d type %s nSpikes %d EqDist %f Worst bRat %f at %f\n', ...
%				FileBase, ElecNo, c, CellType,...
%				nMySpikes, HalfDist, WorstBurstRat, WorstBurstRatAt);
			
			% Keep track of qualities so you can write them to a file
			eDist(CellCount) = 	HalfDist;
			bRat(CellCount) = WorstBurstRat;
		end
	end
	
	% write quality file
	msave([FileBase, '.qual'], [eDist' , bRat']);
end
