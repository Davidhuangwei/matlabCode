% SpwMahal(FetFile, DiffCluFile, ISRFile, FeaturesConsidered)
%

%Fet = LoadFet(FetFile);
%DC = LoadClu(DiffCluFile);
%ISRFile = LoadClu(ISRFile);

NoSpwSpikes = Fet(find(ISR == 2), FeaturesConsidered);

SpwCorrect = find(DC ==4 & ISR == 5);
SpwFalseNeg = find(DC == 2 & ISR == 5);
SpwFalsePos = find(DC == 3 & ISR == 4);

mCorrect = mahal(Fet(SpwCorrect, FeaturesConsidered), NoSpwSpikes);
mFalseNeg = mahal(Fet(SpwFalseNeg, FeaturesConsidered), NoSpwSpikes);
mFalsePos = mahal(Fet(SpwFalsePos, FeaturesConsidered), NoSpwSpikes);

nBins = 200;
mmax = max([mFalseNeg;mFalsePos;mCorrect]);
mmin = min([mFalseNeg;mFalsePos;mCorrect]);
Bins = mmin:(mmax-mmin)/nBins:mmax;

[hFalseNeg, xFalseNeg] = hist(mFalseNeg, Bins);
[hFalsePos, xFalsePos] = hist(mFalsePos, Bins);
[hCorrect, xCorrect] = hist(mCorrect, Bins);

hold on
cla;
stairs(xCorrect, hCorrect/size(mCorrect,1), 'b');
stairs(xFalseNeg, hFalseNeg/size(mFalseNeg,1), 'g');
stairs(xFalsePos, hFalsePos/size(mFalsePos,1), 'r');
