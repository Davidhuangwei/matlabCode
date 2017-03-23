%
% icaproj() - project ICA component activations through the
%                associated weight matrices to reconstitute the
%                observed data using only the selected ICA components.
%
% [icaprojdata] = icaproj(data,weights,sphere,datamean,compindex);
%
% data        = ICA data matrix processed by runica()
% weights     = ICA weight matrix from runica()
% sphere      = ICA sphering matrix from runica()
% datamean    = ICA row means (for each epoch) from runica()
% Note: (datamean = 0 -> distribute data offsets among the ICA components)
% compindex   = vector of ICA component indices to project

% 11-30-96 Scott Makeig CNL / Salk Institute, La Jolla as icaproject.m
% 12-24-96 added define for verbose -sm (V1.3)
% 2-11-97  use outer product math when only one component in compindex -sm
% 3-11-97  remove row means instead of grand mean -sm
% 3-19-97  used datamean argument instead of frames/baseframes -sm
% 4-03-97  changed name to icaproj() -sm
% 6-07-97  changed order of args to conform to runica -sm
% 6-10-97  fixed data mean handling -sm
% 6-23-97  trying pseudo-inverse for non-square weights -sm
% 7-23-97  distributed baseline offset (if any) among the activations -sm
% 10-31-97 removed errcode -sm

function  [icaprojdata] = icaproj(data,weights,sphere,datamean,compindex)

if nargin<5   % need all 5 args
    help icaproj
    return
end
verbose = 0;   % default no-verbose
[chans,framestot] = size(data);
[mchans,epochs] = size(datamean);
frames = floor(framestot/epochs);
if epochs*frames ~= framestot | frames < 1,
    fprintf('icaproj(): frames (%d) does not divide data length (%d)\n.',frames,framestot);
    return
end

[ncomps,cols] = size(compindex);
if cols>1,
  if ncomps==1,    % if row vector, 
      compindex = compindex';    % make col vector
      ncomps = cols;
  else
      fprintf('icaproj(): compindex must be a vector\n');
      return
  end
end
if ncomps>chans,
  fprintf('icaproj(): compindex must have <= %d entries\n',chans);
  return
end
for a=1:ncomps-1
  for b=a+1:ncomps
      if compindex(a,1)==compindex(b,1),
            fprintf('icaproj(): component index repeated in compindex\n.');
          return
      end
  end
end
for a=1:ncomps
    if compindex(a)>chans | compindex(a)<1
      fprintf('icaproj(): component index %d out of range!\n',compindex(a));
      return
      break
    end
end

if datamean ~= 0,
  %
  % Remove row means subtracted prior to ICA training by runica()
  %
  if verbose==1,
     fprintf('Removing data means of each row, each data epoch...\n');
  end
  for e=1:epochs
      data(:,(e-1)*frames+1:e*frames) = ...
         data(:,(e-1)*frames+1:e*frames) - datamean(:,e)*ones(1,frames);
  end;
end
if verbose == 1
  fprintf('Final input data range: %g to %g\n', ...
                min(min(data)),max(max(data)));
end

activations = weights*sphere*data;         % activation waveforms

if size(weights,1) == size(weights,2)
  iweights    = inv(weights*sphere);     % inverse weight matrix
else
  iweights    = pinv(weights*sphere);    % pseudo-inverse weight matrix
end

if ncomps==1,  % compute outer product only for single component projection
  if verbose==1,
    fprintf('icaproj(): Projecting data for ICA component %d\n',...
                     compindex(1));
  end
  icaprojdata = iweights(:,compindex(1))*(activations(compindex(1),:));

else % if ncomps > 1
  seldata = zeros(size(iweights,2),size(data,2)); % begin with a zero matrix
  if verbose==1,
    fprintf('icaproj(): Projecting data for ICA components ... ');
    for n=1:ncomps % for each included component 
      fprintf('%d ',compindex(n));
    end
    fprintf('\n');         % copy selected activations
  end
  seldata(compindex,:) = activations(compindex,:);
  icaprojdata = iweights*seldata; 
              % reconstitute scalp data from selected ICA components
end
