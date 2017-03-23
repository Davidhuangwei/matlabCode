function WaveformDiff(FileBase, Display, Overwrite)
[Electrodes,Display,Overwrite] = DefaultArgs(varargin,{[1:Par.nElecGps],0,0});
Par = LoadPar([FileBase '.par']);
eFs = GetEegFs(FileBase);
SampleRate = 1e6./Par.SampleTime;
if FileExists([FileBase '.par.1'])
    Par1 = LoadPar1([FileBase '.par.1']);
    SpkSamples = Par1.WaveSamples;
else
    SpkSamples=32; % correct if needs to be more general
end
fprintf('assuming 32 samples of the waveform\n');

States = {'REM','RUN','SWS'};
if ~FileExists([FileBase '.wdiff']) | Overwrite

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
        %[Fet, nFet] = LoadFet([FileBase '.fet.' num2str(el)]);
        Res = load([FileBase '.res.' num2str(el)]);
        Res = round(Res*1250/SampleRate);
        
        uClu = setdiff(unique(Clu),[0 1]);;

        %load only enough spike to sample all clusters
        % create represantative spikes sample for good cells
        avSpk =[]; stdSpk = [];SpatLocal=[];SpkWidthC=[];SpkWidthL=[];SpkWidthR=[];posSpk=[];FirRate = [];AvSpkAll=[];
        leftmax=[]; rightmax=[];troughamp=[];troughSD=[];
        for cnum=uClu

            for w = 1:length(States) %loop through states

                %load theta periods (more then MinPeriod)
                if w<3 %REM and RUN                    
                if FileExists([FileBase '.sts.' States{w}])
                    AllPeriod = load([FileBase '.sts.' States{w}]);
                    Period = AllPeriod(find(diff(AllPeriod,1,2)>eFs*MinPeriod),:);
                    Period = Period*pFs/eFs;
                else
                    fprintf('No %s periods. Return empty output\n',States{w});
                    continue;
                end
                if isempty(Period);
                    fprintf('No %s periods. Return empty output\n',States{w});
                    continue;
                end
                else
                    
                PeriodTime = sum(diff(Period,[],2))/pFs; % in seconds
                fprintf('\nFile %s has %2.1f seconds of %s \n',FileBase,PeriodTime,States{w});


                % get spike wavesdhapes and compute mean and std
                SampleSize = 1000;
                
                Focus = WithinRanges(Res, Period);
                Focus = Focus==1; % make it logical to use fast subscription

                myClu=find(Clu==cnum & Focus);
                                
                SampleSize = min(length(myClu),SampleSize);
                RndSample = sort(myClu(randsample(length(myClu),SampleSize)));
                mySpk = LoadSpkPartial([FileBase '.spk.' num2str(el)],length(Par.ElecGp{el}),SpkSamples,RndSample);

                avSpk(:,:,cnum) = sq(mean(mySpk, 3));
                stdSpk(:,:,cnum)  = sq(std(mySpk,0,3));% may not need it


                %find the channel of largest amp (positive or negative)
                [amps ampch] = max(abs(sq(avSpk(:,:,cnum))),[],2);
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


            end