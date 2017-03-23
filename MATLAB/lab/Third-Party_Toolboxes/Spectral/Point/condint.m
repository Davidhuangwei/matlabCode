function [h, tau] = condint(spts, bn);
%
%  CONDINT estimates the conditional intensity function of a point process
%
%  H = CONDINT(SPTS, BN) returns the conditional intensity in H for the
%  point process in SPTS.  If SPTS is an array, H is averaged across its
%  rows.
%
%  [H, TAU] = CONDINT(SPTS) calculates the conditional intensity on the
%  range TAU.  The default TAU is evenly sampled over the range of
%  SPTS with 1 event for each bin.
% 

%  Written by: Bijan Pesaran, 07/06/00

sp = spts2sp(spts, bn);

ntrials = length(sp);

range = []; ne = [];

for i = 1:ntrials 
  range = [range; minmax(sp{i})];
  ne(i) = length(sp{i});
end

N = sum(ne);

range = minmax(range);
nbins = floor(N*(N-1));
nbins = nbins - 1 + mod(nbins,2);

tau = linspace(min(range), max(range), nbins) - min(range);
tau = [-tau(end:-1:2) tau];  delta = diff(tau(1:2));


h = zeros(1,length(tau)-1);  ind=0;  N=0;
for tr = 1:ntrials
  h_tmp = zeros(1,length(tau)-1);
  events = sp{tr};
  nevents = length(events);
  if (nevents > 1)
    ind = ind+1;
    for nev = 1:nevents
      [n, x] = hist(events - events(nev), tau);
      h_tmp = h_tmp + n; % - ne(tr)./delta;
    end
    N = N + nevents - 1;
    h(ind,:) = h_tmp./nevents;
  end
end

h(:,nbins) = 0;  
h = sum(h,1)./N./delta;
h(end/2-1:end/2+1) = 0;
tau=x;

