addpath(genpath('/gpfs01/sirota/homes/weiwei/matlab/'))

load('/gpfs01/sirota/data/bachdata/data/weiwei/m_sm/4_16_05_merged_par.mat');
load /gpfs01/sirota/data/bachdata/data/antsiro/blab/sm96_big/4_16_05_merged/ChanInfo/ChanLoc_Full.eeg.mat
% chanLoc
addpath /gpfs01/sirota/data/bachdata/data/antsiro/blab/sm96_big%addpath
addpath(genpath('/gpfs01/sirota/homes/antsiro/matlab/draft/'))
addpath(genpath('/gpfs01/sirota/homes/share/matlab/Person-Specific_Matlab_Functions/ER'))


repch=RepresentChan(Par);
cd /gpfs01/sirota/home/evgeny/project/gamma/data/4_16_05_merged
FileBase='4_16_05_merged';
State='RUN';
[FeatData, FeatName] = LoadBurst(FileBase, Par,'csdsm5', State);
Shk=2;
%%
isfcause=true;
MyBursts = find(strcmp(FeatData{15},'CA1rad')' & FeatData{7}==Shk & FeatData{9}>40);%
% if isfcause & abs(FeatData{2}-f0)<10 

nBursts = length(MyBursts);
disp(['you have ', num2str(nBursts), ' bursts here'])
ech=getindex(repch,Par.AnatGrps(2).Channels+1);
cch=76;
Res = floor(FeatData{14}(MyBursts)*1250);
Clu= FeatData{2}(MyBursts);
[ccd, ed]=getPhase(FileBase, State, cch, ech, Res, Clu);
cd ~/data/sm/4_16_05_merged
save('cedata','ccd','ed','Res','Clu')