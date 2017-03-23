% PointCorrelS(T1, T2, BinSize, HalfBins, isauto, SampleRate, Normalization, RepeatNum,color,type);
%
% Plots a cross-covarioram of 2 series (shuflle corrected, using NumRepeat shufflings)
% The output has 2*HalfBins+1 bins
% T1 will be shuffeled randomly 
% Input time series may be in any units and don't need to be sorted
% BinSize gives the size of a bin in input units
% if isauto is set, the central bin will be zeroed
% SampleRate is for y scaling only, and gives the conversion between input units and Hz
% Normalization indicates the type of y-axis normalization to be used.  
% 'count' indicates that the y axis should show the raw spike count in each bin.
% 'hz' will normalize to give the conditional intensity of cell 2 given that cell 1 fired a spike (default)
% 'hz2' will give the joint intensity, measured in hz^2.
% 'scale' will scale by both firing rates so the asymptotic value is 1
%
% [Out t] = PointCorrel(...) will return 2 arguments: the height of the correlogram
% and the x axis label.

function [histres,histerr,t] = PointCorrelS1(T1, T2, BinSize, HalfBins, isauto, SampleRate, Normalization, RepeatNum,color,type);

[histor, t]=PointCorrelA(T1, T2, BinSize, HalfBins, isauto, SampleRate, Normalization);

if nargin<10 | isempty(type)
    type='l';
end

if nargin<9 | isempty(color)
    color='b';
end
if nargin<8 | isempty(RepeatNum)
    RepeatNum=10;
end
T1size=length(T1);
T2size=length(T2);
%Tbeg=max(min(T1), min(T2));
%Tend=min(max(T1),max(T2));
%T1rand=Tbeg+rand(T1size,RepeatNum)*(Tend-Tbeg);
T1rand=repmat(T1',RepeatNum,1)'+sign(rand(T1size,RepeatNum)-0.5).*((1+rand(T1size,RepeatNum)*5)*SampleRate);
over=find(T1rand>max(T1));
below=find(T1rand<min(T1));
T1rand(over)=T1rand(over)-10*SampleRate;
T1rand(below)=T1rand(below)+10*SampleRate;
T1randind=ones(T1size,1);


ccgrand=[];
for i=1:RepeatNum
    ccg = CCG([T1rand(:,i);T2],[T1randind;2*ones(T2size,1)],BinSize,HalfBins,SampleRate,[1:2],Normalization);
    ccgrand(:,i)=squeeze(ccg(:,1,2));
end

 histshuf=mean(ccgrand,2);
 histerr=std(ccgrand,0,2);
 histres=histor-histshuf;
 histres(1)=histres(2);
 histres(end)=histres(end-1);
 
% figure
% if nargout==0
%     if type=='l'
bar(t,histor,'b');
hold on
plot(t,histshuf,'r');
% else

% end
 