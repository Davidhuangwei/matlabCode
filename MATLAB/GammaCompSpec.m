%function out =  GammaCompSpec(FileBase,fMode)
function out = GammaCompSpec(FileBase,varargin)

[fMode ] =DefaultArgs(varargin,{'computemany'});

Par = LoadPar([FileBase '.xml']);
States = {'REM','RUN'};

[repChannels,IfTetrode, Info] = RepresentChan(Par);
HpcChan = load([FileBase '.eegseg.par']); HpcChan =HpcChan(1)+1;
nCh = length(repChannels);
switch fMode
    case {'compute','computemany'}
        load([FileBase '.GammaComponents.mat']);
        gs = load([FileBase '.GammaSpecs.mat']);
        load([FileBase '.' mfilename '.mat']);
        smf = round(80/diff(gs.OutArgs.erppca(1).t(1:2))/1000);
        wcnt=1;
        %[eeg0 ] = LoadBinary([FileBase '.eeg'],HpcChan,Par.nChannels,2)';
        [eeg ] = LoadBinary([FileBase '.eeg'],repChannels,Par.nChannels,4)';
        
        %          if ~exist('mmap','var')
        % 					[ eeg mmap] = LoadBinary([FileBase '.lfp'],RepChannels(ch),Par.nChannels,5,[],[],Periods);
        % 					eeg = eeg';
        %                 else
        % 					[ eeg ] = LoadBinary(mmap,RepChannels(ch),Par.nChannels,5,[],[],Periods)';
        %                 end
        %
        for w = 1:length(States) %loop through states
            if ~FileExists([FileBase '.sts.' States{w}]) continue; end
            Period = load([FileBase '.sts.' States{w}]);
            %      eigvec = gs.OutArgs(wcnt).erppca(wcnt).eigvecr;
            nComps= length(OutArgs(wcnt).GoodComp);
            
            t= gs.OutArgs.erppca(w).t;
            f= gs.OutArgs.erppca(w).f;
            dt = diff(t(1:2));
            ts = round(t*Par.lfpSampleRate); % time in eeg sample rate of components
            
            %     tss = find(ismember(eegind,ts)); %samples of components in collapsed eeg samples
            switch fMode
                case 'compute'
                    
                    eegi = interp1([1:length(eeg0)],eeg0,ts);
                    
                    for k=1:nComps
                        
                        sfl = Filter0(gausswin(smf,1)/sum(gausswin(smf,1)),OutArgs(wcnt).Proj(:,k));
                        
                        [y,out(wcnt).f,phi,yerr] = mtptchd([eegi sfl],[],[],2^9,1/dt,2^8,[],2,'linear',[],[],[],[],0.01);
                        
                        out(wcnt).coh(:,k) = sq(y(:,1,2));
                        out(wcnt).phi(:,k) = sq(phi(:,1,2));
                        out(wcnt).pow(:,k) = sq(y(:,2,2));
                        out(wcnt).yerr(:,k) = sq(yerr(:,1,2,1));
                    end
                case 'computemany'
                    for ch=1:nCh
                        %eegi = interp1([1:size(eeg,1)],eeg(:,ch),ts);
                        eegi = eeg(ts,ch);
                        for k=1:nComps
                            
                            sfl = Filter0(gausswin(smf,1)/sum(gausswin(smf,1)),OutArgs(wcnt).Proj(:,k));
                            [y,out(wcnt).fall,phi] = mtchd([eegi sfl],2^8,1/dt,2^7,[],1,'linear');
                            out(wcnt).coha(:,k,ch) = sq(y(:,1,2));
                            out(wcnt).phia(:,k,ch) = sq(phi(:,1,2));
                            out(wcnt).powa(:,k,ch) = sq(y(:,2,2));
                        end
                    end
            end
            
            %ForAllSubplots('xlim([5 10])')
            
            %[y,f,t,phi]=mtchglong([eegi sfl],2^10,1250/16,2^9,[],3,'linear',[],[2 35]);
            %SpectralDistr(y,f,t,phi,[],[],30);
            
            %[y,f,phi]=mtchd([eegi OutArgs.Proj],2^10,1250/16,2^9,[],2,'linear',[],[2 35]);
            wcnt=wcnt+1;
        end
        save([FileBase '.' mfilename '.mat'],'out');
    case 'display'
        
        load([FileBase '.' mfilename '.mat']);
        gc = load([FileBase '.GammaComponents.mat']);
        for w = 1:length(out)
            figure(67334+w);clf
            nComp = size(out(w).coh,2);
            for p=1:nComp
                subplotfit(p,nComp);
                confplot(out(w).f, out(w).coh(:,p), out(w).yerr(:,p), out(w).yerr(:,p));
                ylim([0 1])
                oa =gca;
                na =axes('position',get(gca,'Position'));
                plot(out(w).f, mod(unwrap(out(w).phi(:,p)),2*pi)*180/pi,'r');
                ylim([0 360]);
                set(na,'Visible','off')
                set(gcf,'CurrentAxes',oa);
                title(gc.OutArgs(w).GoodComp(p).Location);
            end
        end
        
        
    case 'display_many'
        load([FileBase '.' mfilename '.mat']);
        gc = load([FileBase '.GammaComponents.mat']);
        for w = 1:length(out)
            
            if 1
                
                figure(67334+w);clf
                nComp = size(out(2).coh,2);
%                 for p=1:nComp
%                     subplotfit(p,nComp);
%                     imagesc(out(w).fall, [1:size(out(w).coha,3)], sq(out(w).coha(:,p,:))');
%                     title(gc.OutArgs(w).GoodComp(p).Location);
%                 end
%                 figure
                for p=1:nComp
                    subplotfit(p,nComp);
                    %[u s v] = svd(sq(out(w).coha(:,p,:)),0);
                    %MapSilicon(sign(mean(u(:,1)))*v(:,1),[],Par);
                    [~, fi] = max(mean(sq(out(w).coha(:,p,:)),2));
                    MapSilicon(sq(out(w).coha(fi,p,:)),[],Par,[],[],[],[],[],1);
                    title(sprintf('%s - %2.1f - %2.1f',gc.OutArgs(w).GoodComp(p).Location,gc.OutArgs(w).GoodComp(p).UseFreq,out(w).fall(fi)));
                   
                    
                end
                 suptitle(States{w})
            else
                
                f= gs.OutArgs.erppca(1).f;
                Channels = gs.OutArgs.Channels;
                nChannels = length(Channels); nf = length(f); nt = length(t);
                eigvec = gs.OutArgs.erppca(w).eigvecr;
                eigval = gs.OutArgs.erppca(w).eigval(:,4);
                
                [m maxi] = maxn(sq(eigvec(:,:,i)));
                [mfi mchi] = deal(maxi(1),maxi(2));
            end
            
        end
        
        return
        
        %t= gs.OutArgs.erppca(w).t;
        
        
        figure
        for k=1:17
            subplotfit(k,17);
            [u s v] = svd(sq(out(w).coha(:,k,:)),0);
            MapSilicon(sign(mean(u(:,1)))*v(:,1),[],Par);
            title([OutArgs(1).GoodComp(k).Location ' - ' num2str(OutArgs(1).GoodComp(k).UseFreq)] );
        end
        thi = find(abs(out.fall-6.5)<1);
        for k=1:17
            subplotfit(k,17);
            m= sq(mean(out.coha(thi,k,:)));
            MapSilicon(m,[],Par);
            title([OutArgs(1).GoodComp(k).Location ' - ' num2str(OutArgs(1).GoodComp(k).UseFreq)] );
        end
        figure
        for k=1:17
            subplotfit(k,17);
            m= angle(sq(mean(exp(1i*out.phia(thi,k,:)))));
            MapSilicon(m,[],Par,[],[],[-pi pi],1,[],1);
            title([OutArgs(1).GoodComp(k).Location ' - ' num2str(OutArgs(1).GoodComp(k).UseFreq)] );
        end
        
        
end



