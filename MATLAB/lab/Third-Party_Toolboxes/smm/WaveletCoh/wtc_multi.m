function varargout=wtc_multi(x,varargin)
%% Wavelet coherence
%
% USAGE: [Rsq,period,scale,coi,Wave]=wtc(x,[,settings])
%
% 
% Settings: RefChan: reference channels for coh calc (default: 1:nChan)
%           Pad: pad the time series with zeros? 
% .         Dj: Octaves per scale (default: '1/12')
% .         S0: Minimum scale
% .         J1: Total number of scales
% .         Mother: Mother wavelet (default 'morlet')
% .         MaxScale: An easier way of specifying J1
% .         MakeFigure: Non-Used in wtc_multi
%                Make a figure or simply return the output.
% .         BlackandWhite: Create black and white figures
% .         AR1: Non-Used in wtc_multi
%                the ar1 coefficients of the series 
% .              (default='auto' using a naive ar1 estimator. See ar1nv.m)
% .         MonteCarloCount: Non-Used in wtc_multi
%               Number of surrogate data sets in the significance calculation. (default=300)
% .         ArrowDensity (default: [30 30])
% .         ArrowSize (default: 1)
% .         ArrowHeadSize (default: 1)
%
% Settings can also be specified using abbreviations. e.g. ms=MaxScale.
% For detailed help on some parameters type help wavelet.
%
% Example:
%    t=1:200;
%    wtc([sin(t),sin(t.*cos(t*.01))],'ms',16)
%
% Please acknowledge the use of this software in any publications:
%   "Crosswavelet and wavelet coherence software were provided by
%   A. Grinsted."
%
% (C) Aslak Grinsted 2002-2004
%
% http://www.pol.ac.uk/home/research/waveletcoherence/
%
% MODIFIED by smm 3/07 to quickly calculate wavelet coherence for many
% channels


% -------------------------------------------------------------------------
%   Copyright (C) 2002-2004, Aslak Grinsted
%   This software may be used, copied, or redistributed as long as it is not
%   sold and this copyright notice is reproduced on each copy made.  This
%   routine is provided as is without any express or implied warranties
%   whatsoever.


% ------validate and reformat timeseries.
nChan = size(x,1);
for j=1:nChan
    [xNew(j,:,:),dt]=formatts(x(j,:));
end
x = xNew;
clear xNew;
% [y,dty]=formatts(y);
% if dt~=dty
%     error('timestep must be equal between time series')
% end
t=(x(1,1,1):dt:x(1,end,1))'; %common time period
if length(t)<4
    error('The two time series must overlap.')
end



n=length(t);

%----------default arguments for the wavelet transform-----------
Args=struct('RefChan',[1:nChan],... % use all chans as refs
            'Pad',1,...      % pad the time series with zeroes (recommended)
            'Dj',1/12, ...    % this will do 12 sub-octaves per octave
            'S0',2*dt,...    % this says start at a scale of 2 years
            'J1',[],...
            'Mother','Morlet', ...
            'MaxScale',[],...   %a more simple way to specify J1
            'MakeFigure',(nargout==0),...
            'MonteCarloCount',300,...
            'BlackandWhite',0,...
            'AR1','auto',...
            'ArrowDensity',[30 30],...
            'ArrowSize',1,...
            'ArrowHeadSize',1);
Args=parseArgs(varargin,Args,{'BlackandWhite'});
if isempty(Args.J1)
    if isempty(Args.MaxScale)
        Args.MaxScale=(n*.17)*2*dt; %auto maxscale
    end
    Args.J1=round(log2(Args.MaxScale/Args.S0)/Args.Dj);
end

ad=mean(Args.ArrowDensity);
Args.ArrowSize=Args.ArrowSize*30*.03/ad;
Args.ArrowHeadSize=Args.ArrowHeadSize*Args.ArrowSize*220;


if ~strcmpi(Args.Mother,'morlet')
    warning('Smoothing operator is designed for morlet wavelet.')
end

%% needs work for multi %%
% if strcmpi(Args.AR1,'auto')
%     for j=1:nChan
%         Args.AR1(j,:) =[ar1nv(squeeze(x(j,:,2))) ];
% %         Args.AR1 =[ar1nv(x(:,2)) ar1nv(y(:,2))];
%     end
%     if any(isnan(Args.AR1(:)))
%         error('Automatic AR1 estimation failed. Specify it manually (use arcov or arburg).')
%     end
% end

nx=size(x,2);
% nx=size(x,1);
% sigmax=std(x(:,2));

% ny=size(y,1);
% sigmay=std(y(:,2));

refTime = clock;
%-----------:::::::::::::--------- ANALYZE ----------::::::::::::------------
for j=1:nChan
    [X(j,:,:),period,scale,coi] = wavelet(squeeze(x(j,:,2)),dt,Args.Pad,Args.Dj,Args.S0,Args.J1,Args.Mother);
    % [X,period,scale,coix] = wavelet(x(:,2),dt,Args.Pad,Args.Dj,Args.S0,Args.J1,Args.Mother);
    % [Y,period,scale,coiy] = wavelet(y(:,2),dt,Args.Pad,Args.Dj,Args.S0,Args.J1,Args.Mother);

    %Smooth X and Y before truncating!  (minimize coi)
    if j==1
        sinv=1./(scale');
    end

    sX(j,:,:)=smoothwavelet(sinv(:,ones(1,nx)).*(abs(squeeze(X(j,:,:))).^2),dt,period,Args.Dj,scale);
    % sX=smoothwavelet(sinv(:,ones(1,nx)).*(abs(X).^2),dt,period,Args.Dj,scale);
    % sY=smoothwavelet(sinv(:,ones(1,ny)).*(abs(Y).^2),dt,period,Args.Dj,scale);
end
%calcTime = clock-refTime

% truncate X,Y to common time interval (this is first done here so that the coi is minimized)
for k=1:length(Args.RefChan)
    for j=1:nChan
        if isempty(find(j==refChans(k+1:end)))
            % -------- Cross wavelet -------
            Wxy=squeeze(X(Args.RefChan(k),:,:).*conj(X(j,:,:)));

            % ----------------------- Wavelet coherence ---------------------------------
            sWxy=smoothwavelet(sinv(:,ones(1,n)).*Wxy,dt,period,Args.Dj,scale);
            Rsq(k,j,:,:)=abs(sWxy).^2./squeeze(sX(Args.RefChan(k),:,:).*sX(j,:,:));
        end
    end
end
for k=1:length(refChans)
    for j=k:length(refChans) 
        Rsq(k,refChans(j)) = Rsq(j,refChans(k));
    end
end
%cohTime = clock-refTime

%% needs work for multi %%
% if (Args.MonteCarloCount>0)&(nargout>0)|(Args.MakeFigure)
%     wtcsig=wtcsignif(Args.MonteCarloCount,Args.AR1,dt,length(t)*2,Args.Pad,Args.Dj,Args.S0,Args.J1,Args.Mother,.6);
%     wtcsig=(wtcsig(:,2))*(ones(1,n));
%     wtcsig=Rsq./wtcsig;
% else
%     wtcsig = NaN;
% end


varargout={Rsq,period,scale,coi,X};
varargout=varargout(1:nargout);






function [cout,H]=safecontourf(varargin)
vv=sscanf(version,'%i.');
if (version('-release')<14)|(vv(1)<7)
    [cout,H]=contourf(varargin{:});
else
    [cout,H]=contourf('v6',varargin{:});
end

function hcb=safecolorbar(varargin)
vv=sscanf(version,'%i.');

if (version('-release')<14)|(vv(1)<7)
    hcb=colorbar(varargin{:});
else
    hcb=colorbar('v6',varargin{:});
end

