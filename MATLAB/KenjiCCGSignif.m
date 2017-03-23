function out =KenjiCCG(FileBase,varargin);
[fMode ] = DefaultArgs(varargin,{'compute'});

%FileBase = 'ec013.793_814';
%FileBase = 'ec012ec.181-195';
%Par = LoadPar([FileBase '.xml']);
load([FileBase '.info.mat']);

switch fMode
    case 'compute'
        nShanks = max(Info.Map(:,3));
        RUN = load([FileBase '.sts.RUN']);

        %Info.Map , last column - region index (1- EC, 2- CA1, 3-DG/CA3), 
        % column 19- which field in the region (1,2,3 - L2,3,5, 1-CA3, 2- DG; column 41 -
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

        %now let's divide into segments of 5 msec
        BinSizeMs = 5;
        BinSize = round(BinSizeMs*1.25);

        BinIndex = round(Res/BinSize)+1;
        nBins = max(BinIndex);
        BinT = [0:nBins-1]'*BinSize+round(BinSize/2); % time of the bin in samples
cnt=1;
        Sigma = 30; WinLen=200;        
        for i1=ec3p'%1:nClu
            Res1 = Res(Clu==i1);
            
       %     Res1  = Res(ismember(Clu,ec3p));
            %Rate1 = accumarray(BinIndex(Clu==i1),1, [nBins 1],@sum)/BinSizeMs*1000; 
%             Rate1 = Filter0(kern,Rate1);
%           [Burst1 BurstLen1] = SplitIntoBursts(Res1, 1.25*200);
%           Burst1 = Res1(Burst1);

            Burst1 = SmoothFiringPeaks(Res1,WinLen,Sigma,1.25*100);
    %    keyboard        
            for i2 =ca1p'% i1+1:nClu
                 Res2 = Res(Clu==i2);
                 Burst2 = SmoothFiringPeaks(Res2,WinLen,Sigma,1.25*100);
                 %now do signif calculation
                T = [Burst1; Burst2];  G=[ones(length(Burst1),1); 2*ones(length(Burst2),1)];
                
                [sccg_raw tbin] =  CCG(T, G, 1.25*10,35, 1250, [1 2], 'count');
                myccg = sq(sccg_raw(:,1,2)); 
                if sum(myccg)<2000 continue; end
                winlen = round(1.25*30); if ~mod(winlen,2) winlen =winlen+1; end
                win = ones(winlen,1);  win((winlen-1)/2+1)=0.42;
                winhlf = (winlen-1)/2;
                win =win/sum(win);

                sccg_conv = Filter0(win,[flipud(myccg(2:1+winhlf));myccg; flipud(myccg(end-winhlf:end-1))]);
                sccg_conv = sccg_conv(1+winhlf:end-winhlf);
                p_val = 1-poisscdf(myccg-1,sccg_conv);
                
                out.ccg(:,cnt) = myccg;
                out.sccg(:,cnt) = sccg_conv;
                out.pval(:,cnt) = p_val;
                out.pair(:,cnt) = [i1 i2]; 
                cnt=cnt+1;
              %  keyboard
            end
        end
        out.tbin = tbin;
        out.winlen = winlen;
        
end        
keyboard
%          load([FileBase '.thpar.mat'],'ThPh');
%          ThPh = SelectPeriods(ThPh,RUN,'c',1);

% 
%         uThPh = unwrap(ThPh);
% %        SpkPh = ThPh(Res);
%         uSpkPh = uThPh(Res);
% %        PhMod = mod(uSpkPh+pi,2*pi)-pi;
%         CycNo = round((uSpkPh-rem(uSpkPh,2*pi))/2/pi+1);
%         CycRange = [min(CycNo) max(CycNo)];
%         ccg=[];
%         for CycStep=1:10
%             SelInd = find(~mod(CycNo,CycStep));
%             [ccg(:,:,:,CycStep) tbin] =  CCG(Res(SelInd), Clu(SelInd), 1.25*10,15, 1250, myp, 'count');
%         end
%         nccg = ccg./repmat([10:1],[1,size(ccg,1), size(ccg,2),size(ccg,3)]);
%         
%         for k=1:17
%             subplotfit(k,17)
%             imagesc(tbin,[1:10],unity(sq(ccg(:,2,k,:)))');
%         end
% 
%         
% keyboard
% %        nT = length(ThPh);
%        %[out.ccg, out.tbin] = CCG(Res, Clu, 1.25*20,100, 1250, [1:nClu], 'count');
% 
%         
%         
%         %cells to analysis:
%        % myClu = [ec3p(1:5)'; ca1p(1:5)'];
%       
%         Rate = accumarray([BinIndex Clu],1, [nBins nClu],@sum)/0.25; % in Hz
%       %  Phase = angle(accumarray([BinIndex Clu], exp(sqrt(-1)*SpkPh), [nBins nClu],@mean)); %in radians
%         CycStep=2;
%         SelInd = ~mod(CycNo,CycStep);
%         cnt=1;
%         for i1=ec3p'
%             for i2=ca1p'
%                 %gi =Rate(:,i1)>0 & Rate(:,i2)>0;
%                 %if sum(out.ccg(:,i1,i2))<2000 continue; end %if there is not much overlap
% 
% %                 Res1 = Res(SelInd&Clu==i1);
% %                 Res2 = Res(SelInd&Clu==i2);
%                 
%                 % now dilute the trains, replace spikes within one cycle by
%                 % the mean time of all spikes
% %                 mRes1 = round(accumarray(CycNo(SelInd&Clu==i1),Res1,[max(CycNo) 1],@mean));
% %                 mRes1 = mRes1(mRes1~=0);
% %                 
% %                 mRes2 = round(accumarray(CycNo(SelInd&Clu==i2),Res2,[max(CycNo) 1],@mean));
% %                 mRes2 = mRes2(mRes2~=0);
%                                 
% %                bRes1 = 
% %                T = [mRes1; mRes2]; G=[ones(length(mRes1),1); 2*ones(length(mRes2),1)];
%                 T = [Res(Clu==i1); Res(Clu==i2)];  G=[ones(sum(Clu==i1),1); 2*ones(sum(Clu==i2),1)];
%                 
%                 [sccg_raw tbin] =  CCG(T, G, 1.25*10,35, 1250, [1 2], 'count');
%                 
%                 winlen = round(1.25*30); if ~mod(winlen,2) winlen =winlen+1; end
%                 win = ones(winlen,1);  win((winlen-1)/2+1)=0.42;
%                 winhlf = (winlen-1)/2;
%                 win =win/sum(win);
%                 myccg = sq(sccg_raw(:,1,2)); 
%                 sccg_conv = Filter0(win,[flipud(myccg(2:1+winhlf));myccg; flipud(myccg(end-winhlf:end-1))]);
%                 sccg_conv = sccg_conv(1+winhlf:end-winhlf);
%                 p_val = 1-poisscdf(myccg-1,sccg_conv);
%                 out.sig.ccg(:,cnt) = myccg;
%                 out.sig.sccg(:,cnt) = sccg_conv;
%                 out.sig.pval(:,cnt) = p_val;
%                 out.sig.pair(:,cnt) = [i1 i2]; 
%                 cnt=cnt+1;
% 
%             end
%         end
% end
                 
        %now loop over the pairs
%         cnt=1;
%         for ii=1:nClu
%             if Info.Map(ii,41)==0 | Info.Map(ii,43)>1 continue; end %skip interneuron and nonEC references
%             %if Info.Map(ii,19)~=2 continue; end
%             if ~ismember(Info.Map(ii,19),[1 2 4]) continue; end
%             %fprintf('Reference %d ', ii);
%             for jj=1:nClu
%                 if jj==ii continue; end
%                 if sum(out.ccg(:,ii,jj))<1000 continue; end %if there is not much overlap
%                 %        if Info.Map(jj,43)~=2 continue; end
%                 %fprintf('%d\n',jj);
%                 %gBins12= (gBins(:,ii)&gBins(:,jj));
% 
%                 %now take bins with high/low rates and assign to spikes respective
%                 %"clu" numbers
%                 out.ByRate(cnt).ind = [ii jj];
%                 Res1 = Res(Clu==ii);
%                 Res2 = Res(Clu==jj);
% 
%                 Ph1 = SpkPh(Clu==ii);
%                 Ph2 = SpkPh(Clu==jj);
% 
%                 iRate1 = InstRateAtSpike(Res1, BinSize,1250);
%                 iRate2 = InstRateAtSpike(Res2, BinSize,1250);
% 
%                 Clu1=ones(size(Res1)); %1 - medium
%                 Clu1(iRate1<5)=2;      %;low
%                 Clu1(iRate1>30)=3;       %high
% 
%                 Clu2=ones(size(Res2))*4; %1 - medium
%                 Clu2(iRate2<5)=5;      %;low
%                 Clu2(iRate2>30)=6;       %high
%                 T = [Res1; Res2]; G=[Clu1; Clu2];
% 
%                 %2,3 and 5 6 are low/high of two cells respectively
%                 [out.ByRate(cnt).ccgr tbin ] = CCG(T,G, 1.25*20,100, 1250, [1:6], 'count');
%                 cnt=cnt+1;

