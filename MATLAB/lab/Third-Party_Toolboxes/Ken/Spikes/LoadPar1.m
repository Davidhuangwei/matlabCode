function Par = LoadPar1(FileName)
% LoadPar1 loads the specified .par.n file and returns a structure with these elements:
%
% .FileName           -> name of file
% .nChannels          -> number of total channels in the whole file
% .nSelectedChannels  -> number of channels for this electrode group
% .SampleTime         -> time, in microseconds, of 1 sample (ie 1e6 / sample rate)
% .SelectedChannels   -> selected channel ids i.e. [2 3 4 5]
% .DetectionRefract   -> refractory period after spike detection
% .IntegrationLength  -> RMS integration window length
% .ApproxFiringFreq   -> approximate firing frequency in Hz (or is it threshold?)
% .WaveSamples        -> number of samples extracted to the .spk file
% .PeakPos            -> peak position in the .spk file (should be half of .WaveSamples)
% .AlignmentSamples   -> number of samples used in alignment program
% .AlignmentPeak      -> peak position used in alignment program
% .ReconSamplesPre    -> number of samples before peak to use in reconstruction
% .ReconSamplesPost   -> number of samples after peak to use in reconstruction
% .nPCs               -> number of principal components
% .PCSamples          -> number of samples used in the PCA
% .HiPassFreq    -> High pass filter frequency
%
% The difference between this and LoadPar is that this function
% loads a .par.n file - not a .par file


% open file
fp = fopen(FileName, 'r');
Par.FileName = FileName;

% read in nChannels, nSelectedChannels, and SampleTime
Line = fgets(fp);
A = sscanf(Line, '%d %d %d');
Par.nChannels = A(1);
Par.nSelectedChannels = A(2);
Par.SampleTime = A(3);

% read in SelectedChannels
Line = fgets(fp);
A = sscanf(Line, '%d');
Par.SelectedChannels = A;

% read in DetectionRefract and IntegrationLength
Line = fgets(fp);
A = sscanf(Line, '%d %d');
Par.DetectionRefract = A(1);
Par.IntegrationLength = A(2);

% read in ApproxFiringFreq
Line = fgets(fp);
A = sscanf(Line, '%d');
Par.ApproxFiringFreq = A(1);

% read in WaveSamples and PeakPos
Line = fgets(fp);
A = sscanf(Line, '%d %d');
Par.WaveSamples = A(1);
Par.PeakPos = A(2);

% read in AlignmentSamples and AlignmentPeak
Line = fgets(fp);
A = sscanf(Line, '%d %d');
Par.AlignmentSamples = A(1);
Par.AlignmentPeak = A(2);

% read in ReconSamplesPre and ReconSamplesPost
Line = fgets(fp);
A = sscanf(Line, '%d %d');
Par.ReconSamplesPre = A(1);
Par.ReconSamplesPost = A(2);

% read in nPCs and PCSamples
Line = fgets(fp);
A = sscanf(Line, '%d %d');
Par.nPCs = A(1);
Par.PCSamples = A(2);

% read in HiPassFreq
%Line = fgets(fp);
%A = sscanf(Line, '%d');
%Par.HiPassFreq = A(1);

