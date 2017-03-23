function nq = NeuronQuality(FileBase, varargin)
%function NeuronQuality(FileBase, Electrodes,Display,Batch,Overwrite)

Par = LoadXml([FileBase '.xml']);

[Electrodes,Display,Batch,Overwrite] = DefaultArgs(varargin,{[1:Par.nElecGps],0,0,0});

if FileExists([FileBase '.NeuronQuality.mat']) & ~Overwrite
    return;
end

SampleRate = 1e6./Par.SampleTime;
% if FileExists([FileBase '.par.1'])
%     Par1 = LoadPar1([FileBase '.par.1']);
%     SpkSamples = Par1.WaveSamples;
% else
%     SpkSamples=32; % correct if needs to be more general
% end
SpkSamples = Par.SpkGrps(1).nSamples;

%fprintf('assuming 32 samples of the waveform\n');
GoodElectrodes=[];
for el=Electrodes
    Clu = LoadClu([FileBase '.clu.' num2str(el)]);
    nspk = FileLength([FileBase '.spk.' num2str(el)])/2/length(Par.ElecGp{el})/SpkSamples;
    if nspk ~= length(Clu)
        fprintf('%s - Electrode %d - length of spk file does not correspond to clu length\n\n',FileBase,el);
    else
        if max(Clu) > 1
            GoodElectrodes = [GoodElectrodes, el];
        end
    end
end
%GoodElectrodes
% for non-noise cluster do the rest
nq = struct;
for el=GoodElectrodes
    Clu = LoadClu([FileBase '.clu.' num2str(el)]);
    %Clu=Clu(2:end);
    %	[Fet, nFet] = LoadFet([FileBase '.fet.' num2str(el)]);

    Res = load([FileBase '.res.' num2str(el)]);

    uClu = setdiff(unique(Clu),[0 1]);;
%     nClu = length(uClu);
%     SpkCnt = Accumulate(Clu,
    
    %noise - comes from first 10000 spikes
    SpkNoise = LoadSpk([FileBase '.spk.' num2str(el)],length(Par.ElecGp{el}),SpkSamples,10000);
    stdSpkNoise =sq(std(SpkNoise,0,3));

    %load only enough spike to sample all clusters
    % create represantative spikes sample for good cells
    avSpk =[]; stdSpk = [];SpatLocal=[];SpkWidthC=[];SpkWidthL=[];SpkWidthR=[];posSpk=[];FirRate = [];AvSpkAll=[];
    leftmax=[]; rightmax=[];troughamp=[];troughSD=[];
    for cnum=uClu
        % get spike wavesdhapes and compute SNR
        SampleSize = 1000;
        myClu=find(Clu==cnum);

        if length(myClu)>1
            SampleSize = min(length(myClu),SampleSize);
            RndSample = sort(myClu(randsample(length(myClu),SampleSize)));
            mySpk = LoadSpkPartial([FileBase '.spk.' num2str(el)],length(Par.ElecGp{el}),SpkSamples,RndSample);

            avSpk(:,:,cnum) = sq(mean(mySpk, 3));
            stdSpk(:,:,cnum)  = sq(std(mySpk,0,3));% may not need it


            %find the channel of largest amp (positive or negative)
            [amps ampch] = max(abs(avSpk(:,:,cnum)),[],2);
            [dummy maxampch] = max(sq(amps));
            nch = length(Par.ElecGp{el});
            nonmax = setdiff([1:nch],maxampch);
            %compute spatial localization as ratio of max ch amplitude to the mean over all others.
            if nch>1
                SpatLocal(cnum) = amps(maxampch)/(mean(amps(nonmax))+eps);
            else
                SpatLocal(cnum) = 0;
            end
            myAvSpk = sq(avSpk(maxampch,:,cnum)); % largest channel spike wave for that cluster

            %now we need to take care of the positive spikes (we reverse them)
            minamp  = abs(min(myAvSpk));
            maxamp  = max(myAvSpk);
            %        if (minamp-maxamp)/minamp < 0.05 %(spike is more positive then negative)
            if maxamp>1.2*minamp %(spike is more positive then        negative)
                myAvSpk = -myAvSpk; %reverse the spike
                posSpk(cnum) = 1;
            else
                posSpk(cnum) = 0;
            end

            %now let's upsample the spike waveform
            ResCoef = 10; %                                                                 WAS CHANGED ON Aug.30 2005!!!!!!!!!!
            Sample2Msec = 1000./SampleRate/ResCoef; %to get fromnew samplerate to the msec
            myAvSpk = resample(myAvSpk,ResCoef,1);
            %keyboard
            %amphalf = mean(myAvSpk)-0.5*abs(min(myAvSpk-mean(myAvSpk)));

            [troughamp(cnum) troughTime] = min(myAvSpk);
            pts= myAvSpk(troughTime+[-5 0 5]);
            pts=pts(:);
            troughSD(cnum) = pts'*[1 -2 1]';
            amphalf = 0.5*min(myAvSpk);
            both=0;cnt=0;halfAmpTimes=[0 0];
            while both<2
                if myAvSpk(troughTime-cnt)>amphalf & halfAmpTimes(1)==0
                    halfAmpTimes(1)=troughTime-cnt;
                    both=both+1;
                end
                if myAvSpk(troughTime+cnt)>amphalf & halfAmpTimes(2)==0
                    halfAmpTimes(2)=troughTime+cnt;
                    both=both+1;
                end
                cnt=cnt+1;
            end
            %width

            %  		halfAmpTimes = LocalMinima(abs(myAvSpk-amphalf));%,5,0.5*amphalf);
            %  		halfAmpTimes = halfAmpTimes(find(halfAmpTimes-troughTime)<0.
            %  		if length(halfAmpTimes>2)
            %  			val = myAvSpk(halfAmpTimes);
            %  			[dummy ind] = sort(val);
            %  			halfAmpTimes = halfAmpTimes(ind(1:2));
            %  		end
            %  		SpkWidthC(cnum) = abs(diff(halfAmpTimes))*Sample2Msec; % this is width on the hald amplitude
            %
            SpkWidthC(cnum) = diff(halfAmpTimes)*Sample2Msec;


            %dmyAvSpk = diff(myAvSpk);
            SpkPieceR = myAvSpk(troughTime:end);
            [rightmax(cnum) SpkWidthR(cnum)] = max(SpkPieceR); % this is the distance from the trough to the rise peak
            SpkWidthR(cnum)= SpkWidthR(cnum)*Sample2Msec;

            SpkPieceL = myAvSpk(1:troughTime);
            SpkPieceL = flipud(SpkPieceL(:)); % to look at the right time lag
            [leftmax(cnum) SpkWidthL(cnum)] = max(SpkPieceL); % this is the distance from the peak to the trough
            SpkWidthL(cnum)= SpkWidthL(cnum)*Sample2Msec;

            troughTime = troughTime*Sample2Msec;
            if posSpk(cnum);	myAvSpk = -myAvSpk; end
            AvSpkAll(cnum,:) = myAvSpk;

            if Display
                figure(765)
                if cnum==2
                    clf;
                end
                subplotfit(cnum-1,length(uClu));
                shift = troughTime;%SpkSamples/2*Sample2Msec;
                plot([1:SpkSamples*ResCoef]*Sample2Msec-shift,myAvSpk);
                axis tight
                hold on
                Lines(0,[],'g');%trough line
                Lines(halfAmpTimes*Sample2Msec-shift,amphalf,'r');
                Lines(SpkWidthR(cnum),[],'r');
                Lines(-SpkWidthL(cnum),[],'r');
                %Lines([-SpkWidthL SpkWidthR], troughamp,'r');
                mystr = sprintf('El=%d Clu=%d',el,cnum);
                title(mystr);
            end
            %keyboard

            % firing rate
            myRes = Res(find(Clu==cnum));
            ISI = diff(myRes);
            MeanISI = mean(bootstrp(100,'mean',ISI));
            FirRate(cnum) = SampleRate./MeanISI;
        end

    end

    if Display
        if ~Batch
            pause
        else
            reportfig(gcf,'NeuronQuality',0,[FileBase ',El=' num2str(el)],70);
        end
        figure(765); clf
    end

    snr = sq(mean(mean(abs(avSpk),1),2))./mean(stdSpkNoise(:));
    %		Out = [CluNo, eDist, bRat,Refrac]
    Fp = fopen([FileBase '.fet.' num2str(el)], 'r');
    nFet = fscanf(Fp, '%d', 1);
    fclose(Fp);

    clear mySpk SpkNoise Res Clu;
    FQOut= FileQuality(FileBase, el, SampleRate/1000*20, [1:nFet-5], SampleRate*2/1000,0);
    nq(el).SNR = snr(2:end);
    nq(el).SpkWidthC = SpkWidthC(2:end)';
    nq(el).SpkWidthR = SpkWidthR(2:end)';
    nq(el).SpkWidthL = SpkWidthL(2:end)';
    %fix for empty clusters
    SpkWidthL(SpkWidthL==0)=1000000;
    nq(el).TimeSym = SpkWidthR(2:end)'./SpkWidthL(2:end)';
    nq(el).eDist = FQOut(:,2);
    nq(el).bRat = FQOut(:,3);
    nq(el).Refrac = FQOut(:,4);
    nq(el).Clus = FQOut(:,1);
    nq(el).ElNum = repmat(el,length(uClu),1);
    nq(el).IsPositive = posSpk(2:end)';
    nq(el).SpatLocal=SpatLocal(2:end)';
    nq(el).FirRate = FirRate(2:end)';
    nq(el).AvSpk = AvSpkAll(2:end,:);
    nq(el).RightMax= rightmax(2:end)';
    nq(el).LeftMax= leftmax(2:end)';
    nq(el).CenterMax= troughamp(2:end)';
    %fix for empty clusters
    rightmax(rightmax==0)=1e6;
    leftmax(leftmax==0)=1e6;
    nq(el).AmpSym = (abs(rightmax(2:end))'-abs(leftmax(2:end))')./(abs(rightmax(2:end))'+abs(leftmax(2:end))');
    nq(el).troughSD = troughSD(2:end)';
    %keyboard

end

if nargout<1
    OutArgs =nq;
    save([FileBase '.NeuronQuality.mat'],'OutArgs');
end


%save([FileBase '.nq'],'nq');
