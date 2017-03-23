%function out =  GammaCompUnits(FileBase,fMode, Elec)
function out = GammaCompUnits(FileBase,varargin)
    
[fMode, Elec ] =DefaultArgs(varargin,{'compute','all'});

Par = LoadPar([FileBase '.xml']);
States = {'REM','RUN'};

[repChannels,IfTetrode, Info] = RepresentChan(Par);

switch fMode
    case 'compute'
        load([FileBase '.GammaComponents.mat']);
        gs = load([FileBase '.GammaSpecs.mat']);
        wcnt=1;
        RepCh = RepresentChan(Par); nCh = length(RepCh);
        if strcmp(Elec,'all')
           [Res,Clu,Map] = LoadCluRes(FileBase);
        else
            [dummy Elec] =  GetChannels(FileBase,Elec);
            [Res,Clu,Map] = LoadCluRes(FileBase, Elec);    
        end
        
        Res = round(Res/16);
        smf = round(80/diff(gs.OutArgs.erppca(1).t(1:2))/1000);
        for w = 1:length(States) %loop through states
            if ~FileExists([FileBase '.sts.' States{w}]) continue; end
            Period = load([FileBase '.sts.' States{w}]);
      %      eigvec = gs.OutArgs(wcnt).erppca(wcnt).eigvecr;
            nComps= length(OutArgs(wcnt).GoodComp);
            [myRes ind] = SelectPeriods(Res,Period,'d',1,1);
            [myResOrig ind] = SelectPeriods(Res,Period,'d',1);
            myClu = Clu(ind);
            [uClu dummy myClu] = unique(myClu);
            myMap = Map(uClu,2:3);
            nClu = max(uClu);
            t= gs.OutArgs.erppca(w).t;
            f= gs.OutArgs.erppca(w).f;
            ts = round(t*Par.lfpSampleRate); % time in eeg sample rate of components
            
            for ch=1:nCh
                [eeg eegind]= LoadBinary([FileBase '.eeg'],RepCh(ch),Par.nChannels,4,[],[],Period);
                for k=1:nComps
                    myFreq = OutArgs(wcnt).GoodComp(k).UseFreq+[-5 5];
                    feeg = ButFilter(eeg',2,myFreq/Par.lfpSampleRate*2,'bandpass');
                    ph = angle(hilbert(feeg));
                    
                    sfl = Filter0(gausswin(smf,1)/sum(gausswin(smf,1)),OutArgs(wcnt).Proj(:,k));
                    cpks = LocalMinima(-sfl,smf,-prctile(sfl,75));
                    cpkst = find(ismember(eegind,ts(cpks))); % now translate it to collapsed eeg samples

                    %now select spikes by Proj amplitude or around Proj
                    %peak and compute rayleigh stats 
                    % also compute them overall for comparison
                    ProjAtRes = interp1(ts,OutArgs(wcnt).Proj(:,k),myResOrig);
                    ProjThr = prctile(sfl,[30:10:90]);
                    
                    nb = length(ProjThr);
                    for b=1:nb
                        mySpk = find(ProjAtRes>ProjThr(b));
                        out(wcnt).rt_amp(ch,k,b) = RayleighTest( ph(myRes(mySpk)), myClu(mySpk), nClu);
                    end
                    
                    ProjLat = [30:30:150]*1.25;
                    nb = length(ProjLat);
                    for b=1:nb
                        cpksper = repmat(cpkst,1,2)+repmat([-1 1]*ProjLat(b),length(cpkst),1);
                        [dummy mySpk]  =  SelectPeriods(myRes, cpksper,'d',1);
                        out(wcnt).rt_lat(ch,k,b) = RayleighTest( ph(myRes(mySpk)), myClu(mySpk), nClu);
                    end
                    
                    out(wcnt).rt_all(ch,k) = RayleighTest( ph(myRes), myClu, nClu);
                end
                out(wcnt).Map = myMap;
            end
            wcnt=wcnt+1;
        end
        save([FileBase '.' mfilename '.mat'],'out');
    case 'display'
        load([FileBase '.' mfilename '.mat']);
        gc = load([FileBase '.GammaComponents.mat']);
        Map = SiliconMap(Par);
        %       CluLoc = load([FileBase '.cluloc']);
        %        UnitCh = CluLoc(ismember(CluLoc(:,1:2),map(:,2:3),'rows'),3);
        %      UnitCoord = Map.GridCoord(UnitCh,:)+(rand(length(UnitCh),2)-0.5)*0.5;
        nst= length(out);
        wc=1;
        for w=1:nst
            if ~FileExists([FileBase '.sts.' States{w}]) continue; end
            usert = out(wc).rt_lat;
            sz = size(usert);

            for ii=1:sz(1)
                for jj=1:sz(2)
                    for kk=1:sz(3)
                        R(ii,jj,kk,:) = usert(ii,jj,kk).r;
                        logZ(ii,jj,kk,:) = usert(ii,jj,kk).logZ;
                        th0(ii,jj,kk,:) = usert(ii,jj,kk).th0;
                        n(ii,jj,kk,:) = usert(ii,jj,kk).n;
                    end
                end
            end
            if 1
                for comp=1:sz(2)
                    ncomp = sq(n(1,comp,3,:));
                    nb = sz(3);%-4+1;
                    myUnit = find(ncomp>40);
                    mcomp = reshape(sq(R(:,comp,1:end,myUnit)),sz(1),[]);
                    [u s v] = svd(mcomp,0);
                    eigval =diag(s);
                    compsgn = sign(mean(v));
                    ChComp = gc.OutArgs.GoodComp(comp).UseChannels;
                    CompCoord = Map.GridCoord(ChComp,:);
                    k=1;
                    while 1
                        figure(32344);
                        clf
                        subplot(221)
                        MapSilicon(u(:,k)*compsgn(k),Par);
                        hold on
                        plot(CompCoord(:,1),CompCoord(:,2),'xk');
                        title(['component ' num2str(comp) ]);
                        subplot(212)
                        rv =reshape(v(:,k)*compsgn(k),nb,[])';
                        bar(rv,'stacked');axis tight
                      %  subplot(224)
                      %  scatter(UnitCoord(myUnit,1),UnitCoord(myUnit,2),20,rv(:,3),'filled');
                      %  axis([0.5 6.5 0.5 16.5]); axis ij

                        subplot(222)
                        plot(eigval(1:20),'.');  hold on
                        plot(k,diag(eigval(k)),'ro');
                        [x y b] = ginput(1);
                        switch b
                            case 1
                                k=k+1; if k>5 k=1; end
                                continue;
                            case 3
                                compsgn(k)=-compsgn(k);
                                continue
                            otherwise
                                figure(9834);
                                subplotfit(comp,sz(2));
                                MapSilicon(u(:,k)*compsgn(k),Par);
                                hold on
                                plot(CompCoord(:,1),CompCoord(:,2),'xk');
                                break;
                        end
                    end
                    %            mcomp = sq(R(:,comp,5,:));
                end
                
            else
                figure(8774);clf
                sigthr = log(-log(0.005));
                barmat= [];
                cc=colormap;
                cstep = floor(size(cc,1)/sz(2));
                subplot(211)
                b=2;
                for comp=1:sz(2)
                    mychi = gc.OutArgs(wc).GoodComp(comp).UseChannelsi;
                    mlogZ = sq(logZ(mychi,comp,b,:));
                    mR = sq(mean(R(mychi,comp,b,:)));
                    mth0 = circmean(sq(th0(mychi,comp,b,:)));
                    sigchnum = sum(sq(logZ(mychi,comp,b,:))>sigthr);
                    sigrat = sigchnum./length(mychi);%sigchnum1(sigchind)*100;

                    sigchind = find(sigchnum&sigrat>0.1);
                    if isempty(sigchind) continue; end
                    barmat(comp,sigchind) = sigrat(sigchind);

                    %subplotfit(comp,sz(2));
                    hold on
                    if strcmp(gc.OutArgs(wc).GoodComp(comp).Location,'c')
                        plot(mth0(sigchind),mR(sigchind),'o','Color',cc(comp*cstep,:));
                    else
                        plot(mth0(sigchind),mR(sigchind),'x','Color',cc(comp*cstep,:));
                    end

                    % bar(mlogZ); axis tight
                    % Lines([],log(-log([0.005 0.01 0.05])));
                    %                title(gc.OutArgs.GoodComp(comp).Location);
                end
                %            figure(3232);clf
                subplot(212)
                if isempty(barmat) return; end
                bar(barmat,'stacked')
                set(gca,'XTick',[1:sz(2)]);
                compLoc= CatStruct(gc.OutArgs(wc).GoodComp,'Location');
                set(gca,'XTickLabel',compLoc.Location);
                title([FileBase ' - ' States{w}]);
            end
            waitforbuttonpress;
            wc=wc+1;
        end
end