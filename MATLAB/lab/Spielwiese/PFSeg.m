function [deg,pfhist1,pfhist2,freq,p] = PFSeg(FileBase,Rat,t,L,dx,Dir,T1,T2)
%%
%% PFSeg('km01.028-032',Rat,min(t),length(intpos),1,1)
%%
%% plots histogramm of place-activity vor nSeg segments. 
%%
%% FileBase = 'km01.028-032';
%% dir=1 % distinguish between the directions; 
%% dir=0 % don't care about directions
%% Rat = [time, position, direction]
%% t: minimum time of the interpolated trace 
%% L=length(intpos) length of interpolated trace
%% Seg = 0 : whole data
%% Seg = 1 : data is devided into 6 segments

%% choose time intervall
%T1=0;
%T2=max(Rat(:,1))/TSegs;

p = [];
freq = [];

%% get spikes etc. of ALL shanks 
[spiket, spikeind, numclus, spikeph, ClustByEl] = ReadEl4CCG(FileBase,[2:5]);

for i=1:max(spikeind)
  clear NRes NNRes Aspike Bspike
  
  %i=3;

  Res = spiket(find(spikeind==i));
  NRes = round(Res/512)-t;
  NNRes = NRes(find(NRes>0 & NRes<L & NRes/39.065>T1 & NRes/39.065<T2));
  
  Aspike(:,1) = Rat(NNRes,1);
  Aspike(:,2) = Rat(NNRes,2);
  Aspike(:,3) = Rat(NNRes,3);
  
  x=[0:dx:360];
  h(:,3) = x';

  if Dir
    dir1 = find(Aspike(:,3)>0);
    dir2 = find(Aspike(:,3)<0);
    h1(:,1) = hist(Aspike(dir1,2)*180/pi,x)';
    h1(:,2) = hist(Rat(find(Rat(:,3)>0),2)*180/pi,x)';
    
    h2(:,1) = hist(Aspike(dir2,2)*180/pi,x)';
    h2(:,2) = hist(Rat(find(Rat(:,3)<0),2)*180/pi,x)';
    
    pfhist1(:,i) =  h1(:,1)./h1(:,2);
    pfhist2(:,i) =  h2(:,1)./h2(:,2);
    
    freq(i,1) = length(dir1)/(max(Aspike(:,1))-min(Aspike(:,1)))%; 
    freq(i,2) = length(dir2)/(max(Aspike(:,1))-min(Aspike(:,1)))%; 
    
    %p(i) = ranksum(Aspike(dir1,2),Aspike(dir2,2));
    
  else
    h1(:,1) = hist(Aspike(:,2)*180/pi,x)';
    h1(:,2) = hist(Rat(:,2)*180/pi,x)';
    
    pfhist1(:,i) =  h1(:,1)./h1(:,2);   
    pfhist2(:,i) =  h1(:,1)./h1(:,2);
    
  end
  deg= h(:,3);
  
  
  %%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%
  
  if 0
    cfigure(1);
    subplot(6,6,i)
    f1=bar(deg,pfhist1(:,i), 'r');
    set(f1,'facealpha',0.3,'edgealpha',0.5);
    set(gca,'XTick',[0:90:360]);
    if Dir
      hold on;
      f2=bar(deg,pfhist2(:,i),'b');
      set(f2,'facealpha',0.3,'edgealpha',0.5);
      set(gca,'XTick',[0:90:360]);
    end
    xlim([0 360]);
    grid on;
  end
  
  %%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%
   
end

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

j=1;
for i=1:nSeg
  T1 =0;
  T2 =T1+max(Rat(:,3))/nSeg;
  [deg,pfhist1,pfhist2] = PFSeg(FileBase,Rat,min(t),length(intpos),1,1,T1,T2);   
  
  if mod(i,6)==0 
    j=j+1;
  end
  cfigure(i+j);
  subplot(6,6,mod(i,6)+1)
  f1=bar(deg,pfhist1(:,i), 'r');
  set(f1,'facealpha',0.3,'edgealpha',0.5);
  set(gca,'XTick',[0:90:360]);
  if Dir
    hold on;
    f2=bar(deg,pfhist2(:,i),'b');
    set(f2,'facealpha',0.3,'edgealpha',0.5);
    set(gca,'XTick',[0:90:360]);
  end
  xlim([0 360]);
  grid on;
end




  %Bspike(:,1) = Aspike(find(Aspike(:,1)>T1 & Aspike(:,1)<T2),1);
  %Bspike(:,2) = Aspike(find(Aspike(:,1)>T1 & Aspike(:,1)<T2),2);
  %Bspike(:,3) = Aspike(find(Aspike(:,1)>T1 & Aspike(:,1)<T2),3);

  
  if 1
    if i<=6
      figure(2)
      subplot(6,1,i)
      plot(Nwhl(:,3)/39.065,Apos*180/pi,':',NRes(:,3)/20000,Aspike*180/pi,'o')
      set(gca,'Ytick',[0:90:360])
      grid on;
    elseif i>6 & i<=12
      figure(3)
      subplot(6,1,i-6)
      plot(Nwhl(:,3)/39.065,Apos*180/pi,':',NRes(:,3)/20000,Aspike*180/pi,'o')
      set(gca,'Ytick',[0:90:360])
      grid on;
    elseif i>12 & i<=18
      figure(4)
      subplot(6,1,i-12)
      plot(Nwhl(:,3)/39.065,Apos*180/pi,':',NRes(:,3)/20000,Aspike*180/pi,'o')
      set(gca,'Ytick',[0:90:360])
      grid on;
    elseif i>18 & i<=24
      figure(5)
      subplot(6,1,i-18)
      plot(Nwhl(:,3)/39.065,Apos*180/pi,':',NRes(:,3)/20000,Aspike*180/pi,'o')
      set(gca,'Ytick',[0:90:360])
      grid on;
    elseif i>24 & i<=30
      figure(6)
      subplot(6,1,i-24)
      plot(Nwhl(:,3)/39.065,Apos*180/pi,':',NRes(:,3)/20000,Aspike*180/pi,'o')
      set(gca,'Ytick',[0:90:360])
      grid on;
    elseif i>30
      figure(7)
      subplot(6,1,i-30)
      plot(Nwhl(:,3)/39.065,Apos*180/pi,':',NRes(:,3)/20000,Aspike*180/pi,'o')
      set(gca,'Ytick',[0:90:360])
      grid on;
    end  
  end
  %%%%%%%%%%%%%%%
  
%figure(3)
%bar(h(:,3),h(:,2))
%set(gca,'XTick',[0:90:360])
%grid on;
%xlim([0 360])



return


%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%



BApos = atan(Nwhl(:,2)./Nwhl(:,1));
%BApos(find(Nwhl(:,1)<0 & Nwhl(:,2)>0)) = Apos(find(Nwhl(:,1)<0 & Nwhl(:,2)>0))-pi;
%BApos(find(Nwhl(:,1)<0 & Nwhl(:,2)<0)) = Apos(find(Nwhl(:,1)<0 & Nwhl(:,2)<0))+pi;
subplot(2,1,1)
plot(Nwhl(:,3)/39.065,BApos,'.')
%xlim([300 600])
subplot(2,1,2)
plot(Nwhl(:,3)/39.065,Nwhl(:,2),Nwhl(:,3)/39.065,Nwhl(:,1))
%xlim([300 600])

%plot(Nwhl(:,3)/39.065,BApos,'.')

%%%%%%%%%%%%%%


%% instantaneous firing rate
DRes = diff(NRes(:,3)); 

plot(Aspile(2:end),DRes,'bo')


%phi = atan((whl3(:,2)-my)./(whl3(:,1)-mx));

%for i=1:max(spikeind)
Res = spiket(find(spikeind==i));
[PlaceMap, OccupancyMap] = myPlaceField(Res, Whl, 350, 20, 100);
TimeThresh=1;
Gamma = 1;
FireRate = PlaceMap;
sTimeSpent=OccupancyMap;
TopRate = max(FireRate(find(sTimeSpent>TimeThresh)));
    if TopRate<1 , TopRate=1; end;
    if isempty(TopRate), TopRate=1; end;
Hsv(:,:,1) = (2/3) - (2/3)*clip(FireRate'/TopRate,0,1).^Gamma;
Hsv(:,:,2) = ones(size(FireRate'));
Hsv(:,:,3) = 1./(1+TimeThresh./sTimeSpent');
%subplot(6,6,i)
image(hsv2rgb(Hsv));
set(gca, 'ydir', 'normal')
%end


for i=1:35
subplot(6,6,i)
%c0=bar(h(:,3),hspike(:,i),'b');
%set(c0,'facealpha',0.5,'edgealpha',0.5); 
%hold;
c1=bar(h(:,3),hspike1(:,i),'b');
set(c1,'facealpha',0.3,'edgealpha',0.5); 
hold
c2=bar(h(:,3),hspike2(:,i),'r');
set(c2,'facealpha',0.3,'edgealpha',0.5); 
xlim([0 360])
end

for i = 1:nSeg
  subplot(6,6,i)
  plot(h(:,1),h(:,2))
  image(hsv2rgb(Hsv));
  set(gca, 'ydir', 'normal');
end

for i=1:35
subplot(6,6,i)
bar(h(:,3),hspike2(:,i),'b');
xlim([0 360])
end

i=0;
[H1,deg]=Circ2LinPF(i*500,(i+1)*500);
i=i+1;
[H2,deg]=Circ2LinPF(i*500,(i+1)*500);
i=i+1;
[H3,deg]=Circ2LinPF(i*500,(i+1)*500);
i=i+1;
[H4,deg]=Circ2LinPF(i*500,(i+1)*500);
i=i+1;
[H5,deg]=Circ2LinPF(i*500,(i+1)*500);
i=i+1;
[H6,deg]=Circ2LinPF(i*500,(i+1)*500);

for j=1:6;
  figure(j)
  for i=1:6;
    if i+6*(j-1)<=35
      subplot(6,6,i)
      bar(deg,H1(:,i+6*(j-1)),'b');
      set(gca,'XTick',[0:90:360])
      grid on;
      xlim([0 360])
      
      subplot(6,6,i+6)
      bar(deg,H2(:,i+6*(j-1)),'b');
      set(gca,'XTick',[0:90:360])
      grid on;
      xlim([0 360])
      
      subplot(6,6,i+12)
      bar(deg,H3(:,i+6*(j-1)),'b');
      set(gca,'XTick',[0:90:360])
      grid on;
      xlim([0 360])
      
      subplot(6,6,i+18)
      bar(deg,H4(:,i+6*(j-1)),'b');
      set(gca,'XTick',[0:90:360])
      grid on;
      xlim([0 360])
      
      subplot(6,6,i+24)
      bar(deg,H5(:,i+6*(j-1)),'b');
      set(gca,'XTick',[0:90:360])
      grid on;
      xlim([0 360])
      
      subplot(6,6,i+30)
      bar(deg,H6(:,i+6*(j-1)),'b');
      set(gca,'XTick',[0:90:360])
      grid on;
      xlim([0 360])
    end
  end
end
