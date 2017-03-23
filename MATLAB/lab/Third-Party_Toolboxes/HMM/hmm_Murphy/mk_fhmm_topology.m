function [intra, inter] = mk_FHMM_topology(M)
% MK_FHMM_TOPOLOGY Make the graph structure for a Factorial HMM with M hidden chains.
% [intra, inter] = mk_FHMM_topology(M)
%
% e.g., M = 2 (vertical/diagonal edges point down)
%
% A1--->A2
% | B1--|->B2
% | /   |/
% Y1    Y2

ss = M+1;
intra = zeros(ss);
intra(:,M+1) = 1;
intra(M+1,M+1) = 0;
inter = eye(ss);
inter(M+1,M+1) = 0;
