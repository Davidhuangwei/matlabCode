 % helper function to do argument defaults etc for mt functions
% for point process Dims - temporal dimansion of input nSamples

function [x, Res, Clu, nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,nChannels, nClu, nSamples,...
    nFFTChunks,winstep,select,nFreqBins,f,t,FreqRange,CluSubset,Segments,pval,MinSpikes] = mtparam_pt(P)

nargs = length(P);
% analysis of what's the input
if (~isempty(P{1}) & length(P{1}) == length(P{2}) )
    % have only point process
    Res = P{1};
    Clu = P{2};
    x=[];
    nChannels = 0;
    nSamples = max(Res)+1;
    nInputs = 2;
elseif isempty(P{1}) & length(P{2}) == length(P{3})
   % have only point process
    Res = P{2};
    Clu = P{3};
    x=[];
    nChannels = 0;
    nSamples = max(Res)+1;
    nInputs = 3;  
elseif ~isempty(P{1}) & (length(P{2}) == length(P{3})) & ~isempty(P{2}) & length(P{2})>1
    Res = P{2};
    Clu = P{3};
    x = P{1};
    % check for column vector input
    nChannels = size(x,2);
    nSamples =  size(x,1);
    if nSamples == 1 | nSamples < nChannels
        x = x';
        nSamples = size(x,1);
        nChannels = size(x,2);
    end;
    nInputs=3;
elseif ~isempty(P{1}) & isempty(P{2}) & isempty(P{3})
    x = P{1};
    nChannels = size(x,2);
    nSamples =  size(x,1);
    Clu=[];Res=[];
    if nSamples == 1 | nSamples < nChannels
        x = x';
        nSamples = size(x,1);
        nChannels = size(x,2);
    end;
    nInputs=3;
elseif ~isempty(P{1}) & ~isempty(P{2}) & length(P{2})==1
    x = P{1};
    nChannels = size(x,2);
    nSamples =  size(x,1);
    Clu=[];Res=[];
    if nSamples == 1 | nSamples < nChannels
        x = x';
        nSamples = size(x,1);
        nChannels = size(x,2);
    end;
    nInputs=1;
    
else
    error('some of the signal inputs are wrong');
end

CluInd = unique(Clu);
if ~isempty(x) 
nT = max(size(x,1));
else
nT = max(Res);
end
P = P(nInputs+1:end); nargs = nargs - nInputs ;
if (nargs<1 | isempty(P{1})) nFFT = 1024; else nFFT = P{1}; end;
if (nargs<2 | isempty(P{2})) Fs = 2; else Fs = P{2}; end;
if (nargs<3 | isempty(P{3})) WinLength = nFFT; else WinLength = P{3}; end;
if (nargs<4 | isempty(P{4})) nOverlap = WinLength/2; else nOverlap = P{4}; end;
if (nargs<5 | isempty(P{5})) NW = 3; else NW = P{5}; end;
if (nargs<6 | isempty(P{6})) Detrend = ''; else Detrend = P{6}; end;
if (nargs<7 | isempty(P{7})) nTapers = 2*NW -1; else nTapers = P{7}; end;
if (nargs<8 | isempty(P{8})) FreqRange = [0 Fs/2]; else FreqRange = P{8}; end
if (nargs<9 | isempty(P{9})) CluSubset = CluInd; else CluSubset = P{9}; end
if (nargs<10 | isempty(P{10})) Segments = [1 nT]; else Segments = P{10}; end
if (nargs<11 | isempty(P{11})) pval=0.05; else pval = P{11}; end
%MinSpikes = 2*nTapers - theoretical recommendation from Jarvis and Mitra
if (nargs<12 | isempty(P{12})) MinSpikes=2*nTapers; else MinSpikes = P{12}; end 
% Now do some compuatations that are common to all spectrogram functions


if ~isempty(Res)
    %select spikes from Segments, if not done at the input
    [Res, ind] = SelectPeriods(Res,Segments,'d',1);
    Clu = Clu(ind);
    CluInd = unique(Clu);

    %check if there are some missing clusters in Clu and exclude them from
    %CluSubset
    CluSubset = intersect(CluSubset,CluInd);
    nClu = length(CluSubset);
    myClu = ismember(Clu, CluSubset);
    Res = Res(myClu);
    Clu = Clu(myClu);
else
    CluSubset = [];
    nClu=0;
end
%here is the time information

winstep = WinLength - nOverlap;
% calculate number of FFTChunks
nFFTChunks = round(((nSamples-WinLength)/winstep));
if nFFTChunks==0
    nFFTChunks=1;
end
% turn this into time, using the sample frequency
t = winstep*(0:(nFFTChunks-1))'/Fs;
 
% set up f and t arrays
if ~any(any(imag(x))) | isempty(x)   % x purely real
	if rem(nFFT,2),    % nfft odd
		select = [1:(nFFT+1)/2];
	else
		select = [1:nFFT/2+1];
	end
	nFreqBins = length(select);
else
	select = 1:nFFT;
end
f = (select - 1)'*Fs/nFFT;
nFreqRanges = size(FreqRange,1);
if (FreqRange(end)<Fs/2)
    if nFreqRanges==1
        select = find(f>FreqRange(1) & f<FreqRange(end));
        f = f(select);
        nFreqBins = length(select);
    else
        select=[];
        for i=1:nFreqRanges
            select=cat(1,select,find(f>FreqRange(i,1) & f<FreqRange(i,2)));
        end
        f = f(select);
        nFreqBins = length(select);
    end
end

