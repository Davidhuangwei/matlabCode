function StimTrigSegsBat(fileBaseCell,eegNChan,trigChan)
%function StimTrigSegsBat(fileBaseCell,eegNChan,trigChan)
for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j};
    fprintf('File: %s\n',fileBase);
    stimTimes = load([fileBase '/StimTimes.mat']);
    stimNames = fieldnames(stimTimes);
    for k=1:length(stimNames)
        fprintf('%s\n',stimNames{k})
        StimTrigSegs(fileBase,stimTimes.(stimNames{k}).begin,stimTimes.(stimNames{k}).end,...
            stimTimes.(stimNames{k}).interval,eegNChan,trigChan,stimNames{k});
    end
end