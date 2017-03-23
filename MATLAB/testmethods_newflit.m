function testmethods_newflit()
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
[FeatData, FeatName] = LoadBurst(FileBase, Par,'lfpinterp', State);
Shk=2;