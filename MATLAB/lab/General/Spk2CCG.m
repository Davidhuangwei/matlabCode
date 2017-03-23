function [T,G, ccg] = Spk2CCG(Spk, WhichEl, BinSize, HalfBins, TakeNoise)
% function [T,G] = Spk2CCG(Spk, WhichEl, BinSize, HalfBins, TakeNoise)
if nargin<5 | isempty(TakeNoise)
    TakeNoise = 0;
end
if nargin<4 | isempty(HalfBins)
    HalfBins = 50;
end
if nargin<3 | isempty(BinSize)
    BinSize = 50;
end
  
T=[]; G=[];

if isstr(Spk)
    cnt=0;
    for el=WhichEl
        rfn=[Spk '.res.' num2str(el)];
        cfn=[Spk '.clu.' num2str(el)];
        res = load(rfn);
        clu = load(cfn);
        if ~TakeNoise
            clu=clu(2:end);
            ind = find(clu~=1);
            res=res(ind);
            clu=clu(ind);
        end
        T = [T; res];
        G = [G; clu + cnt];
        cnt = cnt + max(G);
    end
    parfn=[Spk '.par'];
    Par = LoadPar(parfn);
    SampleRate = 1e6/Par.SampleTime;
    if (nargin < 2 | isempty(WhichEl))
        WhichEl = [1:Par.nElecGps];   
    end
else
    display('Attention!\n');
    SampleRate = 20000    
    elnum=size(Spk,1);
    if (nargin < 2 | isempty(WhichEl))
        WhichEl = [1:numel];
    end
    cnt =0;
    for el=WhichEl
        for j=2-TakeNoise:clusize(Spk,el)
            T = [T; Spk{el,j}];
            G = [G; ones(length(Spk{el,j}),1)*j+cnt];
            cnt = cnt+max(G);
        end
    end
end
BinSize = BinSize * SampleRate / 1000;
if nargout == 0
    figure
    CCGlite(T, G, BinSize, HalfBins, SampleRate, unique(G), 'scale');
end
if nargout>2
    ccg = CCG(T, G, BinSize, HalfBins, SampleRate,unique(G), 'scale');
end

    