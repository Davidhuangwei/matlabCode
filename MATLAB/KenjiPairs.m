function out =KenjiPairs(FileBase,varargin);
[fMode ] = DefaultArgs(varargin,{'compute'});

%FileBase = 'ec013.793_814';
%FileBase = 'ec012ec.181-195';
%Par = LoadPar([FileBase '.xml']);
load([FileBase '.info.mat']);

switch fMode
    case 'compute'
        nShanks = max(Info.Map(:,3));
        RUN = load([FileBase '.sts.RUN']);

        %Info.Map , last column - region index (1- EC, 2- CA1, 3-DG/CA3), column 19
        %- which field in the region (1,2,3 - L2,3,5, 1-CA3, 2- DG; columnt 41 -
        %isPyrCell
        ec3=find(Info.Map(:,end)==1&Info.Map(:,19)==2);
        ca1=find(Info.Map(:,end)==2);


        ec2p=find(Info.Map(:,end)==1&Info.Map(:,19)==1&Info.Map(:,41)==1);
        ec3p=find(Info.Map(:,end)==1&Info.Map(:,19)==2&Info.Map(:,41)==1);
        ec5p=find(Info.Map(:,end)==1&Info.Map(:,19)==4&Info.Map(:,41)==1);
        ca1p=find(Info.Map(:,end)==2&Info.Map(:,41)==1);


        [Res,Clu,Map]=LoadCluRes(FileBase,[1:nShanks]);
        Res = round(Res/16);
        [Res Ind]= SelectPeriods(Res,RUN,'d',1,1);
        Clu=Clu(Ind);

        [uClu dummy newClu] = unique(Clu);
        nClu = max(Clu);

        [out.ccg, out.tbin] = CCG(Res, Clu, 1.25*20,100, 1250, [1:nClu], 'count');

        load([FileBase '.thpar.mat'],'ThPh','ThFr');
        ThPh = SelectPeriods(ThPh,RUN,'c',1);
        ThFr = SelectPeriods(ThFr,RUN,'c',1);

        uThPh = unwrap(ThPh);
        SpkPh = ThPh(Res);
        uSpkPh = uThPh(Res);

        nT = length(ThPh);
        %now let's divide into segments
        BinSize = round(250*1.25);
end