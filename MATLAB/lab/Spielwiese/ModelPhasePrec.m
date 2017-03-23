function ModelPhasePrec(varargin)
in = DefaultArgs(varargin,{1});


x = [1:100];             %% distance
t = [1:15000];            %% time
v = max(x)/max(t);       %% velocity
f = 8;                   %% oscillation frequency of unit
sigma = 5;             %% place field size
alpha = 0;               %% precession parameter
N = 1000;               %% number  of place fields
 

figure(1),clf
figure(2),clf
for a = 0:5
  alpha = a*6;
  
  xi = rand(N,1)*max(t)/max(x)*2;
  xi(end) = max(t)/max(x);
  r=zeros(size(t));
  for n=1:length(xi)
    ri = 0.5*[1+cos(2*pi*f/1000*(t-alpha*xi(n)))] .* exp(-((t*v-xi(n))/sigma).^2);
    r = r + ri;
  end
  
  
  figure(1)
  subplot(5+1,1,a+1)
  plot(t,r/max(r))
  hold on
  xi(n) = max(t)/max(x);
  plot(t,ri,'r')
  %xlim([2200 2800])  
  
  NF = 2^12;
  FFTR = fft(r,NF);
  PR = FFTR.*conj(FFTR)/NF;
  figure(2)
  subplot(5+1,1,a+1)
  plot(1000*(2:100)/NF,PR(3:101))
  Lines(8,[],'r');
  
end