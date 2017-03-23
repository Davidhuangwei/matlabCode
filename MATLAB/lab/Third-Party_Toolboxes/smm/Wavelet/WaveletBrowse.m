%function WaveletBrowse(FileBase, Channels, Window, FreqRange, BegTime)
function WaveletBrowse(FileBase, varargin)

[Channels, Window, FreqRange, BegTime] = DefaultArgs(varargin,{1,5,[1:1:20],[]});

Par = LoadPar([FileBase '.par']);
EegFs = 1e6/Par.SampleTime/16;
FLength = FileLength([FileBase '.eeg']);
nSamples = FLength/Par.nChannels/2;
WindowSamples = Window*EegFs;
i=1;
if isempty(BegTime)
	nWindows = round(nSamples/WindowSamples);
	Beg = Par.nChannels*2*WindowSamples*(i-1);
else
	nWindows=1;
	nSecs = BegTime(1)*60+BegTime(2);
	Beg = Par.nChannels*2*EegFs*nSecs;
end

for i=1:nWindows

	eeg = bload([FileBase '.eeg'],[Par.nChannels WindowSamples],Beg);
	eeg = eeg(Channels,:);
	[wave,f,t] = Wavelet(eeg,FreqRange,EegFs,6,0);
	pow = reshape(abs(wave), size(wave,1),[]);
	ImageMatrix(t,[1:size(pow,2)],flipud(pow'))

pause; end
