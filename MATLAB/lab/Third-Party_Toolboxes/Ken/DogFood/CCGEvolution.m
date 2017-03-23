% [Out xr yr] = CCGEvolution(Res, Clu, BinSize, HalfBins, Cell1, Cell2, ChunkSize);
%
% divides time into chunks of length ChunkSize (in samples) and then
% computes a CCG in each one, and displays them as a 2d plot
%
% optional outputs Out is matrix of outputs Out(CCGBin, Chunk, Cell1, Cell2) for Cell2>Cell1
% xr and yr are for if you want to display it: imagesc(xr, yr, Out(:,:,Cell1, Cell2));

function [Out, xr, yr]  = CCGEvolution(T, G, BinSize, HalfBins, SampleRate, GSubset, ChunkSize)

Eps = 1;

% compute CCG
[out, t, Pairs] = CCG(T, G, BinSize, HalfBins, SampleRate, GSubset);

for i1=1:length(GSubset)-1
    Cell1 = GSubset(i1);
    for i2=i1+1:length(GSubset)
        Cell2=GSubset(i2);
        fprintf('Doing %d %d\n', Cell1, Cell2);

		MyPairs = Pairs(find(G(Pairs(:,1))==Cell1 & G(Pairs(:,2))==Cell2),:);
		
		% which chunk does each spike belong to?
		SpkChunk = 1+floor((T-min(T))/ChunkSize);
		nChunks = max(SpkChunk);
        
        % MATLAB SUCKS!!!! THIS WHOLE INDEXING THING IS A PILE OF SHIT
        if size(MyPairs,1)>1
    		DiffBin = round(diff(T(MyPairs),1,2)/BinSize) + HalfBins + 1;
        else
            DiffBin = round(diff(T(MyPairs))/BinSize) + HalfBins + 1;
        end
        
		if any(DiffBin<=0 | DiffBin>1+2*HalfBins)
            warning('Time difference Out of range')
            DiffBin(find(DiffBin<=0)) = 1;
            DiffBin(find(DiffBin>1+2*HalfBins)) = 1+2*HalfBins;
		end
		
        if size(MyPairs, 1)>0
    		Count = Accumulate([DiffBin, SpkChunk(MyPairs(:,1))], 1, [2*HalfBins+1, nChunks]);
        else
            Count = zeros(2*HalfBins+1, nChunks);
        end
		
		% scale it.  How many coincidences are expected?
		n1 = Accumulate(SpkChunk(find(G==Cell1)),1,nChunks);
		n2 = Accumulate(SpkChunk(find(G==Cell2)),1,nChunks);
		Expected = n1.*n2/(ChunkSize/BinSize);
		
		Scaled = (Count+Eps) ./(repmat(Expected',2*HalfBins+1,1)+Eps);
        if nargout>=1
            Out(:,:,i1,i2) = Scaled;
            Out(:,:,i2,i1) = Scaled;
            xr = (0:nChunks-1)*ChunkSize/SampleRate;
            yr = (-HalfBins:HalfBins)*BinSize/SampleRate*1000;
        else
			cla; hold off
			imagesc((0:nChunks-1)*ChunkSize/SampleRate, (-HalfBins:HalfBins)*BinSize/SampleRate*1000, log10(Scaled));
			%caxis([-1 1])
			hold on; plot(xlim, [25 25], 'k:', xlim, [-25 -25], 'k:');
			colorbar
			xlabel('Time (s)');
			ylabel('dt (ms)');
            drawnow
        end
    end
end
return
% test code
% first 100s of 10hz independent
res1 = rand(2000, 1)*20000*100;
clu1 = [ones(1000,1);2*ones(1000,1)];

% then 100s of 10hz correlated with 25ms jitter
res2 = (1+rand(1000,1))*20000*100; res2 = [res2;res2+randn(1000,1)*25*20];
clu2 = clu1;

CCGEvolution([res1;res2], [clu1;clu2], 80, 50, 20000, [1 2], 20000*20);
