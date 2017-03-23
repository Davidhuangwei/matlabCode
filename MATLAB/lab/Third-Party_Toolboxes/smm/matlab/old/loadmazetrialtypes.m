function whldat = loadmazetrialtypes(filebase,trialtypesbool,mazelocationsbool)

if ~exist('trialtypesbool')
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                   % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
end
if ~exist('mazelocationsbool')
    mazelocationsbool = [0  0  0  1  1  1   1   1   1];
                      % rp lp dp cp ca rca lca rra lra
end
% [1 0 1 0 0 0 0 0 0 0 0 0 0]
% [0 0 0 1 1 1 1 1 1]


numtrials = 0; % for counting trials
nxp = 0;
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

fprintf('\nFile: %s,\n',filebase);
whldat = load([filebase '.whl']);
[whlm n]=size(whldat);
included = zeros(whlm,1);
if exist([filebase '_whl_indexes.mat'],'file'),
    fprintf('Including: ');
    load([filebase '_whl_indexes.mat']);
    if trialtypesbool(1), 
        included(LeftRight & whldat(:,1)~=-1)=1;
        numtrials = numtrials + lr;
        nlr = nlr + lr;
        fprintf('lr n=%i, ', nlr);
    end
    if trialtypesbool(2), 
        included(RightRight & whldat(:,1)~=-1)=1;
        numtrials = numtrials + rr;
        nrr = nrr + rr;
        fprintf('rr n=%i, ', nrr);
    end
    if trialtypesbool(3), 
        included(RightLeft & whldat(:,1)~=-1)=1;
        numtrials = numtrials + rl;
        nrl = nrl + rl;
        fprintf('rl n=%i, ', nrl);
    end
    if trialtypesbool(4), 
        included(LeftLeft & whldat(:,1)~=-1)=1;
        numtrials = numtrials + ll;
        nll = nll + ll;
        fprintf('ll n=%i, ', nll);
    end
    if trialtypesbool(5), 
        included(ponderLeftRight & whldat(:,1)~=-1)=1;
        numtrials = numtrials + lrp;
        nlrp = nlrp + lrp;
        fprintf('lrp n=%i, ', nlrp);
    end
    if trialtypesbool(6), 
        included(ponderRightRight & whldat(:,1)~=-1)=1;
        numtrials = numtrials + rrp;
        nrrp = nrrp + rrp;
        fprintf('rrp n=%i, ', nrrp);
    end
    if trialtypesbool(7), 
        included(ponderRightLeft & whldat(:,1)~=-1)=1;
        numtrials = numtrials + rlp;
        nrlp = nrlp + rlp;
        fprintf('rlp n=%i, ', nrlp);
    end
    if trialtypesbool(8), 
        included(ponderLeftLeft & whldat(:,1)~=-1)=1;
        numtrials = numtrials + llp;
        nllp = nllp + llp;
        fprintf('llp n=%i, ', nllp);
    end
    if trialtypesbool(9), 
        included(badLeftRight & whldat(:,1)~=-1)=1;
        numtrials = numtrials + lrb;
        nlrb = nlrb + lrb;
        fprintf('lrb n=%i, ', nlrb);
    end
    if trialtypesbool(10), 
        included(badRightRight & whldat(:,1)~=-1)=1;
        numtrials = numtrials + rrb;
        nrrb = nrrb + rrb;
        fprintf('rrb n=%i, ', nrrb);
    end
    if trialtypesbool(11), 
        included(badRightLeft & whldat(:,1)~=-1)=1;
        numtrials = numtrials + rlb;
        nrlb = nrlb + rlb;
        fprintf('rlb n=%i, ', nrlb);
    end
    if trialtypesbool(12), 
        included(badLeftLeft & whldat(:,1)~=-1)=1;
        numtrials = numtrials + llb;
        nllb = nllb + llb;
        fprintf('llb n=%i, ', nllb);
    end
    if trialtypesbool(13), 
        included(exploration & whldat(:,1)~=-1)=1;
        numtrials = numtrials + xp;
        nxp = nxp + xp;
        fprintf('xp n=%i, ', nxp);
    end
    fprintf('total n=%i ', numtrials);
    fprintf('\nRemoved:')
            
    whldat(find(~included),:) = -1;
    
    if mazelocationsbool(1)==0,
        if exist('Rwaterport','var'),
            whldat(find(Rwaterport),:) = -1;
            fprintf(' rp,');
        end
    end
    if mazelocationsbool(2)==0,
        if exist('Lwaterport','var'),
            whldat(find(Lwaterport),:) = -1;
            fprintf(' lp,');
        end
    end
   
    if mazelocationsbool(3)==0,
        if exist('delayarea','var'),
            whldat(find(delayarea),:) = -1;
            fprintf(' da,');
        end
    end
    if mazelocationsbool(4)==0,
        if exist('choicepoint','var'),
            whldat(find(choicepoint),:) = -1;
            fprintf(' cp,');
        end
    end
    if mazelocationsbool(5)==0,
        if exist('centerarm','var'),
            whldat(find(centerarm),:) = -1;
            fprintf(' ca,');
        end
    end
    if mazelocationsbool(6)==0,
        if exist('Rchoicearm','var'),
            whldat(find(Rchoicearm),:) = -1;
            fprintf(' rca,');
        end
    end
    if mazelocationsbool(7)==0,
        if exist('Lchoicearm','var'),
            whldat(find(Lchoicearm),:) = -1;
            fprintf(' lca,');
        end
    end
    if mazelocationsbool(8)==0,
        if exist('Rreturnarm','var'),
            whldat(find(Rreturnarm),:) = -1;
            fprintf(' rra,');
        end
    end
    if mazelocationsbool(9)==0,
        if exist('Lreturnarm','var'),
            whldat(find(Lreturnarm),:) = -1;
            fprintf(' lra,');
        end
    end
    fprintf('\n');
else
    fprintf('All trial types included\n');
end
return

