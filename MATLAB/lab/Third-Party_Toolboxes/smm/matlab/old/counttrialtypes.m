function trialsmat = counttrialtypes(filebasemat,outputtoscreen,trialtypesbool)
% returns how many trials of each type there are in the passed filenames.

if ~exist('outputtoscreen', 'var')
    outputtoscreen = 0;
end

nlr = 0;
nrr = 0;
nrl = 0;
nll = 0;
nlrp = 0;
nrrp = 0;
nrlp = 0;
nllp = 0;
nlrb = 0;
nrrb = 0;
nrlb = 0;
nllb = 0;
nxp = 0;
[numfiles n] = size(filebasemat);

for i=1:numfiles
    filebase = filebasemat(i,:);
    if outputtoscreen,
        fprintf('File: %s,\n',filebase);
    end
    whldat = load([filebase '.whl']);
    inname = [filebase '.eeg'];
    if exist([filebase '_whl_indexes.mat'],'file'),
        load([filebase '_whl_indexes.mat']);
        nlr = nlr + lr;
        nrr = nrr + rr;
        nrl = nrl + rl;
        nll = nll + nll;
        nlrp = nlrp + lrp;
        nrrp = nrrp + rrp;
        nrlp = nrlp + rlp;
        nllp = nllp + llp;
        nlrb = nlrb + lrb;
        nrrb = nrrb + rrb;
        nrlb = nrlb + rlb;
        nllb = nrlb + rlb;
        nxp = nxp + xp;
    else
        Icoodnfinothinlikwhachoowant % ...translated: ERROR
    end
end
if outputtoscreen,
    fprintf('Total n=%d\n', nlr + nrr + nrl + nll + nlrp + nrrp + nrlp + nllp + nlrb + nrrb + nrlb + nllb);
    fprintf('lr  %d, rl  %d, rr  %d, ll  %d\n', nlr, nrl, nrr, nll);
    fprintf('lrp %d, rlp %d, rrp %d, llp %d\n', nlrp, nrlp, nrrp, nllp);
    fprintf('lrb %d, rlb %d, rrb %d, llb %d\n', nlrb, nrlb, nrrb, nllb);
    fprintf('xp %d\n',nxp);
end
trialsmat = [nlr, nrr, nrl, nll, nlrp, nrrp, nrlp, nllp, nlrb, nrrb, nrlb, nllb, nxp];
return