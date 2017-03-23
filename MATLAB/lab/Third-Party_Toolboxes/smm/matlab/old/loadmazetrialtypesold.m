function whldat = loadmazetrialtypes(filebase,trialtypesbool,mazelocationsbool)

if ~exist('trialtypesbool')
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                   % cr ir cr il crp irp crp ilp crb irb crb ilb xp
end
if ~exist('mazelocationsbool')
    mazelocationsbool = [0  0  0  1  1  1   1   1   1];
                      % rp lp dp cp ca rca lca ira cra
end
% [1 0 1 0 0 0 0 0 0 0 0 0 0]
% [0 0 0 1 1 1 1 1 1]


numtrials = 0; % for counting trials
nxp = 0;
ncr = 0;
nir = 0;
ncr = 0;
nil = 0;
ncrp = 0;
nirp = 0;
ncrp = 0;
nilp = 0;
ncrb = 0;
nirb = 0;
ncrb = 0;
nilb = 0;

fprintf('\nFile: %s,\n',filebase);
whldat = load([filebase '.whl']);
[whlm n]=size(whldat);
included = zeros(whlm,1);
if exist([filebase '_whl_indexes.mat'],'file'),
    fprintf('Including: ');
    load([filebase '_whl_indexes.mat']);
    if trialtypesbool(1), 
        included(correctright & whldat(:,1)~=-1)=1;
        numtrials = numtrials + cr;
        ncr = ncr + cr;
        fprintf('cr n=%i, ', ncr);
    end
    if trialtypesbool(2), 
        included(incorrectright & whldat(:,1)~=-1)=1;
        numtrials = numtrials + ir;
        nir = nir + ir;
        fprintf('ir n=%i, ', nir);
    end
    if trialtypesbool(3), 
        included(correctleft & whldat(:,1)~=-1)=1;
        numtrials = numtrials + cr;
        ncr = ncr + cr;
        fprintf('cr n=%i, ', ncr);
    end
    if trialtypesbool(4), 
        included(incorrectleft & whldat(:,1)~=-1)=1;
        numtrials = numtrials + il;
        nil = nil + il;
        fprintf('il n=%i, ', nil);
    end
    if trialtypesbool(5), 
        included(pondercorrectright & whldat(:,1)~=-1)=1;
        numtrials = numtrials + crp;
        ncrp = ncrp + crp;
        fprintf('crp n=%i, ', ncrp);
    end
    if trialtypesbool(6), 
        included(ponderincorrectright & whldat(:,1)~=-1)=1;
        numtrials = numtrials + irp;
        nirp = nirp + irp;
        fprintf('irp n=%i, ', nirp);
    end
    if trialtypesbool(7), 
        included(pondercorrectleft & whldat(:,1)~=-1)=1;
        numtrials = numtrials + crp;
        ncrp = ncrp + crp;
        fprintf('crp n=%i, ', ncrp);
    end
    if trialtypesbool(8), 
        included(ponderincorrectleft & whldat(:,1)~=-1)=1;
        numtrials = numtrials + ilp;
        nilp = nilp + ilp;
        fprintf('ilp n=%i, ', nilp);
    end
    if trialtypesbool(9), 
        included(badcorrectright & whldat(:,1)~=-1)=1;
        numtrials = numtrials + crb;
        ncrb = ncrb + crb;
        fprintf('crb n=%i, ', ncrb);
    end
    if trialtypesbool(10), 
        included(badincorrectright & whldat(:,1)~=-1)=1;
        numtrials = numtrials + irb;
        nirb = nirb + irb;
        fprintf('irb n=%i, ', nirb);
    end
    if trialtypesbool(11), 
        included(badcorrectleft & whldat(:,1)~=-1)=1;
        numtrials = numtrials + crb;
        ncrb = ncrb + crb;
        fprintf('crb n=%i, ', ncrb);
    end
    if trialtypesbool(12), 
        included(badincorrectleft & whldat(:,1)~=-1)=1;
        numtrials = numtrials + ilb;
        nilb = nilb + ilb;
        fprintf('ilb n=%i, ', nilb);
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
            fprintf(' ira,');
        end
    end
    if mazelocationsbool(9)==0,
        if exist('Lreturnarm','var'),
            whldat(find(Lreturnarm),:) = -1;
            fprintf(' cra,');
        end
    end
    fprintf('\n');
else
    fprintf('All trial types included\n');
end
return

