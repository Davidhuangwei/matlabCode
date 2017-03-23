function ChanLocConverter(csdName,chanLocVersion)
%function ChanLocConverter(csdName,chanLocVersion)

eegChanLoc = LoadVar(['ChanInfo/ChanLoc_' chanLocVersion '.eeg.mat']);
eegChanMat = LoadVar('ChanInfo/ChanMat.eeg.mat');

csdChanMat = LoadVar(['ChanInfo/ChanMat' csdName '.mat'])

chanLocFields = fieldnames(eegChanLoc);
for j=1:length(chanLocFields)
    for k=1:length(eegChanLoc.(chanLocFields{j}))
        chanLoc.(chanLocFields{j}){k} = ...
            CalcCsdBadChans(eegChanLoc.(chanLocFields{j}){k},size(eegChanMat,1),size(csdChanMat,1));
    end
end
chanLoc
save(['ChanInfo/ChanLoc_' chanLocVersion csdName '.mat'],SaveAsV6,'chanLoc')
CheckChanLoc02(csdName,chanLocVersion)
 return