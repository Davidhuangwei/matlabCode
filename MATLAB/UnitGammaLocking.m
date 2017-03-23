function Out = UnitGammaLocking(FileBase,varargin)
% Computes Phase locking of Units to Gamma (including time lagging)
%%   Out = UnitGammaLocking(FileBase,fMode,States,GamBins,SpkShift, MinSpikes, Extension)
%   fMode: 'compute' (default)
%          'display' (show results)
%   States: cell array. eg. {'REM';'RUN';'SWS'}
%   GamBins: default is gBins=bsxfun(@plus, [15:3:200]',[-10 10]);
%   SpkShift: spike shift in LFP samples

%FileBaseIn = ResolvePath(FileBase);

gBins=bsxfun(@plus, [15:3:200]',[-10 10]);
[fMode,States,GamBins,SpkShift, MinSpikes, Extension]           = DefaultArgs(varargin,...
{'compute',{'REM';'RUN';'SWS'},gBins,[-60:5:60],50, 'lfp'});

nStates=length(States);

nSpkShift=length(SpkShift);

Par=LoadPar([FileBase '.xml']);
RepChannels = RepresentChan(Par);
nChannels = length(RepChannels);

nGamBins=length(GamBins) ;
f=mean(GamBins,2);

switch fMode
    case {'compute', 'computefast','computeparallel'}
        
        if strcmp(fMode,'computeparallel')
            if matlabpool('size')==12
                warning('matlab pool already opened');
            else
                matlabpool open local 12
            end
        end
        
        if FileExists([FileBase '.' mfilename '.mat'])
            load([FileBase '.' mfilename '.mat']);
        end
        
        [Res Clu Map]=LoadCluRes(FileBase);
        nClu = max(Clu);
        Res=round(Res*Par.lfpSampleRate/Par.SampleRate);  % bring it to LFP sampling rate
        
        for st=1:nStates
            
            Periods = SelectStates(FileBase, States{st});
            if isempty(Periods)
                continue;
            end
            tic;
            Out(st).FileBase=FileBase;
            Out(st).State=States{st};
            Out(st).f = f';
            Out(st).t = SpkShift(:)*1000/Par.lfpSampleRate; %time lag in msec
            Out(st).Channels = RepChannels;
            %TODO: test for available RAM or break down in chunks
            %let's load all channels and hope there is enough RAM
            %eeg=LoadBinary([FileBase '.lfp'],gch,Par.nChannels,3,[],[],Periods)';
            
            %get spikes inside Periods
	   
			%redefine Periods to take Shifts into account (so that we don't get negative index)
			SafePeriods = bsxfun(@plus,Periods, [SpkShift(end) SpkShift(1)]);
														   
            InStatePeriod = logical(WithinRanges(Res,SafePeriods)); %need to remove shift-compromised periods
            
            G = Clu(InStatePeriod);
            T = SelectPeriods(Res(InStatePeriod),Periods,'d',1,1); %need tot use the same Periods as for LoadBinary as we are squashing gaps between Periods      
            
            
            % find how many spikes we have from G
            cntSpksG =  accumarray(G,1,[nClu 1],@sum,0);
            
            % select clusters with enough spikes
            GoodG  = find(cntSpksG > MinSpikes);
            nGoodG=length(GoodG);
            Out(st).Map = Map(GoodG,:);
            Out(st).nSpikes = cntSpksG(GoodG);
            
            ChInd = 1;
            Rph = nan(length(RepChannels), length(Out(1).f), length(Out(1).t), length(GoodG));
            Rhlb = nan(length(RepChannels), length(Out(1).f), length(Out(1).t), length(GoodG));
            AvPow = nan(length(RepChannels), length(Out(1).f), length(Out(1).t), length(GoodG));
            while ChInd <= length(RepChannels)
                
                    if ~strcmp('fMode','computefast') 
                        LoadChannels = RepChannels(ChInd);
                    else
                        LoadChannels = RepChannels;
                        ChInd = [1:length(RepChannels)];
                    end
                    if ~exist('mmap','var')
                        [ eeg, mmap] = LoadBinary([FileBase '.' Extension],LoadChannels,Par.nChannels,5,[],[],Periods);
                        eeg = eeg';
                    else
                        [ eeg ] = LoadBinary(mmap,LoadChannels,Par.nChannels,5,[],[],Periods)';
                    end
                    
                    
                    FiltOpt = 1; 
                    
                    parfor gg=1:nGamBins
                        switch FiltOpt
                            case 1
                                feeg=ButFilter(eeg,2,GamBins(gg,:)/(Par.lfpSampleRate/2),'bandpass');
                                H=hilbert(feeg);
                            case 3
                                H = MWFilter(eeg, mean(GamBins(gg,:)), 5);
                        end
                   
                        Amp = abs(H);
                        ExpPh = H./Amp;
                        AvExpPh = TriggeredAv(ExpPh, SpkShift, T, G);
                        TrigH = TriggeredAv(H, SpkShift, T, G);
                        TrigPow = TriggeredAv(Amp,SpkShift, T, G);
      
                        % Rph(ch,gg,kk,uu) = channels x freq x shift x unit 
                        % in case of multiple channels version (fast and
                        % parfor AvExpPh is shift x channel x unit, so need
                        % to reshape
                        if ~strcmp('fMode','computefast')
                            Rph(ChInd,gg,:,:) = AvExpPh(:,GoodG);
                            Rhlb(ChInd,gg,:,:) = TrigH(:,GoodG)./TrigPow(:,GoodG);
                            AvPow(ChInd,gg,:,:) = TrigPow(:,GoodG);
                        else
                            Rph(ChInd,gg,:,:) = permute(shiftdim(AvExpPh(:,:,GoodG),-1), [3 1 2 4]);
                            Rhlb(ChInd,gg,:,:) = permute(shiftdim(TrigH(:,:,GoodG)./TrigPow(:,:,GoodG),-1), [3 1 2 4]);
                        end
                    end
                    
                if ~strcmp('fMode','computefast')
                    ChInd=ChInd+1;
                else
                    break;
                end
                    
                %fprintf('State %s, Channel %d took %4.1f min\n',States{st}, ch, toc/60);
            end
            Out(st).Rph = Rph;
            Out(st).Rhlb = Rhlb;
            Out(st).AvPow = AvPow;
            Out(st).CompTime = toc;
            fprintf('%s took %f sec \n',States{st},Out(st).CompTime);
        end
         if strcmp(fMode,'computeparallel')
            matlabpool close
         end
         
        save([FileBase '.' mfilename '.' Extension '.mat'],'Out','-v7.3')
        
    case 'fixbug1'
        load([FileBase '.' mfilename '.mat']);
       
        if size(Out(1).Map,1) == size(Out(1).Rph,4)
            fprintf('this files seems ok, skipping fix');
            return
        end
        [Res Clu Map]=LoadCluRes(FileBase);
        nClu = max(Clu);
        Res=round(Res*Par.lfpSampleRate/Par.SampleRate);  % bring it to LFP sampling rate
        
        for st=1:length(Out)
            Periods = SelectStates(FileBase, Out(st).State);
            if isempty(Periods)
                continue;
            end
            %redefine Periods to take Shifts into account (so that we don't get negative index)
            SafePeriods = bsxfun(@plus,Periods, [SpkShift(end) SpkShift(1)]);
            InStatePeriod = logical(WithinRanges(Res,SafePeriods)); %need to remove shift-compromised periods
            
            G = Clu(InStatePeriod);
            T = SelectPeriods(Res(InStatePeriod),Periods,'d',1,1); %need tot use the same Periods as for LoadBinary as we are squashing gaps between Periods
            % find how many spikes we have from G
            cntSpksG =  accumarray(G,1,[nClu 1],@sum,0);
            % select clusters with enough spikes
            GoodG  = find(cntSpksG > MinSpikes);
            Out(st).Rph = Out(st).Rph(:,:,:,GoodG);
            Out(st).Rhlb = Out(st).Rhlb(:,:,:,GoodG);
       end
       save([FileBase '.' mfilename '.mat'],'Out','-v7.3')
        
    case 'display'
        load([FileBase '.' mfilename '.mat']);
        Par = LoadXml([FileBase '.xml']);
        RepCh = RepresentChan(Par);
        nChannels = length(RepCh);
        %(chanel,freq,shift,unit)
        
        zbin = (length(Out(1).t)-1)/2+1;
        minFreq = 25;
        fi = find(Out(1).f > minFreq); f=Out(1).f(fi);
        chi = ismember(Channels,RepCh);%temp fix
        
        st=1;
      %  for st=1:3
            
            for cell=1:size(Out(st).Map,1)
                figure(9999);clf
                ny=1;nx=2;
                subplot2(ny,nx, 1,1);
                
                mat = sq(Out(st).Rph(chi,fi,zbin,cell));
                imagesc(f, [1:nChannels], abs(mat));
                
            %    [~ peakfi] = 
                
                subplot2(ny,nx, 1,2);
                
                mat = sq(Out(st).Rph(chi,fi(peakfi),:,cell));
                imagesc(Out(st).t,[1:nChannels],(abs(mat)')');
                title([States{st} ' , cell ' num2str(cell)]);
                waitforbuttonpress
            end;
    %end
    
%         subplot2(ny,nx, 1,3);
%         
%         mat = sq(Out(st).Rph(20,fi,:,cell));
%         imagesc(t,f,
%         
        fi = Out(2).f>25;
% figure
% for w=1:3
%     clf
%     for k=1:size(Out(w).Map,1)
%         subplotfit(k,size(Out(w).Map,1));
%         imagesc(Out(w).f(fi),[1:81],abs(sq(Out(w).Rph(:,fi,13,k))));
%     end
%     pause
% end

        
        
end
                          % compute MI
%                             nbins = 18;
%                             phedges = linspace(-pi,pi,nbins+1);
%                             phbins = (phedges(1:end-1)+phedges(2:end))/2;
%                             hst = hist(ph, phbins);
%                             hst = bsxfun(@mrdivide, hst, sum(hst));
%                             Hpow = -sum(hst.*log(hst));
%                             Hmax = log(nbins);
%                             Out(st).MI(ch,gg,kk,uu) = (Hmax-Hpow)/Hmax;
return


figure(3232);
for c=1:size(Out.Map,1)
    %if Out.Map(c,2)<9 continue;end
    clf
    mych = cluloc(Out.Map(c,1),3);
    myshch = ismember(Out.Channels, Par.SpkGrps(Out.Map(c,2)).Channels+1);
    lag = [10 13 16];
    Fld = 'Rph';
    
    for k=1:3
        subplot(2,2,k)
        mat = abs(sq(Out.(Fld)(:,:,lag(k),c)));
        maxR= max(reshape(abs(sq(Out.(Fld)(~myshch,:,:,c))),[],1));
        minR= min(reshape(abs(sq(Out.(Fld)(~myshch,:,:,c))),[],1));
        p = r2pval(mat,Out.nSpikes(c));
        
        mat(myshch,:) = NaN;
        if 1
            Val = ones(size(mat))*0.3;
            Val(p<0.1)=0.5;
            Val(p<0.01)=0.8;
            Val(p<0.001)=1;
            imagescnan({Out.f,[1:length(Out.Channels)],mat},[0 maxR], 0,1,[],[],Val);
        else
            mat(p(:)>0.05)=NaN;
            imagesc(Out.f,[1:length(Out.Channels)],mat); 
            caxis([0 maxR]); 
            colorbar
        end
        title(num2str(Out.t(lag(k))));
    end
    subplot(224)
    imagesc(Out.f,Out.t,abs(sq(Out.(Fld)(mych,:,:,c)))'); colorbar
    title(['Cell ' num2str(Out.Map(c,2:3)) ' , n=' num2str(Out.nSpikes(c))]);

    waitforbuttonpress;
end




