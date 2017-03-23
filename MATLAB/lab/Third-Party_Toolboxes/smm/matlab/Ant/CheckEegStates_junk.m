function CheckEegStates(FileBase,varargin)
% function CheckEegStates(FileBase,State, AuxData,FreqRange,Channel,nChan,fileExt,Window, Action, Overwrite)
% starts the gui for browsing through spectral representation of the eeg and
% segmenting into states .. has lot's of features - try it. to speed up
% precompute the spectrograms using EegSegmentation function. 
% if no Channels are specified, and you didn't create FileBase.eegseg.par
% file with channels (starting from 0) that you want to use, it will start
% a dialog, which runs away under new version of matlab ..don't know why.
% Window - in sec size of the spectral window
% FreqRange =[Fmin Fmax] - range of freq over which the spectrum will be
% computed
% AuxData may contain the additional data to plot
% AuxData has to be cell array where each row is : xaxis, yaxis, data, display_func
% obviously the xaxis (time) has to match the full time of the file, and be in the
% same units as spectrogram - seconds
% so far display_func is 'plot' and 'imagesc'
% in case of 'plot' the yaxis can be empty. 

[State,AuxData,FreqRange,Channels,nChan,fileExt,Window,Action, Overwrite] = ...
    DefaultArgs(varargin,{[],[],[1 100],[],[],'.eeg',1,'display',0});

% auxil. struct for gui
global gCheckEegStates
gCheckEegStates = struct;

%constants
UseRulesBefore = 0; % flag to switch heuristics for periods cleaning after automatic segmentation
MinLen=5; %seconds

Par = LoadPar([FileBase '.xml']);

if isfield(Par,'lfpSampleRate')
    eSampleRate = Par.lfpSampleRate;
else
    eSampleRate = 1250;
end

if ~isempty(State)
    % load segmentation results
    if FileExists([FileBase '.sts.' State])
        Per = load([FileBase '.sts.' State]);
%     elseif FileExists([FileBase '.states.res'])
%         Per = SelectStates(FileBase,State,eSampleRate*MinLen);
    else
        Per = [];
    end       
    if isempty(Per)
        fprintf('No segments detected in %s state\n',State)
        %return;
        Per = [];
    end
else
    Per = [];
    State = '';
end

if isempty(Channels) & FileExists([FileBase fileExt 'seg.par']);
    Channels = load([FileBase fileExt 'seg.par'])+1;
    %         Channels = GetChannels(FileBase, {{'h','c'}});
end
if ~isempty(Channels) & ~FileExists([FileBase fileExt 'seg.par']);
    fprintf('You selection of Channels is stored in the file %s for future usage, so that next time you don''t have to pass Channels\n',...
        [FileBase fileExt 'seg.par']);
    msave([FileBase fileExt 'seg.par'],Channels-1);
end
Compute=0;
if FileExists([FileBase fileExt 'seg.mat'])
    switch Action
        case 'display'
            over = questdlg('Do you want to overwrite existing spectrogram?','Overwrite');
            switch over
                case 'No'
                    load([FileBase fileExt 'seg.mat']); % load whitened spectrograms from EegSegmentation results
                case 'Yes'
                    Compute=1;
            end
        case 'compute'
            if Overwrite
                Compute=1;
            else
                return;
            end
    end
end
%keyboard
if ~FileExists([FileBase fileExt 'seg.mat']) | Compute==1

    if isempty(Channels)
        ch = inputdlg({'Enter channels to use'},'Channels',1,{'1'});
        Channels = str2num(ch{1});
    end
 
    % now compute the spectrogram
    if FileExists([FileBase fileExt])
        try 
            Eeg = LoadBinary([FileBase fileExt], Channels,nChan,4)';
        catch
            Eeg = LoadBinary([FileBase fileExt], Channels,nChan,2)';
        end
    elseif FileExists([FileBase fileExt '.0'])
        Eeg = bload([FileBase fileExt '.0'],[1 inf]);
        
    else
        error(['no ' fileExt ' file or ' fileExt '.0 file! \n']);
    end
    %nFFT = 2^round(log2(2^11)); %compute nFFT according to different sampling rates
    SpecWindow = 2^round(log2(Window*eSampleRate));% choose window length as power of two
    nFFT = SpecWindow*4;
     weeg = Eeg; 
%     weeg = WhitenSignal(Eeg,eSampleRate*2000,1);
    [y,f,t]=mtcsglong(weeg,nFFT,eSampleRate,SpecWindow,[],1.5,'linear',[],FreqRange);
%     y = Conv2Trim(ones(5,1)/5,1,y);
    save([FileBase fileExt 'seg.mat'],'y','f','t','Channels','-v6');
end

if strcmp(Action,'compute')
    return;
end
t = (t(2)-t(1))/2 +t;
   
% computer the/del ratio and detect transitions automatically - not used at
% the momnet, maybe later
%[thratio] = TDRatioAuto(y,f,t,MinLen);
%[thratio, ThePeriods] = TDRatioAuto(y,f,t,MinLen);

%now apply the rules to filter out junk states or make continuous periods
% to be implemented later
if UseRulesBefore
    switch State
        case 'REM'

    end
end

% fill the global structure for future use

if ~FileExists([FileBase fileExt]) & FileExists([FileBase fileExt '.0'])
    gCheckEegStates.EegFile  = [fileExt '.0'];
    gCheckEegStates.Channels =1;
    gCheckEegStates.nChannels = 1;
    gCheckEegStates.nSamples = FileLength([FileBase fileExt '.0'])/2;
else
    gCheckEegStates.EegFile  = fileExt;
    gCheckEegStates.Channels = Channels;
    gCheckEegStates.nChannels = length(Channels);
    gCheckEegStates.nSamples = FileLength([FileBase fileExt])/nChan/2;
end

nAuxData = max(size(AuxData,1));

gCheckEegStates.FileBase = FileBase;
gCheckEegStates.Par = Par;
gCheckEegStates.State = State;
gCheckEegStates.t = 10; %is seconds
gCheckEegStates.eFs = eSampleRate;
gCheckEegStates.trange = [t(1) t(end)];
gCheckEegStates.Periods = Per/eSampleRate; % in seconds
gCheckEegStates.Mode = 't';
gCheckEegStates.nPlots=gCheckEegStates.nChannels+1+nAuxData;
gCheckEegStates.lh=cell(gCheckEegStates.nPlots,1);
gCheckEegStates.Window = Window*eSampleRate*2;
gCheckEegStates.SelLine=[];
gCheckEegStates.cposh=cell(gCheckEegStates.nPlots,1);
gCheckEegStates.FreqRange = [min(f) max(f)];
gCheckEegStates.newl=[];
gCheckEegStates.tstep = t(2)-t(1);
gCheckEegStates.coolln = [];
gCheckEegStates.LastBut = 'normal';
gCheckEegStates.nAuxData = nAuxData;
if nAuxData>0
    gCheckEegStates.AuxDataType = AuxData(:,4);
end
% create and configure the figure
gCheckEegStates.figh = figure('ToolBar','none');
%set(gCheckEegStates.figh, 'Position', [3 828 1276 620]); %change Postion of figure if you have low resolution
set(gCheckEegStates.figh, 'Name', 'CheckEegStates : traces');
set(gCheckEegStates.figh, 'NumberTitle', 'off');


% put the uitoolbar and uimenu definitions here .. may require rewriting
% some callbacks as actions rather then cases of actions (e.g. key
% pressing)


%now do the plots

for ii=1:gCheckEegStates.nChannels
    subplot(gCheckEegStates.nPlots,1,ii);
    imagesc(t,f,log(sq(y(:,:,ii)))');axis xy; ylim([max(0,FreqRange(1)) min(FreqRange(2),20)]);
    hold on
    if ii==1
        title('Spectrogram'); ylabel('Frequency (Hz)');
    end
end

if nAuxData>0
    for ii=[1:nAuxData]
        subplot(gCheckEegStates.nPlots,1,ii+gCheckEegStates.nChannels);
        DisplayAuxData(AuxData(ii,:));
        xlim(gCheckEegStates.trange);
        hold on
        
    end
end


%  subplot(gCheckEegStates.nPlots,1,2)
%  plot(t,thratio);axis tight;
%  set(gca,'YTick',[]);
%  hold on
%  ylabel('Theta/Delta raio'); xlabel('Seconds');

subplot(gCheckEegStates.nPlots,1,gCheckEegStates.nPlots)
CheckEegStates_aux('traces'); % plot the current eeg traces
hold on

%plots lines
if ~isempty(Per)
CheckEegStates_aux('lines');
end
% assign functions for mouse and keyboard click
set(gCheckEegStates.figh,'WindowButtonDownFcn','CheckEegStates_aux(''mouseclick'')');
set(gCheckEegStates.figh,'KeyPressFcn', 'CheckEegStates_aux(''keyboard'')');

%msave([FileBase '.states.' State],round(ThePeriods*eSampleRate));
return




function [thratio, ThePeriods] = TDRatioAuto(y,f,t,MinLen)

%automatic theta periods detection just using the thetaratio
thfin = find(f>6 & f<9);
thfout = find(f<5 | (f> 12& f<25));
thratio = log(mean(sq(y(:,thfin,1)),2))-log(mean(sq(y(:,thfout,1)),2));

if nargout>1
    nStates =2;
    % fit gaussian mixture and to HMM - experimental version .. uses only thetaratio
    [TheState thhmm thdec] = gausshmm(thratio,nStates,1,0);

    for i=1:nStates
        thratio_st(i) = mean(thratio(TheState==i));
    end

    [dummy TheInd] = max(thratio_st);
    InTh = (TheState==TheInd);
    DeltaT = t(2)-t(1);
    MinSeg = round(MinLen/DeltaT);

    TransTime = ThreshCross(InTh,0.5,MinSeg);
    ThePeriods = t(TransTime);
end
return

function DisplayAuxData(Data)

        nEl =  size(Data,2);
        if nEl<4 
            err=1;
        elseif ~isstr(Data{4})
            err=1;
        else
            err=0;
        end
        if err 
            warning('AuxData has to be cell array where each row is : xaxis, yaxis, data, display_func');
            close 
            return;
        end
        
        switch Data{4} %switch by functions
            case 'plot'
                plot(Data{1}, Data{3});
            case 'imagesc'
                if length(Data{1})~=size(Data{3},1) & length(Data{1})~=size(Data{3},2)
                    Data{3}=Data{3}';
                end
                imagesc(Data{1},Data{2}, Data{3}');
                axis xy
            otherwise 
                error('wrong data display function');
        end
        


return