function [Pyy f y t] = OscilModel_F(varargin)
[speed,compress,freq,slope,plotting] = DefaultArgs(varargin,{30,0.0042,7.5,0.08,1});
%% 
%% speed = cm/s
%% compress = s/cm
%% freq = Hz 
%% slope = 1/cm
%%   F = slope*speed + freq


%% time
t = [1:1000]/100;

%% distance
dist = t*speed;

%% 
F = slope*speed + freq; 
beta = 30;
alpha = beta*compress;
sigma = 2/F;

n=0;
m=0;
while m*beta/speed <= max(t)
  m=m+0.01*max(t);
  n=n+1;
  y(:,n) = (cos(2*pi*F*(t - m*alpha)) +1).*exp(-(t-m*beta/speed).^2/(sigma)^2);
end

%for m=[0:0.01:1]*max(t)
%  n=n+1;
%  y(:,n) = (cos(2*pi*F*(t - m*alpha)) +1).*exp(-(t-m*beta/speed).^2/(sigma)^2);
%end

fy = fft(sum(y,2),512);
Pyy = fy.*conj(fy)/512;
f = 100*[0:256]/512;

[mf fi] = max(Pyy(2:end));

%keyboard 

yy = sum(y,2);
if plotting
  
  figure(123);clf
  
  subplot(211)
  imagesc(1,[],y)
  %plot(t,[yy/max(yy)],'--')
  %hold on
  %plot(t,y(:,[1:10:end])/max(y(:,10)))
  title('place fields')
  xlabel('time [sec]')
  ylabel('rate')
  
  subplot(212)
  a1 = round(n/2);
  plot(t,[y(:,a1)/max(y(:,a1)) y(:,a1+2)/max(y(:,a1+2)) y(:,a1+4)/max(y(:,a1+4)) ])
  hold on
  plot(t,[yy/max(yy)],'--')
  xlabel('time [sec]')
  ylabel('rate')
  xlim([4 6])
end

