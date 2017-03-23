function trialsMat = CountTrialTypes(fileBaseCell,outputToScreen)
% function trialsMat = CountTrialTypes(fileBaseCell,outputToScreen)
% returns how many trials of each type there are in the passed filenames.

if ~exist('outputToScreen', 'var') | isempty(outputToScreen)
    outputToScreen = 0;
end

nLR = 0;
nRR = 0;
nRL = 0;
nLL = 0;
nLRP = 0;
nRRP = 0;
nRLP = 0;
nLLP = 0;
nLRB = 0;
nRRB = 0;
nRLB = 0;
nLLB = 0;
nXP = 0;
[numfiles] = length(fileBaseCell);
cwd = pwd;
for i=1:numfiles
    fileBase = fileBaseCell{i};
    cd(fileBase);
    if outputToScreen,
        fprintf('File: %s\n',fileBase);
    end
    %whldat = load([fileBase '.whl']);
    %inname = [fileBase '.eeg'];
    if exist([fileBase '_whl_indexes.mat'],'file'),
        load([fileBase '_whl_indexes.mat']);
        nLR = nLR + LR;
        nRR = nRR + RR;
        nRL = nRL + RL;
        nLL = nLL + LL;
        nLRP = nLRP + LRP;
        nRRP = nRRP + RRP;
        nRLP = nRLP + RLP;
        nLLP = nLLP + LLP;
        nLRB = nLRB + LRB;
        nRRB = nRRB + RRB;
        nRLB = nRLB + RLB;
        nLLB = nLLB + LLB;
        nXP = nXP + XP;
    else
        Icoodnfinothinlikwhachoowant % ...translated: ERROR
    end
    cd(cwd)
end
if outputToScreen,
    fprintf('Total n=%d\n', nLR + nRR + nRL + nLL + nLRP + nRRP + nRLP + nLLP + nLRB + nRRB + nRLB + nLLB);
    fprintf('LR  %d, RL  %d, RR  %d, LL  %d\n', nLR, nRL, nRR, nLL);
    fprintf('LRP %d, RLP %d, RRP %d, LLP %d\n', nLRP, nRLP, nRRP, nLLP);
    fprintf('LRB %d, RLB %d, RRB %d, LLB %d\n', nLRB, nRLB, nRRB, nLLB);
    fprintf('XP %d\n',nXP);
end
trialsMat = [nLR, nRR, nRL, nLL, nLRP, nRRP, nRLP, nLLP, nLRB, nRRB, nRLB, nLLB, nXP];
return