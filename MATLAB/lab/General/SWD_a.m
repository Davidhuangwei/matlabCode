% function SWD_a(filename,numch,chselect,highband,lowband,threshold)
% is a procedure to detect sharpwaves from EEG file
%anton modified
function SWD_a(filename,numch,chselect,highband,lowband,threshold)

efilename = sprintf('%s.eeg',filename);

sfilename = sprintf(['%s.sw' num2str(threshold)],filename);

s = sdetect_a(efilename,numch,chselect,highband,lowband,threshold);
if s~=[]
msave(sfilename,s);
vsave('s',s(:,2));
end