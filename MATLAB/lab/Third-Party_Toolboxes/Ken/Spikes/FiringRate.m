function Rate = FiringRate(Res, Clu, varargin)
% calculates firing rate from a given res and clu file
% output is given in Hz
% function Rate = FiringRate(Res, Clu, WhichClusters, SampleRate)

MinISI = 5;%min ISI sec

[WhichClusters, SampleRate] = DefaultArgs(varargin,{[],20000});
if isstr(Res) & isstr(Clu)
    Res = load(Res);
    Clu = LoadClu(Clu);
end
if isempty(WhichClusters)
    WhichClusters = unique(Clu);
end

for i=1:length(WhichClusters)
    myClu = find(Clu==WhichClusters(i));
    myRes = Res(myClu);
    myISI = diff(myRes);
    goodISI = find(myISI<MinISI*SampleRate);
    
    Rate(i) = SampleRate / mean(myISI(goodISI)); 
end
