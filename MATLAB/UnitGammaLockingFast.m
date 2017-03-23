function Out = UnitGammaLockingFast(FileBase,varargin)
% Computes Phase locking of Units to Gamma (including time lagging)
%%   Out = UnitGammaLocking(FileBase,fMode,States,GamBins,SpkShift, MinSpikes)
%   fMode: 'compute' (default)
%          'display' (show results)
%   States: cell array. eg. {'REM';'RUN';'SWS'}
%   GamBins: default is gBins=bsxfun(@plus, [15:3:200]',[-10 10]);
%   SpkShift: spike shift in LFP samples
% NB: this one takes a lot of memory, so make sure you have enough!
gBins=bsxfun(@plus, [15:3:200]',[-10 10]);
[fMode,States,GamBins,SpkShift, MinSpikes]           = DefaultArgs(varargin,...
    {'compute',{'REM';'RUN';'SWS'},gBins,[-60:5:60],50});

nStates=length(States);

nSpkShift=length(SpkShift);

Par=LoadPar(FileBase);
RepChannels = RepresentChan(Par);
nChannels = length(RepChannels);

nGamBins=length(GamBins) ;
f=mean(GamBins,2);

switch fMode
    case 'compute'
        
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
            
            
            %new efficient way to map file once and reuse the map on
            %all next iterations
            if ~exist('mmap','var')
                [ eeg mmap] = LoadBinary([FileBase '.lfp'],RepChannels,Par.nChannels,5,[],[],Periods);
                eeg = eeg';
            else
                [ eeg ] = LoadBinary(mmap,RepChannels,Par.nChannels,5,[],[],Periods)';
            end
            %  toc;
            FiltOpt = 1;
            for gg=1:nGamBins
                switch FiltOpt
                    case 1
                        feeg=ButFilter(eeg,2,GamBins(gg,:)/(Par.lfpSampleRate/2),'bandpass');
                        H=hilbert(feeg);
                        clear feeg
                    case 3
                        H = MWFilter(eeg, mean(GamBins(gg,:)), 5);
                end
                
                % Rph(ch,gg,kk,uu) = channels x freq x shift x unit
                % same thing vectorized for all ch but many cells and time lags.
                Amp = abs(H);
                ExpPh = H./Amp;
                Out(st).Rph(gg,:,:,:) = TriggeredAv(ExpPh, SpkShift, T, G);
                
                TrigH = TriggeredAv(H, SpkShift, T, G);
                TrigPow = TriggeredAv(Amp,SpkShift, T, G);
                Out(st).Rhlb(gg,:,:,:) = TrigH./TrigPow;
                
                fprintf('%s Freq Bin %d - %d Hz \n',States{st},GamBins(gg,1),GamBins(gg,2));
                
                %fprintf('State %s, Channel %d took %4.1f min\n',States{st}, ch, toc/60);
            end
            Out(st).CompTime = toc;
            fprintf('%s took %f sec \n',States{st},Out(st).CompTime);
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
        for st=1:3
            
            for cell=1:size(Out(st).Map,1)
                figure(9999);clf
                ny=1;nx=2;
                subplot2(ny,nx, 1,1);
                
                mat = sq(Out(st).Rph(chi,fi,zbin,cell));
                imagesc(f, [1:nChannels], abs(mat));
                
                peakfi = 13;
                
                subplot2(ny,nx, 1,2);
                
                mat = sq(Out(st).Rph(chi,fi(peakfi),:,cell));
                imagesc(Out(st).t,[1:nChannels],(abs(mat)')');
                title([States{st} ' , cell ' num2str(cell)]);
                waitforbuttonpress
            end;end
        
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

