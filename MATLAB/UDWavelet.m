 function out = UDWavelet(FileBase,varargin)
%function out = UDUnits(FileBase,fMode, CxEl,HpcEl)
[fMode, CxEl, HpcEl, Report] = DefaultArgs(varargin,{'compute','c','h',0});

Par = LoadPar([FileBase]);
RepCh = RepresentChan(Par);
switch fMode
    case 'compute'
          load([FileBase '.' mfilename '.mat']);
          out = OutArgs;
          if isempty(out.Chans)
              return;
          end
        if isstr(CxEl)
            [Chans Els] = GetChannels(FileBase,CxEl);
        else
            Els = CxEl;
        end
        Period = SelectStates(FileBase,'SWS',1250*60);       
        if FileExists([FileBase '.spw'])
            spw = load([FileBase '.spw']);
            spw = spw(:,1);
            [spw ind1] =SelectPeriods(spw,Period,'d',1);
           
        else
            spw =[];
        end
        if isempty(spw)
            warning('no spws');
%            return
        else
            fprintf('%d spws\n',length(spw));
        end
 %       return
        [Res,Clu,nclu,dummy,CluByEl] = ReadEl4CCG(FileBase,Els);
        Res = round(Res/16);

        [Res ind] =SelectPeriods(Res,Period,'d',1);
        Clu =Clu(ind);
        [uClu dummy Clu] = unique(Clu);
        out.ElClu = CluByEl(uClu,1:2);
        nClu = max(Clu);

                
        %detect onset of upstates
        %[Burst, BurstLen, SpkPos, OutOf] = SplitIntoBursts(Res, 1.25*150);
        pb = PopulationBursts(Res,Clu,1.25*150,1250*2,1250);
        goodpb = find(pb.FirstBinRate> prctile(pb.FirstBinRate,10));
        UnitUp = pb.BurstTime(goodpb);
        
        [UpRes UpClu] = ReadEl4CCG([FileBase '.delw'],1);
        
        mchi = find(ismember(RepCh,out.Chans));
        SelCh= [RepCh(mchi(1))-5:RepCh(mchi(2))+5];        
        SelCh = intersect(SelCh,RepCh);
        out.SelChan = SelCh;
        [out.SpecUnit out.wt out.wf] = TrigScalogramFile(FileBase,UnitUp,SelCh,1000,[1 125],5);
     %   [out.SpecFld out.wt out.wf] = TrigScalogramFile(FileBase,UpRes,SelCh,1000,[1 125],5);
       
        
%         rs =10;
%         reFs = eFs/rs;
%         Res = round(Res/rs);
%         step = 2^nextpow2(reFs*Step/1000);
%         win=2^nextpow2(reFs*Win/1000);
%         warning off
%         out  = mtptchgram_trig(struct('Eeg',[Vm eeg],'Res',Res,'Clu',Clu),...
%             Up, 1.3*reFs , struct('Fs',reFs,'nFFT',2^10/rs,'WinLength',win, 'WinStep',step,'NW',2,...
%             'MinSpikes', 2,'FreqRange',[1 60], 'CheckErr',1,'NormCoh',1));
%        warning on
    case 'spw'
        if FileExists([FileBase '.' mfilename '.mat'])
            load([FileBase '.' mfilename '.mat']);
            out = OutArgs;
        end
%        Period = SelectStates(FileBase,'SWS',1250*60);       
        if FileExists([FileBase '.spw'])
           spw = load([FileBase '.spw']);
           spw = spw(:,1);
        
        end
        Delta = LoadEvt([FileBase '.del.evt'], 1250);
%         [out.spwav out.spwstd out.spwt] = TriggeredAvM(FileBase,spw,300,1250,Par.nChannels,1,'eeg');
%         [out.delav out.deltstd out.delt] = TriggeredAvM(FileBase,Delta,1000,1250,Par.nChannels,1,'eeg');

        [out.spwavcsd out.spwstdcsd out.spwt] = TriggeredAvM(FileBase,spw,300,1250,Par.nChannels,1,'csd');
        [out.delavcsd out.deltstdcsd out.delt] = TriggeredAvM(FileBase,Delta,1000,1250,Par.nChannels,1,'csd');
        
    case 'display'
        load([FileBase '.' mfilename '.mat']);
        figure(323);clf
        if ~isfield(OutArgs,'SelChan')
            return;
        end
        nCh = length(OutArgs.SelChan);
        if nCh==0
            return;
        end
        t=OutArgs.wt; f=OutArgs.wf;
        for i=1:nCh
            subplotfit(i,nCh);
            normf = repmat(f(:)'.^2,length(t),1);
            imagelog(t,f, sq(OutArgs.SpecUnit(:,:,i))'.*normf');
            title(num2str(OutArgs.SelChan(i)));
        end
        %suptitle([FileBase ' );
 %      reportfig(gcf,'UDWavelet',0,[FileBase ' UD Units']);
        % waitforbuttonpress
        figure(324);clf        
        for i=1:nCh
            subplotfit(i,nCh);
            normf = repmat(f(:)'.^2,length(t),1);
            imagelog(t,f, sq(OutArgs.SpecFld(:,:,i))'.*normf');
            title(num2str(OutArgs.SelChan(i)));
        end
        %suptitle([FileBase ' - UD Field']);
%       reportfig(gcf,'UDWavelet',0,[FileBase ' UD Field']);        
       
    case 'display_spw'
        load([FileBase '.' mfilename '.mat']);
        out = OutArgs;
        
        [repch tetro info] = RepresentChan(FileBase);

        figure(323);clf
        PlotCSD96(OutArgs.spwav,OutArgs.spwt,[1:Par.nChannels],Par,2);  
        suptitle([FileBase ' - spw']);
      %  reportfig(gcf,'SWS_CSD',0,[FileBase '- spw']);
        
        figure(324);clf
        PlotCSD96(OutArgs.delav,OutArgs.delt,[1:Par.nChannels],Par,2);  
        ForAllSubplots('xlim([-400 400])');
        suptitle([FileBase ' - delta']);
     %   reportfig(gcf,'SWS_CSD',0,[FileBase '- delta']);         
        
%          [x y b] = PointInput(3);
%          if b(3)==1
%              out.Chans = round(y(2:end));
%          else
%              out.Chans = [];
%          end

    case 'wavelet'
        load([FileBase '.' mfilename '.mat']);
        out = OutArgs;
        
        Delta = LoadEvt([FileBase '.del.evt'],1250);
        [out.SpecDelta out.wt out.wf] = TrigScalogramFile(FileBase,Delta,RepCh,1000,[1 125],5);
        out.DeltaChan = RepCh;
%       
    case 'wavelet_csd'
        load([FileBase '.' mfilename '.mat']);
        out = OutArgs;
        
        Delta = LoadEvt([FileBase '.del.evt'],1250);
       
        [out.SpecDeltaCsd out.wt out.wf] = TrigScalogramFile(FileBase,Delta,RepCh,1000,[1 125],5,'csd');
        out.DeltaChan = RepCh;


    case 'wavelet1'
        load([FileBase '.' mfilename '.mat']);
        out = OutArgs;
        
        Delta = LoadEvt([FileBase '.del.evt'],1250);
        if isstr(CxEl)
            [Chans Els] = GetChannels(FileBase,CxEl);
        else
            Els = CxEl;
        end
        [Res,Clu,nclu,dummy,CluByEl] = ReadEl4CCG(FileBase,Els);
        Res = round(Res/16);
        [DeltaUp xi yi] = NearestNeighbour(Res,Delta,'right');
        DeltaUp = unique(DeltaUp);
     
        CxCh = load([FileBase '.del.par']);
        
        GamCh= [CxCh;OutArgs.Chans(:)];
        eeg = LoadBinary([FileBase '.eeg'],GamCh,Par.nChannels)';
        eeg = resample(double(eeg),1,5);
        eeg = ButFilter(eeg,2,[30 80]/125,'bandpass');
        pow = log(Filter0(ones(50,1),abs(eeg)));
        % now pow is well normal distributed, so can use z-scores
        thr = mean(pow)+2*std(pow);
        sig = [-1 -1];
        nLoc = length(GamCh);
        for i=1:nLoc
%             lm = LocalMinima(-eeg(:,i)*sig(i),1.25*15,0);
%             lm = lm(pow(lm,i)>thr(i));
%             out.gamtr{i} = ind(lm);
%             out.gampow{i} = pow(lm,i);

            powlm = LocalMinima(-pow(:,i),250*50/1000,-thr(i));
            out.powres{i} = powlm*5;
            out.powval{i} = pow(powlm,:);
        end
        
        [T,G] = CatTrains(out.powres,{1,2,3});
        [out.gccg out.gtbin] = Trains2CCG({DeltaUp, Delta, Res,T},{1,2,3,G},20,100,1250);
        
        GamSegs = GetSegs(pow,round(Delta/5)-50,101,[]);
         for ii=1:size(GamSegs,2)
             [xc xl] = xcorr(unity(GamSegs(:,ii,2)),unity(GamSegs(:,ii,3)),'unbiased');
             [ddu gshft(ii)] = max(xc);
         end
        out.xclag = xl(gshft)*1000/250;
%        keyboard
        [out.SpecDeltaUp out.wt out.wf] = TrigScalogramFile(FileBase,DeltaUp,RepCh,1000,[1 125],5);
        out.DeltaChan = RepCh;

    case 'filter_csd'
        
        load([FileBase '.' mfilename '.mat']);
        out = OutArgs;
        
        Delta = LoadEvt([FileBase '.del.evt'],1250);
        if isstr(CxEl)
            [Chans Els] = GetChannels(FileBase,CxEl);
        else
            Els = CxEl;
        end
        [Res,Clu,nclu,dummy,CluByEl] = ReadEl4CCG(FileBase,Els);
        Res = round(Res/16);
        [DeltaUp xi yi] = NearestNeighbour(Res,Delta,'right');
        DeltaUp = unique(DeltaUp);
        
        CxCh = load([FileBase '.del.par']);
        
        GamCh= [CxCh;OutArgs.Chans(:)];
        eeg = LoadBinary([FileBase '.csd'],GamCh,Par.nChannels)';
        eeg = resample(double(eeg),1,5);
        eeg = ButFilter(eeg,2,[30 80]/125,'bandpass');
        pow = log(Filter0(ones(50,1),abs(eeg)));
        % now pow is well normal distributed, so can use z-scores
        thr = mean(pow)+1.5*std(pow);
        sig = [-1 -1];
        nLoc = length(GamCh);
        for i=1:nLoc
%             lm = LocalMinima(-eeg(:,i)*sig(i),1.25*15,0);
%             lm = lm(pow(lm,i)>thr(i));
%             out.gamtr{i} = ind(lm);
%             out.gampow{i} = pow(lm,i);

            powlm = LocalMinima(-pow(:,i),250*30/1000,-thr(i));
            out.powrescsd{i} = powlm*5;
            out.powvalcsd{i} = pow(powlm,:);
        end
        
        [T,G] = CatTrains(out.powrescsd,{1,2,3});
        [out.gccgcsd out.gtbin1] = Trains2CCG({DeltaUp, Delta, Res,T},{1,2,3,G},20,100,1250);
        
        
    case 'display_wav'
        load([FileBase '.' mfilename '.mat']);
        out = OutArgs;
        gfri = find(OutArgs.wf>40 & OutArgs.wf<80);
        wt = (OutArgs.wt-0.5)*1000;
        gti = find(wt>-50 & wt<100);
        sz = size(OutArgs.SpecDelta(:,gfri,:));
        dgampow = (OutArgs.SpecDelta(:,gfri(1:end-1),:)+OutArgs.SpecDelta(:,gfri(2:end),:))/2;
        dfreq = diff(OutArgs.wf(gfri));
        gpow = sq(sum(dgampow.*repmat(dfreq(:)',[sz(1) 1 sz(3)]),2));
        
       dgampow1 = (OutArgs.SpecDeltaUp(:,gfri(1:end-1),:)+OutArgs.SpecDeltaUp(:,gfri(2:end),:))/2;
        gpow1 = sq(sum(dgampow1.*repmat(dfreq(:)',[sz(1) 1 sz(3)]),2));
        
%        badch = setdiff([1:Par.nChannels],RepCh);
        nRepCh = length(RepCh);
    %    keyboard

    
        figure(918439);clf
        subplot(141)
        imagesc(wt(gti),[1:nRepCh],unity(gpow(gti,:))');
        title('gamma power trig by Delta');
   %     xlim([-200 200]);
        mych = find(ismember(RepCh,OutArgs.Chans));
        Lines([],mych,'k',[],2);
        set(gca,'YTick',[1:nRepCh]);
        set(gca,'YTickLabel',num2str(RepCh(:)));

          gti = find(wt>-150 & wt<100);
         subplot(142)
        imagesc(wt(gti),[1:nRepCh],unity(gpow1(gti,:))');
        title('gamma power trig by Up');
        mych = find(ismember(RepCh,OutArgs.Chans));
        Lines([],mych,'k',[],2);

        
        subplot(143)
        mt = find(OutArgs.spwt>-100 & OutArgs.spwt<100);
        imagesc(OutArgs.spwt(mt),[1:nRepCh],OutArgs.spwavcsd(mt,RepCh)');
         Lines([],mych,'k',[],2);
         title('spw');
        
        subplot(144)
        mt = find(OutArgs.delt>-200 & OutArgs.delt<200);
        imagesc(OutArgs.delt(mt),[1:nRepCh],OutArgs.delavcsd(mt,RepCh)');
         Lines([],mych,'k',[],2);
         title('delta');
 %       reportfig(gcf,'SWS_GAM',0,[FileBase ' - triggered stuff']);
%          subplot(131);
%          [x y b] = PointInput(2);
%          out.Chans = RepCh(round(y));
%         
      %keyboard
        figure(2323);clf
        gti = find(wt>-300 & wt<300);
        sti = find(wt>-400 & wt<-300);
        normf = repmat(OutArgs.wf(:)'.^2,length(gti),1);

        for i=1:2
        subplot(2,2,(i-1)*2+1);
        %subplot(2,1,i);
        myPow = sq(OutArgs.SpecDelta(gti,:,mych(i)));
        meanPow = sq(mean(OutArgs.SpecDelta(sti,:,mych(i))));
        subpow = repmat(meanPow,length(gti),1);
        imagelog(wt(gti),OutArgs.wf,log(myPow)'-log(subpow)');
        title(num2str(OutArgs.Chans(i)));

        
        subplot(2,2,(i-1)*2+2);
        %subplot(2,1,i);
        myPow = sq(OutArgs.SpecDeltaUp(gti,:,mych(i)));
        meanPow = sq(mean(OutArgs.SpecDeltaUp(sti,:,mych(i))));
        subpow = repmat(meanPow,length(gti),1);
        imagelog(wt(gti),OutArgs.wf,log(myPow)'-log(subpow)');
        title(num2str(OutArgs.Chans(i)));

        
%         subplot(2,2,(i-1)*2+2);
%         imagelog(wt(gti),OutArgs.wf,(myPow)'.*normf');
        
        end
    case 'display_filt'
           load([FileBase '.' mfilename '.mat']);
        figure(873);clf
        BarMatrix(OutArgs.gtbin, OutArgs.gccg);
        ForAllSubplots('xlim([-500 500])');
        suptitle([FileBase ' -  eeg']);
        
        figure(874);clf
        BarMatrix(OutArgs.gtbin, OutArgs.gccgcsd);
        ForAllSubplots('xlim([-500 500])');
        suptitle([FileBase ' -  csd']);
%       reportfig(gcf,'SWS_GAM',0,[FileBase ' - triggered specgrograms']);
 %       PlotTraces96(gpow,OutArgs.wt,[1:Par.nChannels],Par,'plot');
    case 'specgram'
        load([FileBase '.' mfilename '.mat']);
        out = OutArgs;
        Win = 70;
        rs =5;
        eFs = 1250;
        reFs = eFs/rs;
        win=2^nextpow2(reFs*Win/1000);
       Period = load([FileBase '.sts.SWS']);
        Delta = LoadEvt([FileBase '.del.evt'],1250);
          if isstr(CxEl)
            [Chans Els] = GetChannels(FileBase,CxEl);
        else
            Els = CxEl;
        end
        [Res,Clu,nclu,dummy,CluByEl] = ReadEl4CCG(FileBase,Els);
        Res = round(Res/16);
        [DeltaUp xi yi] = NearestNeighbour(Res,Delta,'right');
        DeltaUp = unique(DeltaUp);
        
        CxCh = load([FileBase '.del.par']);
        GamCh= [CxCh;OutArgs.Chans(:)];
        eeg = LoadBinary([FileBase '.csd'],GamCh,Par.nChannels)';
        eeg = resample(double(eeg),1,rs);
%         eeg = ButFilter(eeg,2,[30 80]/reFs*2,'bandpass');
%         pow = log(Filter0(ones(50,1),abs(eeg)));
%          weeg = WhitenSignal(eeg);      
%         warning off
%         out  = mtptchgram_trig(struct('Eeg',weeg),...
%             Delta, 1.3*reFs , struct('Fs',reFs,'nFFT',2^10/rs,'WinLength',win, 'WinStep',step,'NW',2,...
%             'FreqRange',[1 60]));
%        warning on
%        
        [DiffSpec, f, t, TrigSpec, BslnSpec] = ...
             TrigSpecgram(eeg,round(DeltaUp/rs),win,15,reFs,round(Period/rs), [20 100], 1, 0.1,2);
TrigSpecgram(eeg,round(NcDelta/rs),win,10,reFs,round(Period/rs), [10 120], 1, 0.1,2);

        keyboard
 
end

         