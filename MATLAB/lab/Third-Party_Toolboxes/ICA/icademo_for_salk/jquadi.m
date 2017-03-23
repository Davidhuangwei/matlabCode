function [stepmin]=jquadi(steps,matf)
%QUADI  Quadraticly interpolates three points to estimate minimum.
%         This function uses QUADRATIC interpolation and
%         the values of three unevenly spaced points 
%         in order estimate the minimum of a 
%         a function along a line.
%    syntax: [stepmin]=quadi(steps,matf)
%    where steps is a matrix constraining the spacing of the points.
%          matf is a vector which contains the corresponding elements of f 
%          stepmin is the step to the minimum.

steps=steps(:);
% Solve simultaneous equations:
      amat=[0.5*steps.*steps, steps, ones(3,1)];
      abc=amat\matf(:);
      stepmin=-abc(2)/abc(1);
