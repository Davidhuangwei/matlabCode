%% load MEG data (see NNSP2003 paper www.cis.hut.fi/jhimberg/icasso/paper.pdf)
load sf12

%%% ICA Estimation
%%% random initial conditions, 10 repetitions, kurtosis:

S=icassoEst('randinit',sf12,10,'g','pow3');

%%% Default similarity measure & clustering

S=icassoExp(S);

%%% Visualize 13 clusters; default settings:

icassoShow(S,'level',13);

pause;

%%% Visualize 20 clusters: show lines for r>0.1 but 
%%% hide within-cluste lines for r>0.9

icassoShow(S,'level',20,'limit',0.1,'dense',0.8);

pause;

%%% Get partition in 20 clusters:

P=S.cluster.partition(20,:);


