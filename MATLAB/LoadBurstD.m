function [FeatData, FeatTitle] = LoadBurstD(FileBase, par, varargin)
%LoadBurstData is a function which loads burst data merged across shanks without repetitions.
%For single shank sessions it loads corresponding single shank burst data.
%The following features of bursts can be loaded:
% 'BurstTime', 'BurstFreq', 'BurstChan', 'BurstTimeIndex', 'BurstFreqIndex', 'BurstChanIndex', 'BurstShank', 'BurstnShanks',
% 'BurstPower', 'BurstPhase', 'BurstFreqSpan', 'BurstTimeSpan', 'BurstChanSpan', 'RefinedBurstTime'
% where:
% BurstShank   - index of a shank on which the burst was detected or, for multiple shank data, on which the burst had maximum power.
% BurstnShanks - the number of shanks on which the burst appeared at the same time and frequency.
% BurstPower   - is a power of the burst or, for multiple shank data, the maximum power across shanks.
%For multishank data, all other features correspond to the burst with maximum power across shanks.
%
%
%USAGE: [FeatData, <FeatTitle>] = LoadBurstData(FileBase, <SignalType>, <PeriodTitle>, <Feat2Load>)
%
%INPUT:
% FileBase       is a name of the session (AnimalID-YYYMMDD).
% <SignalType>   is a type of signal used for spectrogram calculation ('lfp' or 'csd'). Default='lfp.'
% <Channels> is a vector with numbers of channels from Buz32 probe. Default = 65:96.
% <PeriodTitle>   is a name of the behavioral state  in which burst must be detected. Default = 'RUN'.
%
%OUTPUT:
%
%EXAMPLE: 
% Load all features             [FeatData, FeatTitle] = LoadBurstData(CurrentFileBase, 'lfpinterp', 'RUN', [] )
% Load the specified features   [FeatData, ~] = LoadBurstData(CurrentFileBase, 'lfpinterp', 'RUN', {'BurstFreq', 'BurstChan', 'BurstnShanks', 'BurstShank'} )
%
% Evgeny Resnik
% version 11.03.2014



% FileBase = CurrentFileBase
% SignalType = 'lfpinterp';
% PeriodTitle = 'RUN';
% mfilename = 'LoadBurstData';
% Feat2Load = {'BurstTime', 'BurstFreq',  'BurstTimeSpan' };




if nargin<1
    error(['USAGE:  [FeatData, <FeatTitle>] = LoadBurstData( FileBase, <SignalType>, <PeriodTitle>, <Feat2Load>)'])
end


% Parse input parameters
[SignalType, PeriodTitle, Feat2Load] = DefaultArgs(varargin,{ 'lfpinterp', 'RUN', [] });


FileIn = sprintf(['%s.sts.%s'], FileBase, PeriodTitle);
if ~exist(FileIn,'file')
    fprintf('File %s not found! Skipped.\n', FileIn)
    return
end


%-----------------------------------------------------------------------------%
%Load LFP sampling rates from .xml file
% par = LoadXml([FileBase '.xml']);
lfpSamplingRate = par.lfpSampleRate;
nChan = par.nChannels;


%Load channels with LFP depth profile (Buz32 probe)
ChanRanges = LoadMyPar(FileBase, 'LfpDepthProfileChannels');
if rem(length(ChanRanges), 2) %even
    error(sprintf('Field "LfpDepthProfileChannels" in the file %s.mypar must contain the even number of entries!', FileBase))
end
nShanks = length(ChanRanges)/2;
ChanRanges = reshape(ChanRanges',2,[])';

%Define channels depending on the number of shanks
if nShanks==1
    Channels = ChanRanges(1,1): ChanRanges(1,2);
else
    Channels = 1: nChan;
end


if isempty(Feat2Load)
    Feat2Load = {'BurstTime', 'BurstFreq', 'BurstChan', 'BurstTimeIndex', 'BurstFreqIndex', 'BurstChanIndex', 'BurstShank', 'BurstnShanks' ...
        'BurstPower', 'BurstPhase', 'BurstFreqSpan', 'BurstTimeSpan', 'BurstChanSpan', 'RefinedBurstTime', 'BurstLayer' };
end


%Index of the CA1pyr channel with theta phase
InputPhFile = sprintf('%s.%s', FileBase, 'thpar.mat');
% InputPhFile = ResolvePath(InputPhFile, 0);
load(InputPhFile, 'ThPh', 'Params');
ThChan = Params.Channel;


%-----------------------------------------------------------------------------%
%Load coordinates of LFP bursts
InputBurstFile = sprintf(['%s.%s.%s.%s.%d-%d'], FileBase, 'SelectBursts3', SignalType, PeriodTitle, Channels([1 end])  );
load([InputBurstFile '.mat'], 'BurstTime', 'BurstFreq', 'BurstChan', 'BurstTimeIndex', 'BurstFreqIndex', 'BurstChanIndex');
if nShanks>1
   load([InputBurstFile '.mat'], 'BurstShank', 'BurstnShanks');
end


%Load power of LFP bursts
InputPowerFile = sprintf(['%s.%s.%s.spec-%s.%s.%d-%d'], FileBase, 'GammaBurstPower3', SignalType, SignalType, PeriodTitle, Channels([1 end])  );
load([InputPowerFile '.mat'], 'BurstPower');

%Load theta phase of LFP bursts
% CA1pyrChan = LoadMyPar(FileBase, 'CA1pyrChannel');
InputPhaseFile = sprintf(['%s.%s.%s.ThChan%d.%s.%d-%d'], FileBase, 'GammaBurstThetaPhase3', SignalType, ThChan, PeriodTitle, Channels([1 end])  );
load([InputPhaseFile '.mat'], 'BurstThPh');
BurstPhase = BurstThPh; clear BurstThPh

%Load channel span of LFP bursts
InputSpanFile = sprintf(['%s.%s.%s.%s.%d-%d.mat'], FileBase, 'GammaBurstSpan3', SignalType, PeriodTitle, Channels([1 end])  );
load(InputSpanFile, 'BurstFreqSpan', 'BurstTimeSpan', 'BurstChanSpan', 'RefinedBurstTime');


% %Load indices of matching burst if multishank data
% if nShanks>1
%     InputMatchFile = sprintf(['%s.%s.%s.%s.%d-%d'], FileBase, 'MatchedBurstsAcrossShanks', SignalType, PeriodTitle, [1 nChan]);
%     fprintf(['Loading indices of matching across sanks burst from %s.mat ...'], InputMatchFile)
%     load([InputMatchFile '.mat'],  'MatchingBurstIndex','MatchingBurstShanks', 'MatchingBurstLayer', 'nMatchingShanks');
%     fprintf('DONE\n')
% end


%Load representative channels for each anatomical layer
InputLayerFile = sprintf(['%s.%s.%d-%d.txt'], FileBase, 'AnatLayers', [1 nChan] );
[AnatLayerTitle, AnatLayerChan, AnatLayerRepChan ] = LoadAnatLayers2(InputLayerFile);
%Discard layers not represented on the given shank
for l=1:length(AnatLayerChan)
    BadLayers(l) = ~any(ismember(AnatLayerChan{l}, Channels));
    AnatLayerBorder(l,:) = [min(AnatLayerChan{l})  max(AnatLayerChan{l})];
end
AnatLayerTitle(BadLayers)    = [];
AnatLayerChan(BadLayers)     = [];
AnatLayerRepChan(BadLayers)  = [];
AnatLayerBorder(BadLayers,:) = [];
clear BadLayers l


%-----------------------------------------------------------------------------%
nBursts = length(BurstTime);
nLayers = length(AnatLayerTitle);


%Create a vector of anat. layers for all bursts
BurstLayer = cell(1,nBursts);
for l=1:nLayers
    ind = ismember(BurstChan, AnatLayerChan{l});
    BurstLayer(ind) = AnatLayerTitle(l);
end
ind2 = cellfun(@isempty, BurstLayer);
%replace empty cells with 'out' to avoid errors using strcmp later on
BurstLayer(ind2) = {'out'};
clear l ind ind2


for n=1:length(Feat2Load)
    
    if ismember(Feat2Load{n}, {'BurstShank', 'BurstnShanks'} ) & nShanks==1
        warning(sprintf('Feature "%s" is present only in multishank data sets!',Feat2Load{n} ))
        FeatData{n}=[];
        continue
    end

    if ~exist(Feat2Load{n}, 'var')
        warning(sprintf('Feature "%s" not found in the data file!',Feat2Load{n} ))
        FeatData{n}=[];
        continue
    end
    
    eval(['FeatData{n}=' Feat2Load{n} ';']);    
    
end %loop across features to load


FeatTitle = Feat2Load;












