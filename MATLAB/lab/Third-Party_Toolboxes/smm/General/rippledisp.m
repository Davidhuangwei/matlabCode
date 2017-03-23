% local ripple vs local firing rate analysis.

% load sharpwaves 

SW = load('nm101s.sw')/16;

chselect = [1:7]+1;
if ~exist('eeg');
eeg = readmulti('nm101s.eeg',8,chselect);
end;

iso_spw = zeros(2000,length(chselect));

for ii=SW(1,1):SW(1,3)
    for jj=1:length(chselect)
        iso_spw(ii-SW(1,1)+1,jj) = eeg(SW(1,1),jj);
    end
end


plot(iso_spw(:,1));
