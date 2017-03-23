function Out = MakeQualFiles2(SmallRes, SmallClu, SmallCluNo, AllFet, Par1)

nFet = Par1.nSelectedChannels * Par1.nPCs;
BurstTimeWin = 6e3/Par1.SampleTime; % 120 ms

MySpikes = find(SmallClu == SmallCluNo);
[Out.eDist, Out.bRat] = ClusterQuality(AllFet(:,1:nFet), MySpikes, SmallRes, BurstTimeWin);

Out.fRate = (1e6/Par1.SampleTime) * length(MySpikes) / (SmallRes(end)-SmallRes(1)); %firing rate in Hz