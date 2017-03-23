 %function out =  GammaComponents(FileBase,fMode,State)
function out = GammaComponents(FileBase,varargin)

[fMode, State ] =DefaultArgs(varargin,{'fixcmass',[]});

Par = LoadPar([FileBase '.xml']);
out=[];
States = {'REM','RUN'};
[Channels,IfTetrode, Info] = RepresentChan(Par);
Map = SiliconMap(Par);
switch fMode
    case 'select'
        gs = load([FileBase '.GammaSpecs.mat']);
      %  load([FileBase '.' mfilename '.mat']);
        wcnt=1;
        for w = 1:length(States) %loop through states
            if ~FileExists([FileBase '.sts.' States{w}]) continue; end
            fprintf('Selections for state %s\n',States{w});
            
%             lsgspec=dir(['*.gspec*.' States{w}]); gspec1 = lsgspec(3).name;
%             load(gspec1,'t','f','-MAT');
            t= gs.OutArgs.erppca(w).t;
            f= gs.OutArgs.erppca(1).f;
       %     Channels = gs.OutArgs.Channels;
%            f = gs.OutArgs.f; t = gs.OutArgs.t;
            nChannels = length(Channels); nf = length(f); nt = length(t);

            %    if ispca
            eigvec = gs.OutArgs.erppca(wcnt).eigvecr;
            eigval = gs.OutArgs.erppca(wcnt).eigval(:,4);

            nPCA= size(eigvec,3);
            %     else
            %         eigvec = dotdot(OutArgs.ICA(wcnt).A,'*',OutArgs.ICA(wcnt).MeanIC');
            %         nPCA= size(eigvec,2);
            %         eigvec = reshape(eigvec,[nf, nChannels, nPCA]);
            %     end
            OutArgs(wcnt).GoodComp = MapGui(eigvec,eigval,Channels,f,Par);

            wcnt = wcnt+1;
        end
        save([FileBase '.' mfilename '.mat'],'OutArgs');
    case {'project','fixcmass'}
        
        gs = load([FileBase '.GammaSpecs.mat']);
        load([FileBase '.' mfilename '.mat']);
        if strcmp(fMode, 'project')
        load([FileBase '.thpar.mat'],'ThPh');
        end
        %smoothing factor & detection refractory delay
        smf = round(80/diff(gs.OutArgs.erppca(1).t(1:2))/1000);
        wcnt=1;
        for w = 1:length(States) %loop through states
            if ~FileExists([FileBase '.sts.' States{w}]) continue; end
            t= gs.OutArgs.erppca(w).t;
            f= gs.OutArgs.erppca(w).f;
           % Channels = gs.OutArgs.Channels;
            %f = gs.OutArgs.f; 
            nChannels = length(Channels); nf = length(f); nt = length(t);
            if strcmp(fMode, 'project')
                y= LoadSpecs(FileBase,States{w});
                y = reshape(y,size(y,1),[]);
            end
            eigvec = gs.OutArgs.erppca(wcnt).eigvecr;

            Comps = CatStruct(OutArgs(wcnt).GoodComp,{'Location','ComponentNum'});
            nComps = length(Comps.ComponentNum);

            nPhBins = 18;
            nChannels = length(Channels);

            %now compute the projections
            neweigvec = eigvec(:,:,Comps.ComponentNum);
            
            for k=1:nComps
                %get indexes to zero
                fi = find(abs(f-OutArgs(wcnt).GoodComp(k).UseFreq)<10);
                notfi = setdiff([1:length(f)],fi);
                notchi = setdiff([1:nChannels],OutArgs(wcnt).GoodComp(k).UseChannelsi);

                neweigvec(notfi,:,k) = 0; %zero everything but selection
                neweigvec(:,notchi,k) = 0; %zero everything but selection
                %also compute the center of mass of each component -
                %channel
                
                myeig = sq(neweigvec(OutArgs(wcnt).GoodComp(k).UseFreqi,OutArgs(wcnt).GoodComp(k).UseChannelsi,k));
                myeig(myeig<0) = 0;
                nch = length(myeig);
                if IfTetrode 
                    CmassChani = OutArgs(wcnt).GoodComp(k).UseChannelsi(round(sum([1:nch]'.*myeig(:))/sum(myeig)));
                    OutArgs(wcnt).GoodComp(k).CmassCoord = Map.GridCoord(CmassChani,:);
                elseif Info.nShanks<3
                    CmassChani = round(sum(OutArgs(wcnt).GoodComp(k).UseChannelsi(:).*myeig(:))/sum(myeig));
                    OutArgs(wcnt).GoodComp(k).CmassCoord = Map.GridCoord(CmassChani,:);
                else
                    xc = Map.GridCoord(OutArgs(wcnt).GoodComp(k).UseChannels,:);
                    cmass = sum(xc.*repmat(myeig(:),1,2))./repmat(sum(myeig),1,2);
                    [dd chi] = min(abs(xc(:,1)-cmass(1)).^2+abs(xc(:,2)-cmass(2)).^2);
                    CmassChani = OutArgs(wcnt).GoodComp(k).UseChannelsi(chi);
                    OutArgs(wcnt).GoodComp(k).CmassCoord = cmass;
                end
                OutArgs(wcnt).GoodComp(k).CmassChani = CmassChani;
            end
            if strcmp(fMode, 'project')
                neweigvec = reshape(neweigvec,[],nComps);
                ProjCoef = neweigvec*inv(neweigvec'*neweigvec);
                VarStd = repmat(std(y)',1,nComps);

                ProjCoef = ProjCoef.*VarStd;

                OutArgs(wcnt).Proj = unity(y)*ProjCoef;

                ts = round(t*Par.lfpSampleRate); %absoule time in lfp sampling rate
                tph = ThPh(ts);
                [hst BinInd] = histcI(tph,linspace(-pi,pi,nPhBins+1));

                for k=1:nComps
                    sfl = Filter0(gausswin(smf,1)/sum(gausswin(smf,1)),OutArgs(wcnt).Proj(:,k));
                    lm= LocalMinima(-sfl,smf,-prctile(sfl,85)); %not closer than 5*16 = 80 msec
                    [OutArgs(wcnt).GoodComp(k).ThHist OutArgs(wcnt).GoodComp(k).ThBin] ...
                        = hist([tph(lm); tph(lm)+2*pi]*180/pi,36);
                    CompRes{k} = ts(lm); CompClu{k} = k;

                end
                [OutArgs(wcnt).CompRes OutArgs(wcnt).CompClu] = CatTrains(CompRes,CompClu);
                OutArgs(wcnt).rt = RayleighTest(ThPh(OutArgs(wcnt).CompRes),OutArgs(wcnt).CompClu);
                MakeEvtFile(OutArgs(wcnt).CompRes,[FileBase '.gcm.evt'],OutArgs(wcnt).CompClu,Par.lfpSampleRate,1);
            end
            wcnt=wcnt+1;

        end %loop over states
       % if nargout<1
        save([FileBase '.' mfilename '.mat'],'OutArgs');
        %end
    case 'compres'
        gs = load([FileBase '.GammaSpecs.mat']);
        load([FileBase '.' mfilename '.mat']);
        load([FileBase '.thpar.mat'],'ThPh');
        %smoothing factor & detection refractory delay
        smf = round(80/diff(gs.OutArgs.erppca(1).t(1:2))/1000);
        wcnt=1;
        for w = 1:length(States) %loop through states
            if ~FileExists([FileBase '.sts.' States{w}]) continue; end
            t= gs.OutArgs.erppca(w).t;
            f= gs.OutArgs.erppca(w).f;
            ts = round(t*Par.lfpSampleRate);
            tph = ThPh(ts);
            nComps = length(OutArgs(wcnt).GoodComp);
            prctbound = [10:10:90];
            nprct = length(prctbound);
            for k=1:nComps
                sfl = Filter0(gausswin(smf,1)/sum(gausswin(smf,1)),OutArgs(wcnt).Proj(:,k));
                thr = prctile(sfl,prctbound);
               % sfl1 = smooth(OutArgs(wcnt).Proj(:,k),5,'lowess');
              %keyboard
             % OutArgs = rmfield(OutArgs,'chst');
              %OutArgs  =rmfield(OutArgs,'cbin');
               for l=1:nprct
                    lm= LocalMinima(-sfl,smf,-thr(l));
                    rt(l) = RayleighTest(tph(lm));
                    [OutArgs(wcnt).chst(:,l,k) OutArgs(wcnt).cbin(:,l,k)] ...
                     = hist([tph(lm); tph(lm)+2*pi]*180/pi,36);
               end
                    
               OutArgs(wcnt).crt(k) = CatStruct(rt);
                
               
%                 CompRes{k} = ts(lm); CompClu{k} = k;
            end
%             [OutArgs(wcnt).CompRes OutArgs(wcnt).CompClu] = CatTrains(CompRes,CompClu);
%             OutArgs(wcnt).rt = RayleighTest(ThPh(OutArgs(wcnt).CompRes),OutArgs(wcnt).CompClu);
%             MakeEvtFile(OutArgs(wcnt).CompRes,[FileBase '.gcm.evt'],OutArgs(wcnt).CompClu,Par.lfpSampleRate,1);
            wcnt=wcnt+1;
        end
        if nargout<1
            save([FileBase '.' mfilename '.mat'],'OutArgs');
        end

%     case 'compstat'
%         load([FileBase '.' mfilename '.mat']);
%         gs = load([FileBase '.GammaSpecs.mat']);
%         wcnt=1;
%         for w = 1:length(States) %loop through states
%             if ~FileExists([FileBase '.sts.' States{w}]) continue; end
%             eigvec = gs.OutArgs.erppca(wcnt).eigvecr;
%             for k=1:nComps
%                 %get indexes to zero
%                 myeig = sq(neweigvec(OutArgs(wcnt).GoodComp(k).UseFreqi,OutArgs(wcnt).GoodComp(k).UseChannelsi,k));
%                 
%             end
%         end
%         save([FileBase '.' mfilename '.mat'],'OutArgs');
         
         
    case 'display_theta'
     
        load([FileBase '.' mfilename '.mat']);
         wcnt=1;  
        for w = 1:length(States) %loop through states
            if ~FileExists([FileBase '.sts.' States{w}]) continue; end
           % rt = RayleighTest(ThPh(OutArgs(wcnt).CompRes),OutArgs(wcnt).CompClu); 
            nComp = length(OutArgs(wcnt).GoodComp);
            gc = CatStruct(OutArgs(wcnt).GoodComp,{'ComponentNum','UseFreq','CmassChani','CmassCoord','ThHist'});
            for ii=1:nComp
                gc.Location{ii} = OutArgs(wcnt).GoodComp(ii).Location;
            end
            cxi = find(strcmp(gc.Location,'c'));
            hpi = find(strcmp(gc.Location,'h'));
            uni = setdiff([1:nComp],[cxi hpi]);
            sigi = find(OutArgs(wcnt).rt.p<0.01);
            SortInd = [];
            SortInd(:,1) = 2*ones(nComp,1);
            SortInd(cxi,1) = 1;  SortInd(hpi,1) = 0;
            SortInd(:,2) = gc.UseFreq;
            [s si] = sortrows(SortInd);
            
            figure(56732);clf
            subplot(121);
            imagesc(OutArgs(wcnt).GoodComp(1).ThBin,[1:nComp],unity(gc.ThHist(:,si))');
            set(gca,'YTick',[1:nComp],'YTickLabel',gc.Location(si));
            
            cxi = intersect(cxi, sigi);            
            hpi = intersect(hpi, sigi);
            uni = intersect(uni, sigi);
            
            subplot(222);
            hd = polar(0,max(gc.UseFreq),'w.');            hold on
            polar(OutArgs(wcnt).rt.th0(cxi),gc.UseFreq(cxi),'b.');

            polar(OutArgs(wcnt).rt.th0(hpi),gc.UseFreq(hpi),'r.');
            polar(OutArgs(wcnt).rt.th0(uni),gc.UseFreq(uni),'g.');
            delete(hd);
            
            subplot(224);
            hd = polar(0,max(OutArgs(wcnt).rt.r),'w.'); hold on
            polar(OutArgs(wcnt).rt.th0(cxi),OutArgs(wcnt).rt.r(cxi),'b.');
            polar(OutArgs(wcnt).rt.th0(hpi),OutArgs(wcnt).rt.r(hpi),'r.');
            polar(OutArgs(wcnt).rt.th0(uni),OutArgs(wcnt).rt.r(uni),'g.');
            delete(hd);
            
%             subplot(234);
%             
%             keyboard
%             
            wcnt =wcnt+1;
            waitforbuttonpress;
        end
       % save([FileBase '.' mfilename '.mat'],'OutArgs');
    
       case 'display'
        gs = load([FileBase '.GammaSpecs.mat']);
        load([FileBase '.' mfilename '.mat']);
        wcnt=1;
        for w = 1:length(States) %loop through states
            if ~FileExists([FileBase '.sts.' States{w}]) continue; end
            if ~isempty(State) & ~strcmp(States{w},State) 
                wcnt=wcnt+1;
                continue; 
            end
            
            t= gs.OutArgs.erppca(w).t;
            f= gs.OutArgs.erppca(w).f;
%             Channels = gs.OutArgs.Channels;
%             f = gs.OutArgs.f; t = gs.OutArgs.t;
%             nChannels = length(Channels); nf = length(f); nt = length(t);
            nComp = length(OutArgs(wcnt).GoodComp);
            figure(32323+w);clf
            for i=1:nComp
                subplotfit(i,nComp);
                Compi = OutArgs(wcnt).GoodComp(i).ComponentNum;
                eigvec = gs.OutArgs.erppca(wcnt).eigvecr(:,:,Compi);
                fi =OutArgs(wcnt).GoodComp(i).UseFreqi;
                nCh = size(eigvec,2);
                chi=find(ismember(Channels,OutArgs(wcnt).GoodComp(i).UseChannels));
                nchi = setdiff([1:nCh],chi);
                eigvec(:,nchi) = NaN;
                [m maxi] = max(eigvec(fi,:));
                
                ploteig = sq(eigvec(fi,:));
                ploteig(sq(eigvec(fi,:))<0.3)=NaN;
                ploteig(sq(eigvec(fi,:))>0.3)=OutArgs(wcnt).rt.th0(i)*180/pi;
                if 0
                    MapSilicon(ploteig, Par,[],0,[-180 180],1,[],1);
                else
                     MapSilicon(eigvec(fi,:), Par,[],0,[],0,[],1);
                end
                %MapSilicon(unity(sq(eigvec(fi,:)))*exp(sqrt(-1)*OutArgs(wcnt).rt.th0(i)), Par,[],0,[],[],[],1);
                
                ca = get(gca,'Position');
                set(gca,'Position',[1 1 1 2/3].*ca)
                h = axes('position',[ca(1) ca(2)+ca(4)*2/3 ca(3) 1/3*ca(4)]);
                plot(f,eigvec(:,maxi));axis tight
                set(h,'XAxisLocation','top');
                set(h,'YTick',[]);
                ylabel(['comp. # ' num2str(i)]);
                set(gcf,'Name',States{w});
               % imagesc(f,[1:nChannels],sq(eigvec)');
                %eigval = gs.OutArgs.erppca(wcnt).eigval(:,4);
            end
          %  nPCA= size(eigvec,3);
            %     else
            %         eigvec = dotdot(OutArgs.ICA(wcnt).A,'*',OutArgs.ICA(wcnt).MeanIC');
            %         nPCA= size(eigvec,2);
            %         eigvec = reshape(eigvec,[nf, nChannels, nPCA]);
            %     end
           % OutArgs(wcnt).GoodComp = MapGui(eigvec,eigval,Channels,f,Par);

            wcnt = wcnt+1;
          %  waitforbuttonpress;
        end
    case 'detectLocation'
        
       load([FileBase '.' mfilename '.mat']);
        gs = load([FileBase '.GammaSpecs.mat']);
        wcnt=1;cnt=1;
        load('ChanInfo/ChanLoc_Full.eeg.mat');
        Locations = fieldnames(chanLoc);
        nLoc = length(Locations);
        for w = 1:length(States) %loop through states
            if ~FileExists([FileBase '.sts.' States{w}]) continue; end
            nComp = length(OutArgs(wcnt).GoodComp);
            figure(2389+w);clf
            for ii=1:nComp
                Compi = OutArgs(wcnt).GoodComp(ii).ComponentNum;
                eigvec = gs.OutArgs.erppca(wcnt).eigvecr(:,:,Compi);
                OutArgs(wcnt).GoodComp(ii).eigvec = eigvec; %finally we'll have it saved
                fi =OutArgs(wcnt).GoodComp(ii).UseFreqi;
                eigvecmap = eigvec(fi,:);
                LocWeight = zeros(nLoc,1);
                for k=1:nLoc
                    locs = chanLoc.(Locations{k});
                    if iscell(locs) locs = cell2mat(locs); end;
                    thisChanInd = find(ismember(Channels, locs));
                    LocWeight(k) = mean(eigvecmap(thisChanInd));
                end
                [m mi] = max(LocWeight);
                OutArgs(wcnt).GoodComp(ii).Location = Locations{mi};
                OutArgs(wcnt).GoodComp(ii).LocationID = mi;
                subplotfit(ii,nComp);
                bar(LocWeight);
                set(gca,'XTick',[1:nLoc],'XTickLabel',Locations);
                title(Locations{mi});
            end
             set(gcf,'Name',States{w});
             wcnt=wcnt+1;
        end
        if nargout<1
            save([FileBase '.' mfilename '.mat'],'OutArgs');
        end

                
    case 'group'
        
        load([FileBase '.' mfilename '.mat']);
        gs = load([FileBase '.GammaSpecs.mat']);
        wcnt=1;cnt=1;
        for w = 1:length(States) %loop through states
            if ~FileExists([FileBase '.sts.' States{w}]) continue; end

            nComp = length(OutArgs(wcnt).GoodComp);
          %  gc = CatStruct(OutArgs(wcnt).GoodComp,{'UseFreq'});
            for ii=1:nComp
                %if OutArgs(wcnt).rt.p(ii)>0.01 continue; end
                out.FileBase{cnt,1} = FileBase;
                out.State{cnt,1} = States{w};
                out.Location{cnt,1} = OutArgs(wcnt).GoodComp(ii).Location;
                out.LocationID(cnt,1) = OutArgs(wcnt).GoodComp(ii).LocationID;
                out.Freq(cnt,1) = OutArgs(wcnt).GoodComp(ii).UseFreq;
                out.Ph(cnt,1) = OutArgs(wcnt).rt.th0(ii);
                out.R(cnt,1) = OutArgs(wcnt).rt.r(ii);
                out.logZ(cnt,1) = OutArgs(wcnt).rt.logZ(ii);
                out.EigVal(cnt,1) = gs.OutArgs.erppca(wcnt).eigval(OutArgs(wcnt).GoodComp(ii).ComponentNum,4);
%                 out.Ph(cnt,1) = OutArgs(wcnt).rt.th0(ii);
%                 out.R(cnt,1) = OutArgs(wcnt).rt.r(ii);
%                 out.logZ(cnt,1) = OutArgs(wcnt).rt.logZ(ii);
                
                cnt=cnt+1;
            end
            wcnt=wcnt+1;
        end
    case 'fix'

        if ~IfTetrode & Info.nShanks<3
            load([FileBase '.' mfilename '.mat']);
            wcnt=1;
            for w = 1:length(States) %loop through states
                if ~FileExists([FileBase '.sts.' States{w}]) continue; end
                lsgspec=dir(['*.gspec*.' States{w}]); gspec1 = lsgspec(3).name;
                load(gspec1,'Channels','-MAT');


                nComp = length(OutArgs(wcnt).GoodComp);
                for k=1:nComp
                    ch = OutArgs(wcnt).GoodComp(k).UseChannels;
                    OutArgs(wcnt).GoodComp(k).UseChannels =  [ch(1):ch(2)];
                    OutArgs(wcnt).GoodComp(k).UseChannelsi =  find(ismember(Channels,[ch(1):ch(2)]));
                end

                wcnt=wcnt+1;
            end
           save([FileBase '.' mfilename '.mat'],'OutArgs');
        end

        
end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%       AUXILLARY PLOT FUNCTION   %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%%%%%%%%%%%%%%%%%%%%
function out = MapGui(eigvec,eigval,Channels,f,Par)
[repChannels,IfTetrode, Info] = RepresentChan(Par);
nChannels = length(repChannels);
if length(Channels) ~=nChannels
    commonInd = find(ismember(Channels,repChannels));
    eigvec = eigvec(:,commonInd,:);
    Channels = Channels(commonInd);
end

Map = SiliconMap(Par);
nev = size(eigvec,3);
ChMap = Map.GridCoord(Channels,:);
nChannels = length(Channels);
GoodComponent = [];compnum=1;
figure(873);clf
subplot(1,3,1);
plot(eigval,'.-');axis tight
hold on
hev = plot(1,eigval(1),'ro');
for i=1:nev
     fprintf('Component # %d\n',i);
    [m maxi] = maxn(sq(eigvec(:,:,i)));
    [mfi mchi] = deal(maxi(1),maxi(2));
    if f(mfi)<30 | f(mfi)>195
        fprintf('discarded by freq.\n');
        %continue;
    end
    subplot(1,3,1);
    set(hev,'XData',i,'YData',eigval(i));
    subplot(1,3,2);
    cla
    imagesc(f,[1:nChannels],sq(eigvec(:,:,i))');
    title(sprintf('component # %d',i));


    maxfi(i) = mfi;
    hold on; Lines(f(mfi),[],'k');

    subplot(1,3,3)
    MapSilicon(sq(eigvec(mfi,:,i)), Par,[]);

    IfGood = 0;
   
    fprintf('Approve component and give a type\n');
    [x y b] = ginput(1);
    switch b
        % this is a good component
        case 1
            IfGood=1;
            out(compnum).Location = '';
        case 3 % bad
            fprintf('discarded\n');
            continue;
        case 2
            fprintf('discarded\n');
            break;
        otherwise
            IfGood=1;
            if b==double('h')
                out(compnum).Location = 'h';
            elseif  b==double('c')
                out(compnum).Location = 'c';
            else
                out(compnum).Location = '';
            end
    end

    if IfGood
        % do selection of channel and freq. range
        out(compnum).ComponentNum = i;
        subplot(1,3,[ 2]);
        fprintf('select freq. ranges on the left plot\n');
        [frx dummy b] = ginput(1);
        %get the left-right boundaries
        %       [m fri] = min(abs(dotdot(frx,'-',f(:)')),[],2);
        % fri = sort(fri);
        if b==1
            [dimmy fri] = min(abs(f-frx));
        else
            fri = mfi; %from auto detection
        end
        out(compnum).UseFreq = f(fri);
        out(compnum).UseFreqi = fri;

        if 1%IfTetrode % don't care for the channels
            if ~isempty(out(compnum).Location)
                myind = find(strcmp(Info.GoodChannelsLoc,out(compnum).Location));
            else
                myind = [1:nChannels];
            end
            out(compnum).UseChannels = Channels(myind);
            out(compnum).UseChannelsi = myind;
        else
            subplot(1,3,3);
            cla
            MapSilicon(sq((eigvec(fri,:,i))), Par,[],1);

            if 1%;Info.nShanks<3
                % enter channels by clicking at lowest and highest
                fprintf('Choose boundary channels \n');
                [xch ych b] = ginput(2);
                for l=1:2
                    [dd chi(l)] = min(abs(ChMap(:,1)-xch(l)).^2+abs(ChMap(:,2)-ych(l)).^2);
                end
                chi = sort(chi);
                out(compnum).UseChannels = Channels(chi);
                out(compnum).UseChannelsi = find(chi);
            else
                fprintf('now cluster the channels\n');
                in = ClusterPoints(ChMap,0);
                out(compnum).UseChannels = Channels(in);
                out(compnum).UseChannelsi = find(in);
            end
        end
        compnum=compnum+1;

    end %if good

end % loop over components
%    out.GoodComponents = GoodComponent;

if compnum==1
    out=[];
end
return