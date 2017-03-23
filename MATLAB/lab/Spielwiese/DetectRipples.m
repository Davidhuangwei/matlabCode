%function Rips = DetectRipples(FileBase, Channels, FreqRange, Threshold, eSampleRate, Mode, Overwrite)
% gives out the structure: Rip.t - time of the ripple (eeg sampling rate),
% Rip.len = length is msec, Rip.pow - power of the ripple
function Rips = DetectRipples(FileBase, varargin)

[Channels, FreqRange, Threshold,  Mode, Overwrite] = DefaultArgs(varargin,{[],[100 250], 5, 'long',1});
if isempty(Channels)
    if FileExists([FileBase '.eegseg.par'])
        Channels = load([FileBase '.eegseg.par']);
        Channels = Channels(1)+1;
    else
        error('Channels not specified');
    end
end


if ~FileExists([FileBase '.spw']) | Overwrite
    
    Par = LoadPar([FileBase '.xml']);
    eSampleRate = Par.lfpSampleRate;
    spw = sdetect_a([FileBase '.eeg'],Par.nChannels,Channels,FreqRange(end),FreqRange(1),Threshold, 0, eSampleRate);

    if strcmp(Mode,'long') & ~isempty(spw)

        seglen = max(spw(:,3)-spw(:,1));
        seglen = seglen + mod(seglen,2);
        eeg = LoadBinary([FileBase '.eeg'],Channels(1),Par.nChannels)';
        [seg complete] = GetSegs(eeg,spw(:,2)-seglen/2,seglen,[]);
        seg = sq(seg);
        pow = FirFilter(seg,2,[120 230]/(eSampleRate/2),'bandpass');
        Rips.pow = mean(abs(pow),1)';

        Rips.t = spw(complete,2);
        Rips.len = (spw(complete,3)-spw(complete,1))*1000./eSampleRate;

        msave([FileBase '.spw'],[Rips.t Rips.pow(:) Rips.len(:)]);
        MakeEvtFile(Rips.t(:), [FileBase '.rip.evt'],'rip',eSampleRate,1);
    end

else
  
  Rips = load([FileBase '.spw']);
  
end

return;