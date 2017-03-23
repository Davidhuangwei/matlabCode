function [res] = randomizedesign(cfg, design);

% RANDOMIZEDESIGN generates a colection of design matrices in which columns
% of the design matrix are randomly swapped. The random swapping is done
% given user-specified constraints (e.g. for paired observations)
%
% Use as
%   [res] = randomizedesign(cfg, design)
% where the configuration can contain
%   cfg.numrandomization = number (e.g. 300), can be 'all' in case of two conditions
%   cfg.ivar             = number or list with indices, independent variable(s)
%   cfg.uvar             = number or list with indices, unit variable(s)
%   cfg.cvar             = number or list with indices, control variable(s)
%   cfg.wvar             = number or list with indices, within-cell variable(s)
%
% See also STATISTICS_MONTECARLO

% TODO 
% wvar is automatisch te bepalen/toe te voegen 
% boel hernoemen naar permutedesign

% Copyright (C) 2005-2006, Robert Oostenveld
%
% $Log: randomizedesign.m,v $
% Revision 1.7  2006/10/30 10:09:48  roboos
% removed the check that each repeated measurement should have the same number of elements (for uvar)
%
% Revision 1.6  2006/07/14 07:10:26  roboos
% do not treat uvar and wvar the same, wvar is not dealt with yet
%
% Revision 1.5  2006/06/13 11:36:11  roboos
% renamed cfg.bvar into cfg.wvar (within-block variable)
%
% Revision 1.4  2006/06/07 12:55:14  roboos
% changed a print statement
%
% Revision 1.3  2006/06/07 09:27:12  roboos
% rewrote most of the function, added support for uvar and cvar (instead of unitfactor), added support for a block variable cfg.wvar (for keeping all tapers within a trial together)
%

if ~isfield(cfg, 'ivar'), cfg.ivar = []; end
if ~isfield(cfg, 'uvar'), cfg.uvar = []; end
if ~isfield(cfg, 'cvar'), cfg.cvar = []; end
if ~isfield(cfg, 'wvar'), cfg.wvar = []; end

if size(design,1)>size(design,2)
  % this function wants the replications in the column direction
  % the matrix seems to be transposed
  design = transpose(design);
end

Nvar  = size(design,1);   % number of factors or regressors
Nrepl = size(design,2);   % number of replications

fprintf('total number of measurements     = %d\n', Nrepl);
fprintf('total number of variables        = %d\n', Nvar);
fprintf('number of independent variables  = %d\n', length(cfg.ivar));
fprintf('number of unit variables         = %d\n', length(cfg.uvar));
fprintf('number of control variables      = %d\n', length(cfg.cvar));
fprintf('number of within-block variables = %d\n', length(cfg.wvar));

if ~isempty(cfg.cvar)
  error('the use of control variables (cfg.cvar) is not yet supported');
end

dum = 0;
dum = dum + length(intersect(cfg.ivar, cfg.uvar));
dum = dum + length(intersect(cfg.ivar, cfg.cvar));
dum = dum + length(intersect(cfg.ivar, cfg.wvar));
dum = dum + length(intersect(cfg.uvar, cfg.cvar));
dum = dum + length(intersect(cfg.uvar, cfg.wvar));
dum = dum + length(intersect(cfg.cvar, cfg.wvar));
if dum~=0
  warning('there is an intersection between ivar+uvar+cvar+wvar');
end

if isnumeric(cfg.numrandomization) && cfg.numrandomization==0
  % no randomizations are requested, return an empty shuffled matrix
  res = zeros(0,Nrepl);
  return;
end

if length(cfg.wvar)>0
  % keep the elements within a block together
  % this is realized by replacing the design matrix temporarily with a smaller version
  blkmeas = unique(design(cfg.wvar,:)', 'rows')';
  for i=1:size(blkmeas,2)
    blksel{i} = find(all(design(cfg.wvar,:)==repmat(blkmeas(:,i), 1, Nrepl), 1));
    blklen(i) = length(blksel{i});
  end
  for i=1:size(blkmeas,2)
    if any(diff(design(:, blksel{i}), 1, 2)~=0)
      error('the design matrix variables should be constant within a block');
    end
  end
  orig_design = design;
  orig_Nrepl  = Nrepl;
  % replace the design matrix by a blocked version
  design = zeros(size(design,1), size(blkmeas,2));
  Nrepl  = size(blkmeas,2); 
  for i=1:size(blkmeas,2)
    design(:,i) = orig_design(:, blksel{i}(1));
  end
end

% do some validity checks
if Nvar==1 && length(cfg.uvar)>0
  error('A within-units shuffling requires a at least one unit variable and at least one independent variable');
end

if length(cfg.uvar)==0
  if ischar(cfg.numrandomization) && strcmp(cfg.numrandomization, 'all')
    % systematically shuffle the columns in the design matrix
    Nperm = prod(1:Nrepl);
    fprintf('creating all possible permutations (%d)\n', Nperm);
    order = perms(1:Nrepl);
  elseif ~ischar(cfg.numrandomization)
    % randomly shuffle the columns in the design matrix
    for i=1:cfg.numrandomization
      order(i,:) = randperm(Nrepl);
    end
  end

elseif length(cfg.uvar)>0
  % keep the rows of the design matrix with the unit variable intact
  repmeas = unique(design(cfg.uvar,:)', 'rows')';
  for i=1:size(repmeas,2)
    repsel{i} = find(all(design(cfg.uvar,:)==repmat(repmeas(:,i), 1, Nrepl), 1));
    replen(i) = length(repsel{i});
  end
  if length(cfg.uvar)==1
    fprintf('repeated measurement in variable %d over %d levels\n', cfg.uvar, length(repmeas));
    fprintf('number of repeated measurements in each level is '); fprintf('%d ', replen); fprintf('\n');
  else
    fprintf('repeated measurement in mutiple variables over %d levels\n', length(repmeas));
    fprintf('number of repeated measurements in each level is '); fprintf('%d ', replen); fprintf('\n');
  end

  if ischar(cfg.numrandomization) && strcmp(cfg.numrandomization, 'all')
    % create all possible permutations by systematic assignment
    if any(replen~=2)
      error('cfg.numrandomization=''all'' is only supported for two repeated measurements');
    end
    Nperm = 2^(length(repmeas));
    fprintf('creating all possible permutations (%d)\n', 2^(length(repmeas)));
    order = zeros(Nperm, Nrepl);
    for i=1:Nperm
      flip  = dec2bin( i-1, length(repmeas));
      for j=1:length(repmeas)
        if     strcmp('0', flip(j)),
          order(i, repsel{j}(1)) = repsel{j}(1);
          order(i, repsel{j}(2)) = repsel{j}(2);
        elseif strcmp('1', flip(j)),
          order(i, repsel{j}(1)) = repsel{j}(2);
          order(i, repsel{j}(2)) = repsel{j}(1);
        end
      end
    end

  elseif ~ischar(cfg.numrandomization)
    % create the desired number of permutations by random shuffling
    order = zeros(cfg.numrandomization, Nrepl);
    for i=1:cfg.numrandomization
      for j=1:length(repmeas)
        order(i, repsel{j}) = repsel{j}(randperm(length(repsel{j})));
      end
    end
  end

else
  error('Unsupported configuration for randomizing the design matrix.');
end

if length(cfg.wvar)>0
  % switch back to the original design matrix and expand the ordering
  % matrix so that it reorders all elements in a block together
  design = orig_design;
  Nrepl  = orig_Nrepl;
  expand = zeros(size(order,1), Nrepl);
  for i=1:size(order,1)
    expand(i,:) = cat(2, blksel{order(i,:)});
  end
  order = expand;
end

% construct one large 3-D array with all randomized design matrices
res = zeros([size(order,1) size(design)]);
for i=1:size(order,1)
  tmp = design(:, order(i,:));
  res(i,:) = tmp(:);
end
