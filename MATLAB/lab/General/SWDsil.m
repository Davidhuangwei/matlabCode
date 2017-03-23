% function SWD_a(filename,numch,chselect,highband,lowband,threshold)
% is a procedure to detect sharpwaves from EEG file
%anton modified
function SWDsil(filename,whichel, FreqRange,Threshold)

efilename = sprintf('%s.eeg',filename);
parfilename = sprintf('%s.par',filename);
par=LoadPar(parfilename);

if (nargin<2 | isempty(whichel))
    whichel = [1:par.nElecGps];
end
    
if (nargin<3 | isempty(FreqRange))
    FreqRange = [130 230];
end

if (nargin<3 | isempty(Threshold))
    Threshold  = 5;
end

for el=whichel
    sfilename = [filename '.' num2str(el) '.sw' num2str(Threshold)];
    
    s = sdetect_a(efilename,par.nChannels,par.ElecGp{el}+1,FreqRange(2),FreqRange(1),Threshold);
    if s~=[]
        msave(sfilename,s);
        vsave(['s' num2str(el) '.' num2str(Threshold)] ,s(:,2));
    end
end