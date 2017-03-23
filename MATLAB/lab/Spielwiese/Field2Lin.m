%function linx = Field2Lin(whl,trials,spikes)

XX = whl.ctr(:,1);
YY = whl.ctr(:,2);

trials = PlaceCell(neu).trials;

X = XX(find(WithinRanges([1:length(XX)],trials)));
Y = YY(find(WithinRanges([1:length(XX)],trials)));

%% whl data
%% trial: [beginning end] of trial episods of whl
%% spikes: xy position of spikes

%% center coordinates
CX  =  X - median(X);
CY  =  Y - median(Y);


%% linear fit
LFit = robustfit(CX,CY,[],[],'off')

Norm = sqrt(1+(LFit(1))^2); 

%% rotate 
RX = (CX + CY*LFit(1))/Norm;  
RY = (-CX*LFit(1) + CY)/Norm;  

%% poly fit
Order = 2;
PFit = polyfit(RX,RY,Order);
Poly = RX*0;
for n=1:Order+1
  Poly = Poly + PFit(n)*RX.^(Order+1-n);
end




figure;
plot(CX,CY,'.')
hold on
plot(CX,CX*LFit(1),'r')
plot(CX,CX*LFit(1),'r')

figure;
plot(RX,RY,'.')
hold on
plot(RX,Poly,'.r')

