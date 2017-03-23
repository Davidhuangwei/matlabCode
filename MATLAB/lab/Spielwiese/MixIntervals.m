function itv = MixIntervals(itv1,itv2,mode,varargin)
%% 
%% combine intervals according to 'mode'
%% 
%% IN: 
%%    itv1 and itv2 are intervals nx2 [begining end]
%%    mode : 1 - find common (overlap) intervals 
%%           0 - find exclusive intervals (itv1 exclusive of itv1)
%%           2 - find combined intervals
%% 
[PLOT] = DefaultArgs(varargin,{0});


a1 = find(WithinRanges([1:itv1(end,2)],itv1));
a2 = find(WithinRanges([1:itv2(end,2)],itv2));

switch mode
 case 1
  na = a1(find(ismember(a1,a2)));
 case 0
  na = a1(find(~ismember(a1,a2)));
 case 2
  na = unique([a1; a2]);
end

%keyboard

if isempty(na)
  error('no interval found')
end

itv(:,2) = [na(find(diff(na)>1)); na(end)];
itv(:,1) = [na(1); na(find(diff(na)>1)+1)];

if PLOT
  figure(1);clf
  Lines(itv1(:,1),[0 1]);
  Lines(itv1(:,2),[0 1],'r','--');
  Lines(itv2(:,1),[1 2],'g');
  Lines(itv2(:,2),[1 2],'g','--');
  Lines(itv(:,1),[2 3],'b');
  Lines(itv(:,2),[2 3],'b','--');
end

return;