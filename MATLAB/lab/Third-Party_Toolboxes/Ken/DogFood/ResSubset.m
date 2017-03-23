% ResSubSet(From, To, Ranges)
%
% loads From.res, From.clu, and all From.fet.n, From.spk.m, etc
% finds those spikes from which the res values are within Ranges,
% and writes To.res, etc.
%
% also copies .par and .par.n files, and .mm files

function ResSubSet(From, To, Ranges)

Par = LoadPar([From '.par']);
if 0
Res = load([From '.res']);
good = find(WithinRanges(Res, Ranges));
msave([To '.res'], Res(good));
clear Res;

Clu = LoadClu([From '.clu']);
SaveClu([To '.clu'], Clu(good));

eval(['!cp ' From '.par ' To '.par']);
end
for i=1:Par.nElecGps
	stri = num2str(i);
	Par1 = LoadPar1([From '.par.' num2str(i)]);
	Res = load([From '.res.' stri]);
	good = find(WithinRanges(Res, Ranges));

	msave([To '.res.' stri], Res(good));
	clear Res;

	Clu = LoadClu([From '.clu.' stri]);
	SaveClu([To '.clu.' stri], Clu(good));
	clear Clu;

	Fet = LoadFet([From '.fet.' stri]);
	SaveFet([To '.fet.' stri], Fet(good,:));

    % do Spk with a loop to save memory ...
    n2Load = 1+max(good)-min(good);
    LoadFrom = min(good)-1;
    BlkSize = 2*Par1.nChannels*Par1.WaveSamples;
    fpIn = fopen([From '.spk.' stri], "r");
    fpOut = fopen([To '.spk.' stri], "r");
    dGood = diff (Good)
    for i=1:length(good);
        if i==1 | dGood(i)>1 % skip position if necessary
            fseek(fpIn, (good(i)-1)*BlkSize, 'bof');
        end
        
        spk = fread(fpIn, BlkSize, '*short');
        fwrite(fpOut, spk, 'short');
    end
    fclose(fpIn);
    fclose(fpOut);
    
        
        
%	Spk = LoadSpk([From '.spk.' stri], Par1.nChannels, Par1.WaveSamples, max(good));
	% load spike manually to deal with huge files ...
    n2Load = 1+max(good)-min(good);
    LoadFrom = min(good)-1;
	Spk = bload([From '.spk.' stri], [Par1.nChannels, Par1.WaveSamples*n2Load], ...
		LoadFrom*2*Par1.nChannels*Par1.WaveSamples, '*int16');
	nSpikes = size(Spk,2)/Par1.WaveSamples;
	Spk = reshape(Spk, [Par1.nChannels, Par1.WaveSamples, nSpikes]);
	SaveSpk([To '.spk.' stri], Spk(:,:,good-LoadFrom));
	clear Spk
    
    % now copy .par.n and .mm.n    
    eval(['!cp ' From '.par.' stri ' ' To '.par.' stri]);
    eval(['!cp ' From '.mm.' stri ' ' To '.mm.' stri]);   
end