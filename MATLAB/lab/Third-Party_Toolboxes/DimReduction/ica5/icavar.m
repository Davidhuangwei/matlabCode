% icavar - project ICA component activations through the ICA weight matrices 
%             to reconstitute the observed data using selected ICA components. 
%               Returns time course of variance on scalp for each component.
% Usage:
%        >> [srcvar] = icavar(data,weights,sphere,compnums);
% Inputs:
%   data, weights                -- variables returned by runica()
%   sphere                       -- returned by runica() (default|0 -> eye(ncomps))
%   compnums                     -- list of component numbers (default|0 -> all)

% 11-30-96  Scott Makeig  CNL / Salk Institute, La Jolla
% 04-03-97  made more efficient -sm
% 05-20-97  debugged variance calculation and made it more efficient -sm
% 06-07-97  changed order of args to conform to runica -sm
% 07-23-97  do not add back datamean to projections -sm
% 12-23-97  added compnums -sm
% 02-25-98  changed activations input to data -sm
% 07-20-98  use pinv() for inverting non-square weights -sm

function [srcvar] = icavar(data,weights,sphere,compnums)

if nargin<2
   help icavar
   return
end

if size(weights,2) ~= size(sphere,1) | size(sphere,2) ~= size(data,1)
   fprintf('icavar() - sizes of weights, sphere, and data incompatible.\n')
   whos data weights sphere
   return
end
activations = weights*sphere*data;
[ncomps,frames] = size(activations);
[wr,chans]      = size(weights);    % Note: ncomps may < data chans

if nargin<4
    compnums = 0;
end
if compnums == 0,
    compnums = 1:ncomps;
end
srcvar = zeros(length(compnums),frames);

if nargin < 3
   sphere = 0;
end
if sphere == 0,
   sphere = eye(ncomps);
end

project = weights*sphere;

if wr~=ncomps,
  fprintf('icavar: Number of rows in activations and weights must be equal.\n');
  return
end

% if wr<chans,
  % fprintf('Filling out a square projection matrix with small noise.\n');
  % for r=1:chans-wr,
    % project = [project;0.00001*randn(1,chans)];
  % end
% end
% project = inv(project);                        % invert projection matrix

if wr<chans
  project = pinv(project);
else
  project = inv(project);
end

fprintf('Projecting ICA component ');
nout = length(compnums);
for i=1:nout                                 % for each component 
  comp = compnums(i);
  fprintf('%d ',comp); 
  projdata = project(:,comp)*activations(comp,:);       % reproject eeg data 
  srcvar(i,:) = sum(projdata.*projdata)/(chans-1);% compute variance at each time point
end
fprintf('\n');
