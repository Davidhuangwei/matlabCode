function spikew = FindGoodWheelCells(FileBase,T,IN,PH,wheel)
%% 
%% find good wheel fields - identify spikes belonging to a wheel-field

Par = LoadPar([FileBase '.par']);

WX = wheel.dist(round(T/Par.SampleRate*wheel.whlrate))/2/pi;


spikew = [];

for n=unique(IN)'
  ix = find(IN==n);% & WithinRanges(T/Par.SampleRate*wheel.whlrate,wheel.runs));
  
  figure(34768);clf
  plot(WX(ix),PH(ix),'.')
  hold on
  plot(WX(ix),PH(ix)+2*pi,'.')
  
  go = input('go');
  
  
  
end
