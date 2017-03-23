function KenjiBurstPks(FileBase,varargin);
[fMode ] = DefaultArgs(varargin,{'compute'});
load([FileBase '.info.mat']);

switch fMode
    case 'compute'
        nShanks = max(Info.Map(:,3));
        RUN = load([FileBase '.sts.RUN']);

        [Res,Clu,Map]=LoadCluRes(FileBase,[1:nShanks]);
        Res = round(Res/16);
        [Res Ind]= SelectPeriods(Res,RUN,'d',1,1);
        Clu=Clu(Ind);
        
        Res(Res==0) =1;
        
        [uClu dummy newClu] = unique(Clu);
        nClu = max(Clu);

        Sigma = 30; WinLen=200;        
        NewRes=[]; NewClu=[];
        for i1=1:nClu
            Res1 = Res(Clu==i1);
            if isempty(Res1) continue; end
            Burst1 = SmoothFiringPeaks(Res1,WinLen,Sigma,1.25*125);
            Clu1 = ones(length(Burst1),1)*i1;
            
            NewRes = [NewRes; Burst1];
            NewClu = [NewClu; Clu1];
        end
        save([FileBase '.bpks.mat'],'NewRes','NewClu');
        
    case 'check'
        load([FileBase '.bpks.mat']);
        if exist('NewRes','var') & length(NewRes)==length(NewClu) fprintf('ok\n'); 
        else
            system(sprintf('echo %s >> ../redolst9',FileBase));
        end
        return
            
     case 'fixpks'
        load([FileBase '.bpks.mat']);
        if length(NewRes)==length(NewClu) return; end
        uClu = unique(NewClu);
        NewCluEnd = LocalMinima(diff(NewRes),2,-1);
        NewCluBeg = [1; NewCluEnd+1];
        nNewClu = length(NewCluBeg);
        if length(uClu)~=nNewClu
            error('something is wrong');
        end
        NewNewClu = zeros(length(NewRes),1);
        NewNewClu(NewCluBeg) = 1;
        NewNewClu = cumsum(NewNewClu);
        NewClu=NewNewClu;
        save([FileBase '.bpks.mat'],'NewClu','NewRes');
               
end