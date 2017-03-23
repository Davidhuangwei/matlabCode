function [newnet, newalphas, newoldies, newpriors] = ...
    removeneuron(net, alphas, oldies, priors, n)
% REMOVENEURON Remove given neuron from the network

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

I = [1:n-1 n+1:size(net.w1, 1)];

newnet.w1 = net.w1(I,:);
newnet.b1 = net.b1(I,:);
newnet.w2 = net.w2(:,I);
newnet.b2 = net.b2;

newalphas = alphas;
newalphas.w1 = alphas.w1(I,:);
newalphas.b1 = alphas.b1(I,:);
newalphas.w2 = alphas.w2(:,I);
newalphas.b2 = alphas.b2;
newalphas.w1var = alphas.w1var(I,:);
newalphas.b1var = alphas.b1var(I,:);
newalphas.w2var = alphas.w2var(:,I);
newalphas.b2var = alphas.b2var;

newoldies = oldies;
newoldies.w1 = oldies.w1(I,:);
newoldies.b1 = oldies.b1(I,:);
newoldies.w2 = oldies.w2(:,I);
newoldies.b2 = oldies.b2;
newoldies.w1var = oldies.w1var(I,:);
newoldies.b1var = oldies.b1var(I,:);
newoldies.w2var = oldies.w2var(:,I);
newoldies.b2var = oldies.b2var;

newpriors = priors;
newpriors.w2var = priors.w2var(:,I);
