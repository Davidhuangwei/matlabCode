function GetChanPhaseData(FileBase,ch)
FileBase='4_16_05_merged';
% pfb=[4 6;6 8; 8 10; 10 12; 12 15; [15:5:95;20:5:100]';[100:10:190;110:10:200]'];
% [FreqBins,funcnum] = DefaultArgs(varargin,{pfb,1});% 25:10:150
hfolder=['/gpfs01/sirota/bach/data/antsiro/blab/sm96_big/', FileBase];

cd(hfolder)
load 4_16_05_merged_par.mat
channels = RepresentChan(Par);
cd ChanInfo
load ChanLoc_Full.eeg.mat % use as chanLoc.area
[~,lca]=getindex(channels(:),chanLoc.ca3Pyr(:));
nca=length(lca);
[~,lrad]=getindex(channels(:),chanLoc.rad(:));
nrad=length(lrad);
cd('/gpfs01/sirota/bach/data/weiwei/m_sm')
jnm=pwd;
States = {'REM','RUN','SWS'};
ssi=2;
f0=70;
rch=ch;%[69,74];% CA1, CA3

% if isfcause
% % from the logic of knowing effects -> find causes

% %% Run Over All States
% %         for  xxn=1:length(ns)
% for ssi=3 %'RUN' ns(xxn); % loop over states
if exist([FileBase, '_SP_', States{ssi}, '.mat'])
    load([FileBase, '_SP_', States{ssi}, '.mat'], 'SP','FreqB')
else
    disp(['you do not have SP for ', States{ssi}])
end
nprd=length(SP);
nfr=size(FreqB,1);
% clear SP
% %             in the new long frequency vision, I can use out.Periods which
% %             record the periods.


for sjn=1:nprd
    load([FileBase, '_LFPsig_', States{ssi}, num2str(sjn)])
    out.LFPsig=double(out.LFPsig);
    if sjn==1;
        nLFP=[];
        nLFP(:,:,1)=out.LFPsig(:,69+93*(0:(nfr-1)));
        nLFP(:,:,2)=out.LFPsig(:,74+93*(0:(nfr-1)));
    else
        sLFP=[];
        sLFP(:,:,1)=out.LFPsig(:,69+93*(0:(nfr-1)));
        sLFP(:,:,2)=out.LFPsig(:,74+93*(0:(nfr-1)));
        nLFP=[nLFP;sLFP];
    end
end

out.LFPsig=nLFP;

cd(['~/data/sm/', FileBase])
save([FileBase, '.phase.ch', num2str(rch), '.mat'], 'out','-v7.3')
clear all