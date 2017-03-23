function out =KenjiCCG(FileBase,varargin);
[fMode ] = DefaultArgs(varargin,{'compute'});
 global gCCGs
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
%         ec3=find(Info.Map(:,end)==1&Info.Map(:,19)==2);
%         ca1=find(Info.Map(:,end)==2);
% 
% 
%         ec2p=find(Info.Map(:,end)==1&Info.Map(:,19)==1&Info.Map(:,41)==1);
%         ec3p=find(Info.Map(:,end)==1&Info.Map(:,19)==2&Info.Map(:,41)==1);
%         ec5p=find(Info.Map(:,end)==1&Info.Map(:,19)==4&Info.Map(:,41)==1);
%         ca1p=find(Info.Map(:,end)==2&Info.Map(:,41)==1);


        [Res,Clu,Map]=LoadCluRes(FileBase,[1:nShanks]);
        Res = round(Res/16);
        [Res Ind]= SelectPeriods(Res,RUN,'d',1,1);
        Clu=Clu(Ind);

        [uClu dummy newClu] = unique(Clu);
        nClu = max(Clu);

        [out.ccg, out.tbin] = CCG(Res, Clu, round(1.25*10),100, 1250, [1:nClu], 'count');
        save([FileBase '.ccg.mat'],'out');

   
    case 'computepks'
        
        load([FileBase '.ccg.mat'],'out');
        load([FileBase '.bpks.mat']);
        nClu = max(NewClu);
        [out.ccgp, out.tbinp] = CCG(NewRes, NewClu, round(1.25*10),30, 1250, [1:nClu], 'count');
        save([FileBase '.ccg.mat'],'out');
        
        
    case 'merge'
        WinLen = round(150*1.25);
        if mod(WinLen,2)==0 WinLen=WinLen+1; end
        UsePks=1;
        
        load([FileBase '.ccg.mat']);
        [List Labels] = KenjiMakePairList(Info);
        PreLab = {'EC2Pyr','EC3Pyr','EC5Pyr'};
        PostLab = {'EC2Pyr','EC3Pyr','EC5Pyr','CA1Pyr','CA3Pyr','DGPyr','EC2Int','EC3Int','EC5Int','CA1Int','CA3Int','DGInt'};
        nPre = length(PreLab);
        nPost = length(PostLab);
        
        if isempty(gCCGs)
            gCCGs= struct();
            for i=1:3
                for j=1:12
                    gCCGs(i,j).ccg=[];
                    gCCGs(i,j).ccgp=[];
                    gCCGs(i,j).pval=[];
                    gCCGs(i,j).file={};
                    gCCGs(i,j).labels={};
                end;end
        end
        for k=1:nPre
            for j=1:nPost
                prei = find(strcmp(Labels,PreLab{k}));
                posti = find(strcmp(Labels,PostLab{j}));
                
                if isempty(prei) | isempty(posti) continue; end
                myccg = reshape(out.ccg(:,prei,posti), size(out.ccg,1), []);
                myccgp = reshape(out.ccgp(:,prei,posti), size(out.ccgp,1), []);
                %now compute p-values using Eran's smoothing approach
                 
                %win = ones(winlen,1);  win((winlen-1)/2+1)=0.42;

                Sigma = (WinLen-1)/2;
                x = [-Sigma*3:Sigma*3];
                win=exp(-x.^2/(2*Sigma^2));
                win(Sigma*3) = 0.4;
                win =win/sum(win);

                ccgp_conv = Filter0(win, myccgp);

                
                % use time within 150 msec
                gt = find(out.tbinp>-150 & out.tbinp<150);
                % accumulate if we have > 2 count per bin 
                ccgpcnt = sum(myccgp(gt,:)>2);
                gi = find(ccgpcnt > length(gt)*0.75);

                mypval = 1-Spoisscdf(myccg(gt,gi)-1,ccgp_conv(gt,gi));
                
                gCCGs(k,j).ccg = cat(2,gCCGs(k,j).ccg, myccg(:,gi));
                gCCGs(k,j).ccgp = cat(2,gCCGs(k,j).ccgp, myccgp(gt,gi));
                gCCGs(k,j).pval = cat(2,gCCGs(k,j).pval, mypval);
                gCCGs(k,j).file = cat(1,gCCGs(k,j).file,repmat({FileBase},length(gi),1));
                gCCGs(k,j).labels = {PreLab{k}, PostLab{j}};
                gCCGs(k,j).tbin = out.tbin;
                gCCGs(k,j).tbinp = out.tbinp(gt);
            end
        end
     % keyboard
end





%
%         load([FileBase '.thpar.mat'],'ThPh','ThFr');
%         ThPh = SelectPeriods(ThPh,RUN,'c',1);
%         ThFr = SelectPeriods(ThFr,RUN,'c',1);
% 
%         uThPh = unwrap(ThPh);
%         SpkPh = ThPh(Res);
%         uSpkPh = uThPh(Res);
% 
%         nT = length(ThPh);
%         %now let's divide into segments
%         BinSize = round(125*1.25);
% 
%         BinIndex = round(Res/BinSize)+1;
%         nBins = max(BinIndex);
%         
%         %cells to analysis:
%         myClu = [ec3p(1:5)'; ca1p(1:5)'];
%         
%         %%%%% NOW DO THE PHASE CCG
% %         BinWidth = 2*pi/3; % 60 degrees on each side
% % 		[phccg phbin] = CCG(uSpkPh, Clu, BinWidth, 0, 1, myClu, 'count');
% %         
% % %         % shuffled CCGs
% %         nRands = 20;
% %         SSpkPh = ShufflePhase(uSpkPh,Clu,myClu,nRands);    
% %         % get pairs only on first one
% %         clear Sccg
% % 		for i=1:nRands
% %             Sccg(:,:,:,i) = CCG(SSpkPh(:,i), Clu, BinWidth, 0, 1, myClu, 'count');
% %         end
% %         ccgMean = mean(Sccg,4);
% %         ccgStd = std(Sccg,0,4);
% %        
%         %now compute for each Bin: FirRate of each spike, CircMean of each spike,
%         %InstTheta Freq
% 
%         Rate = accumarray([BinIndex Clu],1, [nBins nClu],@sum)/0.25; % in Hz
%         Phase = angle(accumarray([BinIndex Clu], exp(sqrt(-1)*SpkPh), [nBins nClu],@mean)); %in radians
%         
%         
%         for i1=ec3p'
%             for i2=ca1p'
%                 gi =Rate(:,i1)>0 & Rate(:,i2)>0;
%                  if sum(out.ccg(:,i1,i2))<5000 & sum(gi)<1000 continue; end %if there is not much overlap
%             mat = Phase(:,[i1 i2]);
%             mat = mat(Rate(:,i1)>0 & Rate(:,i2)>0,:);
%             figure(333111);clf
%             subplot(221);
%             histcirc(mat(:,1),18);
%             title('cell1 ');
%             
%             subplot(222);
%             histcirc(mat(:,2),18);
%             title('cell2 ');
%                  
%             subplot(223);
%             hist2(mat*180/pi,[-180:30:180],[-180:30:180],0,3);
%             set(gca,'XTick',[-180:180:180],'YTick',[-180:180:180]);
%             title('jpdf');
%             
%             %now shuffle
%             for k=1:500
%                 hr(:,:,k) =  hist2([mat(:,1) mat(randsample(size(mat,1),size(mat,1)),2)]*180/pi,[-180:30:180],[-180:30:180],0,3);
%             end
%             [htrue b1 b2]=  hist2([mat(:,1) mat(randsample(size(mat,1),size(mat,1)),2)]*180/pi,[-180:30:180],[-180:30:180],0,3);
%             hdiff = (htrue - mean(hr,3))./std(hr,0,3);
%             subplot(224);
% %            hist2([mat(:,1) mat(randsample(size(mat,1),size(mat,1)),2)]*180/pi,18,18,0,3)
%             imagesc(b1,b2,hdiff');
% 
%             set(gca,'XTick',[-180:180:180],'YTick',[-180:180:180]);
%             
%             title('shiffled');
%             fprintf('cell pair: %d %d\n',i1,i2);
%             waitforbuttonpress
% %            [jpdf.pdfmap, jpdf.bins, jpdf.pdfcorr, jpdf.pdfpeak, jpdf.pdfs] = PdfSmooth(mat(:,1),mat(:,2),20,20);
%             end
%         end
%         keyboard
%         %if nBins*BinSize>nT ThFr = [ThFr; ThFr(end)*ones(nBins*BinSize-nT,1)]; end
%         %ThFreq = mean(reshape(ThFr(1:nBins*BinSize),BinSize,[]))';
% 
%         %gBins = Rate>0;
% 
% 
%         %[Starts, Assignments] = FitEvenlySpacedBins(BinSize,[1 nT],Res);
% 
%         %[Segs, SpkInd, SegInd, SegGrpInd] =
%         %FitOverlapedBins(BinSize,Step,Points,minT,maxT); too complicated for now
% 
%         % i1=20; i2=30;
%         % gBins12= gBins(:,i1)&gBins(:,i2);
%         %
%         % PhaseDiff = mod(Phase(gBins12,i1)-Phase(gBins12,i2),2*pi);
%         % RateGm = sqrt(Rate(gBins12,i1).*Rate(gBins12,i2));
% 
%         
%         %some displays
%         figure(3231111);
%         for ii=ca1p(:)'
%             if max(Rate(:,ii))==0 continue;end
%             clf
%             RateEdge = [1 4 7 10 15 20 25 35 45 60 100];
%             RateBins = (RateEdge(1:end-1)+RateEdge(2:end))/2;
%             PeakInd = abs(Phase(:,ii))<pi/2;
%             HistPeak = histcI(Rate(PeakInd,ii),RateEdge);
%             HistTrough = histcI(Rate(~PeakInd,ii),RateEdge);
%             HistPeak = HistPeak./sum(HistPeak);
%             HistTrough = HistTrough./sum(HistTrough);
%             bar(RateBins, [HistPeak(:) HistTrough(:)]); 
%             legend('peak','trough');
%             title(Info.whichRegion{Info.Map(ii,43)}{Info.Map(ii,19)});
%             pause
%         end
%         % plot phase/rate density
%         for ii=ca1p(:)'
%             gi = Rate(:,ii)>0;
%             try
%                 hist2([[Rate(gi,ii), Phase(gi,ii)]; [Rate(gi,ii), Phase(gi,ii)+2*pi]],20,20,2,5)
%             catch
%             end
%          pause;
%         end
%         
%         %from single spikes
%         figure
%         for ii=ec5p(:)'
%             try
%             iRate = InstRateAtSpike(Res(Clu==ii), BinSize,1250);
%             hist2([[iRate, SpkPh(Clu==ii)]; [iRate, SpkPh(Clu==ii)+2*pi]],20,20,2,[5 5])
%             catch; end
%             pause
%         end
%         %now loop over the pairs
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
% 
%                 if 0
%                     %some plots
%                     figure(323);clf
%                     subplot(221)
%                     hist([Ph1(iRate1<5); Ph1(iRate1<5)+2*pi]*180/pi,36); axis tight; hold on; Lines([0 180],[],'r')
%                     title(Info.whichRegion{Info.Map(ii,43)}{Info.Map(ii,19)});
%                     xlabel('low rate')
% 
%                     subplot(222)
%                     hist([Ph2(iRate2<5); Ph2(iRate2<5)+2*pi]*180/pi,36); axis tight; hold on; Lines([0 180],[],'r')
%                     title(Info.whichRegion{Info.Map(jj,43)}{Info.Map(jj,19)});
% 
%                     subplot(223)
%                     hist([Ph1(iRate1>30); Ph1(iRate1>30)+2*pi]*180/pi,36); axis tight; hold on; Lines([0 180],[],'r')
%                     subplot(224)
%                     hist([Ph2(iRate2>30); Ph2(iRate2>30)+2*pi]*180/pi,36); axis tight; hold on; Lines([0 180],[],'r')
%                     ylabel('high rate')
% 
%                     figure(3232);clf
%                     BarMatrix(tbin,ccgr(:,[2 3 5 6],[2 3 5 6]))
% 
%                     waitforbuttonpress
%                 end
%             end
%         end
% 
%         save([FileBase '.' mfilename '.mat'],'out');
% 
%     case 'display'
%         load([FileBase '.' mfilename '.mat']);
%         figure(4232);clf
%         npairs = length(out.ByRate);
%         for j=1:npairs
%             BarMatrix(out.tbin,out.ByRate(j).ccgr(:,[2 3 5 6],[2 3 5 6]));
%             waitforbuttonpress;
%         end            
% end
% 
% return
%  
% uPh = unwrap(ThPh);
% SpkPh = ThPh(Res);
% uSpkPh = uPh(Res);
% PhMod = mod(uSpkPh,2*pi);
% CycNo = round(uSpkPh-PhMod);
% 
% CycFr = ThFr(Res);
% 
% uCycNo = unique(CycNo);
% nCyc = max(uCycNo);
% 
% 
% RatePerCyc = accumarray([CycNo Clu],1,[nCyc nClu],@sum);
% GoodCyc = find(sum(RatePerCyc,2)>0);
% 
% histRate = hist(RatePerCyc(GoodCyc,:),20);
% 
% 
% pre=ca1p; post=ec3p;
% figure(323);
% for i=1:length(pre)
%     clf
%     for j=1:length(post)
%         subplotfit(j,length(post));
%         bar(t,sq(ccg(:,pre(i),post(j)))); axis tight;
%         hold on; Lines(0,[],'r');
%         title(num2str([pre(i) post(j)]));
%     end
%     cc='xlim([-500 500])';
%     %    pause
%     while 1
%         [x y b] = ginput(1);
%         switch b
%             case 1
%                 ForAllSubplots(cc); cc='xlim([-2000 2000])';
%             case 2
%                 xlim(x+[-200 200]);
%             case 3
%                 break;
%         end
%     end
% end
% 
% 
% 
% 
% for ii=1:length(ec3p)
%     for jj=1:length(ca1p)
%         % ind1 = find(Clu==ec3p(ii));
%         % ind2 = find(Clu==ca1p(jj));
%         ind1 = find(Clu==20);
%         ind2 = find(Clu==33);
% 
%         whos ind*
%         res1 = Res(ind1); res2 = Res(ind2);
% 
%         rpc1= accumarray(CycNo(ind1),CycFr(ind1),[nCyc 1],@sum);
%         rpc2= accumarray(CycNo(ind2),CycFr(ind2),[nCyc 1],@sum);
%         gc12 = find(rpc1>0&rpc2>0);
% 
% 
%     end
% end
% 
% 
% %divide in 250msec windows and compute inst rate, phase, freq,






