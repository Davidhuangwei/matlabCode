function ICArelated
% 
% <----:: ICA related tool functions by YY ::----------------------------->
% 
% Spectrum-space-JAJD: [B, Spec]=SSpecJAJD(x,kn,wn,Fs,fr,nt,varargin)
% approximate joint diagnolization: B=PhamAJD(P) and [a, c] = jadiag(c, a,
%               maxiter, epsi) 
% PhamAJD: my code for approximate joint diagonalization of several
%       positive matrices. 
% jadiag: [a, c] = jadiag(c, a, maxiter, epsi) Performs approximate joint
%       diagonalization of several positive matrices. 
% wKDICA: [icasig, A, W]=wKDICA(x,ncomp,varargin) I add demention reduction
%           step. W=KDICA(x,varargin)
% ClusterComp: [nm, mD]=ClusterComp(LA,SA,ka,usePC): I use this to do the
%           clusterring of ICs get from different chunck. 
% CorrComp: corrcomp=CorrComp(icasig) Cross corelation between Comps from
%           different chunck 
% 
% see also: functionlist(Independence test, Kernel related, Regression),
% TimeSequencyProcessing(basic & CSD related),  
% Clustercomponents: ClusterComp.m, CorrComp.m
% ML: wKDICA.m, KDICA.m, runica.m, fastica.m
% JD: SSpecJAJD.m, jadiag.m, PhamAJD.m
% cleannoise: icaclean_main, icaclean, pcaclean
% relatedspcripts: ica_draft.m, ica_draft.m, ica_draftSM.m, ica_draftER.m,
% ica_draftR.m, ica_testG.m