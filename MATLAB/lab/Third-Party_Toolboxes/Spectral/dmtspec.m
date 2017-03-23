s, IEEE Transactions on Signal Processing,
%               Vol. 46, No. 6,, June 1998, pp. 1749-1752.

%Header
%==============================================================

%Declaration of variables
%------------------------

%Declare and assign values to local variables
%according to the input argument pattern
[ar,ma,n_shift,ASAcontrol]=ASAarg(varargin, ...
{'ar'       ;'ma'       ;'n_shift'    ;'ASAcontrol'}, ...
{'isnumeric';'isnumeric';'isnumeric'  ;'isstruct'  }, ...
{'ar'       ;'ma'                                  }, ...
{'ar'       ;'ma'       ;'n_shift'                 });

if isequal(nargin,1) & ~isempty(ASAcontrol)
      %ASAcontrol is the only input argument
   ASAcontrol.error_chk = 0;
   ASAcontrol.run = 0;
end

%ARMASA-function version information
%-----------------------------------

%This ARMASA-function is characterized by
%its current version,
ASAcontrol.is_version = [2000 12 30 20 0 0];
%and its compatability with versions down to,
ASAcontrol.comp_version = [2000 12 30 20 0 0];

%This function calls other functions of the ARMASA
%toolbox. The versions of these other functions must
%be greater than or equal to:
ASAcontrol.req_version.ar2arset_e = [2000 11 1 12 0 0];
ASAcontrol.req_version.convolrev_e = [2000 11 1 12 0 0];
ASAcontrol.req_version.convol_e = [2000 11 1 12 0 0];

%Checks
%------

if ~isfield(ASAcontrol,'error_chk') | ASAcontrol.error_chk
      %Perform standard error checks
   %Input argument format checks
   ASAcontrol.error_chk = 1;
   if ~isnum(ar)
      error(ASAerr(11,'ar'))
   elseif ~isvector(ar)
      error(ASAerr(15,'ar'))
   elseif size(ar,1)>1
      ar = ar';
      warning(ASAwarn(25,{'column';'ar';'row'},ASAcontrol))         
   end
   if ~isnum(ma)
      error(ASAerr(11,'ma'))
   elseif ~isvector(ma)
      error(ASAerr(15,'ma'))
   elseif size(ma,1)>1
      ma = ma';
      warning(ASAwarn(25,{'column';'ma';'row'},ASAcontrol))         
   end
   if ~isempty(n_shift) & (~isnum(n_shift) | ...
         ~isintscalar(n_shift) | n_shift<0)
      error(ASAerr(17,'n_shift'))
   end
   
   %Input argument value checks
   if ~(isreal(ar) & isreal(ma))
      error(ASAerr(13))
   end
   if ar(1)~=1
      error(ASAerr(23,{'ar','parameter'}))
   end
   if ma(1)~=1
      error(ASAerr(23,{'ma','parameter'}))
   end
end

if ~isfield(ASAcontrol,'version_chk') | ASAcontrol.version_chk
      %Perform version check
   ASAcontrol.version_chk = 1;
      
   %Make sure the requested version of this function
   %complies with its actual version
   ASAversionchk(ASAcontrol);
   
   %Make sure the requested versions of the called
   %functions comply with their actual versions
   ar2arset_e(ASAcontrol);
   convol_e(ASAcontrol);
   convolrev_e(ASAcontrol);
end

if ~isfield(ASAcontrol,'run') | ASAcontrol.run
   ASAcontrol.run = 1;
end

if ASAcontrol.run %Run the computational kernel
   ASAcontrol.version_chk = 0;
   ASAcontrol.error_chk = 0;

%Main   
%=====================================================
    
%Initializations
%---------------

ar_order = length(ar)-1;
ma_order = length(ma)-1;
if isempty(n_shift)
   n_shift = max(ar_order,ma_order);
end
n_vv = n_shift+ma_order+1;
h_cov_vv = zeros(1,n_vv);

%Dertermination of autocovariances
%---------------------------------

%Compute the autocovariances that are contributed by
%the AR part of the proces by introducing a
%realization of that AR proces v. Solving the system
%of Yule-Walker equations with respect to the
%covariances of v provides the desired result.

%Determine lower order AR parameter vectors by
%applying the reversed Levinson Durbin recursion
[ar_stack,rc] = ar2arset_e(ar,[1:ar_order],ASAcontrol);
ar_gain = 1/prod(ones(1,ar_order)-rc.^2);
h_cov_vv(1) = ar_gain;