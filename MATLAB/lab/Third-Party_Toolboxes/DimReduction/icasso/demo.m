%% load MEG data (see NNSP2003 paper www.cis.hut.fi/jhimberg/icasso/paper.pdf)
load sf12

%%% ICA Estimation
%%% random initial conditions, 10 repetitions, kurtosis:

S=icassoEst('randinit',sf12,10,'g','pow3');

%% S contains now estimates. Next 
%- dissimilarity measure between them is formed
%- estimates are clustered
%- a projection for the visualization is computed

%%% Default similarity measure & clustering:

S=icassoExp(S);

%%% Launch Visualization wizard

icassoViz(S);


