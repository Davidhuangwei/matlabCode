function [s,cfg] = statfun_indepsamplesregrT(cfg, dat, design);

% STATFUN_indepsamplesregrT calculates independent samples regression coefficient 
% T-statistics on the biological data in dat (the dependent variable), using the information on 
% the independent variable (predictor) in design.
%
% The external interface of this function has to be
%   [s,cfg] = statfun_indepsamplesregrT(cfg, dat, design);
% where
%   dat    contains the biological data,  Nsamples x Nreplications
%   design contains the independent variable,  Nfac x Nreplications
%
% Configuration options:
%   cfg.computestat    = 'yes' or 'no', calculate the statistic (default='yes')
%   cfg.computecritval = 'yes' or 'no', calculate the critical values of the test statistics (default='no')
%   cfg.computeprob    = 'yes' or 'no', calculate the p-values (default='no')
%
% The following options are relevant if cfg.computecritval='yes' and/or
% cfg.computeprob='yes'.
%   cfg.alpha = critical alpha-level of the statistical test (default=0.05)
%   cfg.tail = -1, 0, or 1, left, two-sided, or right (default=1)
%              cfg.tail in combination with cfg.computecritval='yes'
%              determines whether the critical value is computed at
%              quantile cfg.alpha (with cfg.tail=-1), at quantiles
%              cfg.alpha/2 and (1-cfg.alpha/2) (with cfg.tail=0), or at
%              quantile (1-cfg.alpha) (with cfg.tail=1).
%
% Design specification:
%   cfg.ivar        = factor number containing the independent variable (default=1)
%                       

% Copyright (C) 2006, Eric Maris
%
% $Log: statfun_indepsamplesregrT.m,v $
% Revision 1.5  2006/09/12 12:13:07  roboos
% removed default values for cfg.ivar and uvar, defaults should be specified elsewhere
%
% Revision 1.4  2006/06/07 12:51:18  roboos
% renamed cfg.ivrownr into cfg.ivar
% renamed cfg.uorownr into cfg.uvar
% renamed pval into prob for consistency with other fieldtrip functions
%
% Revision 1.3  2006/05/17 11:59:55  erimar
% Corrected bugs after extensive checking of the properties of this
% statfun.
%
% Revision 1.2  2006/05/12 15:32:40  erimar
% Added functionality to calculate one- and two-sided critical values and
% p-values.
%
% Revision 1.1  2006/05/05 13:05:24  erimar
% First version of statfun_indepsamplesregrT.
%

% set defaults
if ~isfield(cfg, 'computestat'),       cfg.computestat='yes';     end;
if ~isfield(cfg, 'computecritval'),    cfg.computecritval='no';   end;
if ~isfield(cfg, 'computeprob'),       cfg.computeprob='no';      end;
if ~isfield(cfg, 'alpha'),             cfg.alpha=0.05;            end;
if ~isfield(cfg, 'tail'),              cfg.tail=1;                end;

% perform some checks on the configuration
if strcmp(cfg.computeprob,'yes') & strcmp(cfg.computestat,'no')
    error('P-values can only be calculated if the test statistics are calculated.');
end;

[nsmpl,nrepl] = size(dat);
df = nrepl - 2;
if nrepl<3
    error('The data must contain at least three replications')
end;

if strcmp(cfg.computestat, 'yes')
  % compute the statistic
    indvar = design(cfg.ivar,:);
    designmat = [ones(nrepl,1) indvar']; % designmat is a matrix of order Nrepl x 2
    cpmat = designmat'*designmat;
    invcpmat = inv(cpmat);
    projmat = invcpmat*designmat';
    B = dat*projmat'; % B is a matrix of order Nsamples x 2
    res = dat - B*designmat';
    resvar = zeros(nsmpl,1);
    for indx=1:nsmpl
      resvar(indx)=res(indx,:)*res(indx,:)';
    end;
    resvar=resvar/df;
    se=sqrt(invcpmat(2,2)*resvar);
    s.stat=B(:,2)./se;
end;

if strcmp(cfg.computecritval,'yes')
  % also compute the critical values
  s.df      = df;
  if cfg.tail==-1
    s.critval = tinv(cfg.alpha,df);
  elseif  cfg.tail==0
    s.critval = [tinv(cfg.alpha/2,df),tinv(1-cfg.alpha/2,df)];
  elseif cfg.tail==1
    s.critval = tinv(1-cfg.alpha,df);
  end;
end

if strcmp(cfg.computeprob,'yes')
  % also compute the p-values
  s.df      = df;
  if cfg.tail==-1
    s.prob = tcdf(s.stat,s.df);
  elseif  cfg.tail==0
    s.prob = 2*tcdf(-abs(s.stat),s.df);
  elseif cfg.tail==1
    s.prob = 1-tcdf(s.stat,s.df);
  end;
end

