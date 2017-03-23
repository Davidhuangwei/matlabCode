%function [ccg,t,pairs] = Trains2CCG(Trains, Groups, BinSize, HalfBins, SampleRate,Normalization, Period, IfIn)
% cancatenates various trains of the same sampling rate and does CCG for all 
% BinSize in milliseconds!!!
% the rest as in CCG , see help CCG

function [ccg, t,pairs] = Trains2CCG(Trains, Groups, BinSize, HalfBins, varargin)

[SampleRate,Normalization, Period, IfIn] = DefaultArgs(varargin, {20000, 'scale', [],0});

if isstr(Period)
    Period = load(Period);
    Period = (SampleRate/2e5)*(Period);
end
goodTrains = find(and(~cellfun('isempty',Trains),~cellfun('isempty',Groups)));
Trains = Trains(goodTrains);
Groups = Groups(goodTrains);
nTrains = length(Trains);
nGroups = length(Groups);
if (nTrains~=nGroups)
    error('number of traisn and number of groups vectors should be the same');
    exit(1);
end

MaxT = [];
for t=1:nTrains
    MaxT(end+1)=max(Trains{t});
    if (size(Trains{t},1)~=1 &  size(Trains{t},2)~=1)
        error(['Train ' num2str(t) ' is not a vector/row ']);
        exit(1)
    end
    Trains{t} = Trains{t}(:);
end
for t=1:nTrains
    if (MaxT(t) < median(MaxT) - SampleRate*10000)
        warning(['Train' num2str(t) ' may be much shorter than others']);
    end
end

%form new group index and keep old one
Index=[];
nPlots=1;
for t=1:nTrains
    if length(Groups{t})<2
        Groups{t} = ones(length(Trains{t}),1)*nPlots;
        Index = [Index ; t];
        nPlots=nPlots+1;
    else
        ThisGroup = unique(Groups{t});
        nThisGroup = length(ThisGroup);
        Index = [Index ; ThisGroup];
        tmpGroup=[];
        for g=1:nThisGroup
            tmpGroup(find(Groups{t}==ThisGroup(g))) = g + nPlots - 1;
        end
        nPlots=nPlots+nThisGroup;
        Groups{t}=tmpGroup(:);
    end
        
end
nPlots=nPlots-1;
Train = []; Group =[];

for t=1:nTrains
    Train = [Train ; Trains{t}];
    Group = [Group ; Groups{t}];
end
[Train Ind ] = SelectPeriods(Train, Period, 'd', IfIn);
Group = Group(Ind);

if (nargout < 1)
    CCG(Train, Group, ceil(BinSize*SampleRate/1000), HalfBins, SampleRate, [1:nPlots], Normalization);
    for i=1:nPlots
        subplot(nPlots,nPlots,i);
        set(gca,'FontSize',8);
        title(num2str(Index(i)));
    end
else
    if nargout<3
    [ccg, t] = CCG(Train, Group, ceil(BinSize*SampleRate/1000), HalfBins, SampleRate, [1:nPlots], Normalization);
    else
    [ccg, t,pairs] = CCG(Train, Group, ceil(BinSize*SampleRate/1000), HalfBins, SampleRate, [1:nPlots], Normalization);
    end
end
	    