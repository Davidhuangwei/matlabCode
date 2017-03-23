function [bestpmS,besttz,allpmS,alltz,allcrit] = XEMgaus(x,varargin)

% EM, Clustering EM (CEM) and Stochastic EM (SEM) algorithms
% with Gaussian mixture models. These three algorithms can be
% chained. 14 models of variance matrix are implanted. These models
% and the number of clusters can be choosen by criteria ICL, BIC or NEC.
%
% [bestpmS,besttz,allpmS,alltz,allcrit]	- parameters, partitions, criteria
%                          = XEMgaus(x,	- data
%             ['init','p','mu','S','z',	- initial features of XEM
%            'pfix','mufix,'Sfix,'zfix'	- fix some features
%                  'nbXEM', nbfailXEM',	- nb. of trials and failures of XEM
%         'algo','maxit','cvg','cutSEM'	- features of chained algorithms
%                    'mod','K','crit'])	- models, nbs of clusters, criterion
%
% input: only x is required, other arguments are optional
%	x 	data [d,n] (d: number of variables, n: number of data)
%	init	type of initialization of a trial XEM, possible values are
%		'random centers', 'random partition', 'user parameters' and
%		'user partition', <default init='random centers'>
%	p	mixing proportions used to start a trial XEM [K]
%		(K: number of clusters)
%	mu	centers used to start a trial XEM [d,K]
%	S	variance matrices to start a trial XEM [d,d*K]
%	z	partition to start a trial XEM [n,K]
%	pfix	fix the proportions to the initial value, possible values are
%		'yes' for p fixed, 'no' for p not fixed <default pfix='no'>
%	mufix	fix the centers to the initial value, possible values are 'yes'
%		for mu fixed, 'no' for mu not fixed <default mufix='no'>
%	Sfix	fix the variance matrices to the initial value, possible values
%		are 'yes' for S fixed, 'no' for S not fixed <default Sfix='no'>
%	zfix	fix a part of the given partition,
%		possible values are 'yes' for all partition fixed,
%		'no' for all partition free and a boolean vector [n]
%		indicating which value to fix, <default zfix='no'>
%	nbXEM	number of trials of XEM to avoid starting point dependance,
%		only the trial with the best xml criterion will be retained,
%		if init='user defined' <default nbXEM=1>,
%		otherwise <default nbXEM=5>
%	nbfailXEM number of authorized failures to restart the current trial
%		  of XEM. if init='user defined' <default nbfailXEM=0>,
%		  otherwise <default nbfailXEM=4>
%	algo	algorithms names [nbalgo], possible values
%		are 'EM', 'CEM' and 'SEM', <default algo={'SEM' 'CEM' 'EM'}>
%	maxit	maximum number of iterations for each algorithm of 'algo',
%		[nbalgo] if supplied for each algo or [1] is supplied for all,
%		<default maxit=500>
%	cvg	type of convergence for each algorithm of 'algo',
%		[nbalgo] if supplied for each algo or [1] is supplied for all,
%		possible values are 'xml' for stationarity of the xml criterion,
%		'partition' for stationarity of the partition and 'maxit' for
%		only the number of iterations,
%		<default cvg='xml'> for CEM and <default cvg='maxit'> for EM
%	cutSEM	number of the first iterations to cut for each run of SEM
%		[nbalgo] if supplied for each algo or [1] is supplied for all,
%		it avoids initialization dependance, <default cutSEM=30>
%	mod	models for mixing proportions and variance matrices [nbmod,4],
%		possible values are
%		mixing proportions: 'propequal'	  'propfree'
%		volume: 	    'volequal'	  'volfree'
%		orientation:	    'orientequal' 'orientaxis' 'orientfree'
%		shape:		    'shapespher'  'shapeequal' 'shapefree'
%		<default mod={'propfree' 'volfree' 'orientfree' 'shapefree'}>
%	K	numbers of clusters, <default K=[1:ceil(n^0.3)]>
%	crit	criterion to choose a couple model-number of clusters,
%		available values are 'ICL', 'BIC', 'NEC' and 'CV' (cross. val.),
%		if zfix='yes' <default crit='CV'>, otherwise <default crit='ICL'>
% output:
%	bestpmS	parameters of THE BEST model (selected by the choosen criterion)
%		Fields of the structure array are:
%	     .K	selected number of clusters
%	   .mod	selected model
%	     .p	mixing proportions [K]
%	    .mu	centers [d,K]
%	     .S	variance matrices [d*K,d]
%
%	besttz	posterior probabilities, partition of THE BEST model. Fields are:
%	     .t	posterior probabilities [n,K]
%	     .z	partition [n,K]
%
%	allpmS	parameters of ALL models. Fields are:
%	  .allp	cell of all proportions [nbK,nbmod] of [K]
%	 .allmu	cell of all centers [nbK,nbmod] of [d,K]
%	  .allS	cell of all variance matrices [nbK,nbmod] of [d*K,d]
%
%	alltz	posterior probabilities, partitions of ALL models. Fields are:
%	  .allt	cell of all posterior probabilities [nbK,nbmod] of [n,K]
%	  .allz	cell of all partitions [nbK,nbmod] of [n,K]
%
%	allcrit criteria values of ALL models. Fields are:
%	.allxml	matrix of all xml values [nbK,nbmod]
%		('CEM': max. classification likelihood, 'EM' and 'SEM': m.l.)
%	.allICL	matrix of all ICL values [nbK,nbmod]
%	.allBIC	matrix of all BIC values [nbK,nbmod]
%	.allNEC	matrix of all NEC values [nbK,nbmod]
%	 .allCV	matrix of all NEC values [nbK,nbmod]

% XEMgaus - version 1.0 - Christophe Biernacki - 12 April 1999

% -------------------------
% dimension of the data set
% -------------------------

[d,n] = size(x);

% ----------------------------------------
% control arguments and set default values
% ----------------------------------------

args = controlarg(n,d,varargin);		% control arguments

% ---------------
% initializations
% ---------------

nbmod = length(args.mod(:,1));			% number of models
nbK = length(args.K);				% number of K
cste = 1 / (2*pi)^(d/2);			% normalization constant
if strcmp(args.pfix,'yes')			% pfix is a boolean
  pfix = 1;
else
  pfix = 0;
end
if strcmp(args.mufix,'yes')			% mufix is a boolean
  mufix = 1;
else
  mufix = 0;
end
if strcmp(args.Sfix,'yes')			% Sfix is a boolean
  Sfix = 1;
else
  Sfix = 0;
end
if strcmp(args.zfix,'yes')			% zfix is a boolean
  zfix = 1;
elseif strcmp(args.zfix,'no')
  zfix = 0;
else
  zfix = args.zfix;
end

% ----------------------------------------------------
% tables to store results for each combination k x mod
% ----------------------------------------------------

allp   = cell(nbK,nbmod);			% all p for k x mod
allm   = cell(nbK,nbmod);			% all mu for k x mod
allS   = cell(nbK,nbmod);			% all S for k x mod
allt   = cell(nbK,nbmod);			% all tik for k x mod
allz   = cell(nbK,nbmod);			% all zik for k x mod
allxml = zeros(nbK,nbmod);			% all xml for k x mod
allICL = zeros(nbK,nbmod);			% all ICL for k x mod
allBIC = zeros(nbK,nbmod);			% all BIC for k x mod
allNEC = zeros(nbK,nbmod);			% all NEC for k x mod
allCV  = zeros(nbK,nbmod);			% all CV for k x mod

% -----------------------------------------------------------
% compute xml for the one cluster case: useful to compute NEC
% -----------------------------------------------------------

fprintf(1,'\n-------------------------------------------------\n')
fprintf(1,' Run EM with one cluster (useful for NEC)')
fprintf(1,'\n-------------------------------------------------\n  ')

[p1,mu1,S1] = stepINIT(x,n,d,'user partition',1,args.mu,args.S,...
        ones(n,1),0,0,0,0,2,2,2,3,1,cste);


if ~isSbadcond(d,1,S1)

  % ----------------------------------------------------------------
  % S1 not bad conditionned:
  % pfix, mufix and Sfix may be left only if args.K has only value 1
  % ----------------------------------------------------------------

  if (length(args.K) == 1) & (args.K(1) == 1)
    xml1 = OneAlgo(n,d,1,p1,mu1,S1,ones(n,1),x,2,2,2,3,pfix,mufix,Sfix,0,...
                 cste,'EM',args.maxit(1),'partition',0);
  else
    xml1 = OneAlgo(n,d,1,p1,mu1,S1,ones(n,1),x,2,2,2,3,0,0,0,0,...
                 cste,'EM',args.maxit(1),'partition',0);
  end

else

  % --------------------
  % S1 bad conditionned:
  % xml1 to NaN
  % --------------------

  xml1 = NaN;

end

% --------------
% for each model
% --------------

for imod = 1:nbmod

  [ip,il,iD,iA] = transmod(args.mod(imod,:));	% extraction du modele courant

  % ---------------------------
  % for each number of clusters
  % ---------------------------

  for ik = 1:nbK

    k = args.K(ik);

    % -----------------------------------------------
    % print the model name and the number of clusters
    % -----------------------------------------------

    fprintf(1,'\n-------------------------------------------------\n')
    fprintf(1,' Model: %s %s %s %s\n',...
            args.mod{imod,1},args.mod{imod,2},args.mod{imod,3},args.mod{imod,4})
    fprintf(1,' Number of clusters: %d',k)
    fprintf(1,'\n-------------------------------------------------')

    % --------------------------------------------------
    % initialize some features for this k and this model
    % --------------------------------------------------
    
    nbXEM = 0;					% number of XEM
    xmlopt = NaN;				% values at the optimum run
    popt = []; muopt = []; Sopt = [];
    tikopt = [];
    prevXEMfail = 0;				% is previous XEM failed
    nbfail = 0;

    % -----------------------------------
    % loop for each run of the entire XEM
    % -----------------------------------

    while (nbXEM < args.nbXEM) & (nbfail <= args.nbfailXEM)

      % ------------------------------------------------------------------
      % if previous trial is not a failure : increase the number iteration
      % ------------------------------------------------------------------

      if ~prevXEMfail
        nbXEM = nbXEM + 1;
        nbfail = 0;			% number of fails in this XEM
      end

      prevXEMfail = 0;

      fprintf(1,'\n  XEM %d: ',nbXEM)	% print the number of this run

      % -------------------
      % initialisation step
      % -------------------

        % ---------------------------------------------------------
        % zfix partially fixed: args.z has to be resized for this k
        % ---------------------------------------------------------

        if (length(zfix) > 1)
          kinz = length(args.z(1,:));
          zk = [args.z zeros(n,k-kinz)];
        else
          zk = args.z;
        end

        % ---------------------------------
        % k == 1: init = 'random partition'
        % ---------------------------------

        if (k == 1)
          [p,mu,S] = stepINIT(x,n,d,'random partition',args.p,args.mu,args.S,...
            zk,pfix,mufix,Sfix,zfix,ip,il,iD,iA,k,cste);

        % --------------------------------
        % k ~= 1: init choosen by the user
        % --------------------------------

        else
          [p,mu,S] = stepINIT(x,n,d,args.init,args.p,args.mu,args.S,...
            zk,pfix,mufix,Sfix,zfix,ip,il,iD,iA,k,cste);
        end

      % --------------------------
      % is initial step successful
      % --------------------------

      if isempty(p)
        nbfail = nbfail + 1;
        prevXEMfail = 1;

      % ----------------------
      % all chained algorithms
      % ----------------------

      else

        % -----------------------------
        % k==1: cvg=partition + algo=EM
        % -----------------------------

        if (k == 1)
          [xml,p,mu,S,tik,sumfk] = ChainedAlgo(n,d,k,p,mu,S,args.z,x,...
            ip,il,iD,iA,pfix,mufix,Sfix,zfix,cste,...
            {'EM'},args.maxit,{'partition'},args.cutSEM);
          nbXEM = args.nbXEM;		% and avoid other runs of XEM

        % ----------------------------------------
        % otherwise: no change in the user choices
        % ----------------------------------------

        else
          [xml,p,mu,S,tik,sumfk] = ChainedAlgo(n,d,k,p,mu,S,zk,x,...
            ip,il,iD,iA,pfix,mufix,Sfix,zfix,cste,...
            args.algo,args.maxit,args.cvg,args.cutSEM);
        end

        % --------------------------------
        % is chained algorithms successful
        % --------------------------------

        if isnan(xml)
          nbfail = nbfail + 1;			% increase the number of fails
          prevXEMfail = 1;
        else
          if (xml > xmlopt) | (isnan(xmlopt) & ~isnan(xml))
						% update optimum parameters
            xmlopt = xml;
            popt = p; muopt = mu; Sopt = S; tikopt = tik;
          end
        end

      end

    end % loop each run of XEM

    % --------------------------------------------
    % store parameters of this combination k x mod
    % --------------------------------------------

    allp{ik,imod}   = popt;
    allmu{ik,imod}  = muopt;
    allS{ik,imod}   = Sopt;
    allt{ik,imod}   = tikopt;
    allz{ik,imod}   = stepC(n,k,tikopt);

    % ---------------------------------------------------------------------------
    % fixe la totalite (ou une partie) de allz{ik,imod} a args.z en fonction zfix
    % ---------------------------------------------------------------------------

    if length(zfix) == 1		% la totalite ou rien a fixer a z
      if zfix
         allz{ik,imod} = args.z;	% la totalite
      end
    else				% seulement une partie a fixer a z
      wherechange = find(zfix);
      allz{ik,imod}(wherechange,:) = zk(wherechange,:);
    end

    % ------------------------------------------
    % store criteria of this combination k x mod
    % ------------------------------------------

    allxml(ik,imod) = xmlopt;

    if ~isnan(xmlopt)			% compute criteria only if convergence

      lastalgo = args.algo{end};	% last algorithm of a XEM run

      fprintf(1,'\n  Compute:')

      % -------------
      % ICL criterion
      % -------------

      if ~((length(zfix) == 1) & zfix) | ...  % ICL computed only if not all zfix
         (k==1)                               % or if one cluster
        fprintf(1,' ICL')
        allICL(ik,imod) = calICL(x,tikopt,popt,muopt,Sopt,zk,...
                                pfix,mufix,Sfix,zfix,n,d,k,ip,il,iD,iA,cste);
      else
        allICL(ik,imod) = NaN;
      end

      % -------------
      % BIC criterion
      % -------------

      if ~strcmp(lastalgo,'CEM') | ...	% BIC available only if not CEM in last
        (k==1)				% or if one cluster
        fprintf(1,' BIC')
        allBIC(ik,imod) = calBIC(xmlopt,n,d,k,ip,il,iD,iA,pfix,mufix,Sfix);
      else
        allBIC(ik,imod) = NaN;
      end

      % -------------
      % NEC criterion
      % -------------

      if ~((length(zfix) == 1) & zfix) | ...  % NEC computed only if not all zfix
         (k==1)                               % or if one cluster
        fprintf(1,' NEC')
        allNEC(ik,imod) = calNEC(xmlopt,xml1,tikopt,k);
      else
        allNEC(ik,imod) = NaN;
      end

      % --------------------------
      % Cross Validation criterion
      % --------------------------

      if (length(zfix) == 1) & zfix	% CV computed only if all zfix
        fprintf(1,' CV')
        allCV(ik,imod) = valcrois(n,d,k,popt,muopt,Sopt,zk,...
                                  pfix,mufix,Sfix,x,ip,il,iD,iA,cste);
      else
        allCV(ik,imod)  = NaN;		% else CV is put ti NaN
      end

    else

      % ----------------------------------------------
      % all criteria are put to NaN is not convergence
      % ----------------------------------------------

      allICL(ik,imod) = NaN;
      allBIC(ik,imod) = NaN;
      allNEC(ik,imod) = NaN;
      allCV(ik,imod)  = NaN;
    end

  end % K

end % mod

% ----------------------------------------------------------------
% model and number of clusters selected by the specified criterion
% ----------------------------------------------------------------

switch args.crit

  case 'ICL', valcrit = allICL;
  case 'BIC', valcrit = allBIC;
  case 'NEC', valcrit = allNEC;
  case 'CV',  valcrit = allCV;

end

mincrit = min(min(valcrit));		% minimum of the criterion
[ik,imod] = find(valcrit == mincrit);	% indice of number of K and model
if ~isempty(ik)				% if not only NaN for this criterion
  ik = ik(1);				% avoid multiple returns
  imod = imod(1);			% by retaining the first response
end

K = args.K(ik);				% number of K
mod = args.mod(imod,:);			% name of the model

% -------------------------------------------------------
% give values of parameters corresponding to this model,K
% -------------------------------------------------------

t  = [allt{ik,imod}];
z  = [allz{ik,imod}];
p  = [allp{ik,imod}];
mu = [allmu{ik,imod}];
S  = [allS{ik,imod}];

% -----------------------------
% put all results in structures
% -----------------------------

bestpmS = struct('K',{K},'mod',{mod},'p',{p},'mu',{mu},'S',{S});
besttz = struct('t',{t},'z',{z});
allpmS = struct('allp',{allp},'allmu',{allmu},'allS',{allS});
alltz  = struct('allt',{allt},'allz',{allz});
allcrit = struct('allxml',{allxml},'allICL',{allICL},'allBIC',{allBIC},'allNEC',{allNEC},'allCV',{allCV});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %
 %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %
  %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %
   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %  
%   %   %   %   %   %   %   %  SUBFUNCTIONS %   %   %   %   %   %   %   %   %  
 %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %
  %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %
   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   
%   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %   %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%	ALGORITHMS
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

% =============================================================================
% 	subfunction ChainedAlgo
% =============================================================================

function [xml,p,mu,S,tik,sumfk] = ChainedAlgo(n,d,k,p,mu,S,z,x,ip,il,iD,iA,pfix,mufix,Sfix,zfix,cste,algo,maxit,cvg,cutSEM)

% [xml,p,mu,S,tik,sumfk] = ChainedAlgo(n,d,k,p,mu,S,z,x,ip,il,iD,iA,pfix,mufix,Sfix,zfix,cste,algo,maxit,cvg,cutSEM)
% Run many chained algorithms (EM, CEM or SEM)
% entrees :
%	n nombre de points
%	d dimension de l'espace
%	k nombre de classes cherchees
%	p proportions initiales (k x 1)
%	mu centres initiaux des k classes (d x k)
%	S matrices de variance-covariance initiales (d*k x d)
%	z partition utile en fonction des valeurs de zfix (n x k)
%	x echantillon (d x n)
%	ip 1-proportions egales 2-proportions differentes
%	il 1-volumes egaux 2-volumes differents
%	iD 1-orientations egales 2-orientations differentes 3-suivant axes
%	iA 1-formes spheriques 2-ellipses egales 3-ellipses differentes
%	pfix proportions fixes ou non
%	mufix centres fixes ou non
%	Sfix matrices de variance fixes ou non
%	zfix partition fixee completement (ou partiellement) a z ou non
%	cste 1 / (2*pi)^(d/2)
%	algo liste d'algorithmes a chainer ('EM', 'CEM' ou 'SEM')
%	maxit nombre maximum d'iterations pour chaque algo
%	cvg type de convergence pour chaque algo ('xml' ou 'partition')
%	cutSEM 1ere partie de la chaine a supprimer pour chq. algo (cas de SEM)
% sorties :
%	xml critere xml optimise
%	mu centres des k classes (d x k)
%	p proportions (k x 1)
%	S matrices de variance-covariance (d*k x d)
%	tik matrice des probabilites a posteriori (n x k)
%	sumfk vecteur de somme des lignes de fik (1 x n)

nbalgo = length(algo);		% nombre d'algorithmes a chainer

for i = 1:nbalgo
  [xml,p,mu,S,tik,sumfk] = OneAlgo(n,d,k,p,mu,S,z,x,ip,il,iD,iA,...
                                   pfix,mufix,Sfix,zfix,cste,...
                                   algo{i},maxit(i),cvg{i},cutSEM(i));
  if isnan(xml)		% si l'algo courant n'a pas converger
    return		% alors on arrete la chaine en sortant de la fonction
  end
end

% =============================================================================
% 	subfunction OneAlgo
% =============================================================================

function [xml,p,mu,S,tik,sumfk] = OneAlgo(n,d,k,p,mu,S,z,x,ip,il,iD,iA,pfix,mufix,Sfix,zfix,cste,algo,maxit,cvg,cutSEM)

% [xml,p,mu,S,tik,sumfk] = OneAlgo(n,d,k,p,mu,S,z,x,ip,il,iD,iA,pfix,mufix,Sfix,zfix,cste,algo,maxit,cvg,cutSEM)
% Run one algorithm: EM, CEM or SEM
% entrees :
%	n nombre de points
%	d dimension de l'espace
%	k nombre de classes cherchees
%	p proportions initiales (k x 1)
%	mu centres initiaux des k classes (d x k)
%	S matrices de variance-covariance initiales (d*k x d)
%	z partition utile en fonction des valeurs de zfix (n x k)
%	x echantillon (d x n)
%	ip 1-proportions egales 2-proportions differentes
%	il 1-volumes egaux 2-volumes differents
%	iD 1-orientations egales 2-orientations differentes 3-suivant axes
%	iA 1-formes spheriques 2-ellipses egales 3-ellipses differentes
%	pfix proportions fixes ou non
%	mufix centres fixes ou non
%	Sfix matrices de variance fixes ou non
%	zfix partition fixee completement (ou partiellement) a z ou non
%	cste 1 / (2*pi)^(d/2)
%	algo type d'algorithme : 'EM', 'CEM' ou 'SEM'
%	maxit nombre maximum d'iterations
%	cvg type de convergence : 'xml' ou 'partition'
%	cutSEM 1ere partie de la chaine a supprimer (cas de SEM)
% sorties :
%	xml critere xml optimise
%	mu centres des k classes (d x k)
%	p proportions (k x 1)
%	S matrices de variance-covariance (d*k x d)
%	tik matrice des probabilites a posteriori (n x k)
%	sumfk vecteur de somme des lignes de fik (1 x n)

fprintf(1,'[%s',algo)


% ---------------
% INITIALISATIONS
% ---------------

nbit = 0;		% nombre d'iterations
xmlold = -inf;		% critere xml de la precedente iteration
cikold = zeros(n,k);	% partition floue cik de la precedente iteration
iscvg = 0;		% la convergence est-elle atteinte ?
pSEM = cell(1,maxit);	% stockage des p de SEM
muSEM = cell(1,maxit);	% stockage des mu de SEM
SSEM = cell(1,maxit);	% stockage des S de SEM

% ---------------------------------------------------------------
% fixe la totalite (ou une partie) de cikold a z en fonction zfix
% ---------------------------------------------------------------

if length(zfix) == 1			% la totalite ou rien a fixer a z
  if zfix
    wherechange = 1:n;			% la totalite
  else
    wherechange = [];			% rien
  end
else					% seulement une partie a fixer a z
  wherechange = find(zfix);
end
if ~isempty(wherechange)
  cikold(wherechange,:) = z(wherechange,:);	% affectation
end

% ----------
% ITERATIONS
% ----------

while (~iscvg & (nbit < maxit))

  % ---------------------------------------------------------
  % incremente nbit et affiche nbit toutes les 100 iterations
  % ---------------------------------------------------------

  nbit = nbit + 1;
  if (mod(nbit,100) == 0) & (nbit ~= maxit)
    fprintf(1,'.%d',nbit);
  end

  % ---------------------
  % ETAPE E : expectation
  % ---------------------

  [fik,tik,sumfk,logfik] = stepE(n,d,k,p,mu,S,x,cste);
  cik = tik;	% partition floue

  % ------------------------
  % ETAPE C : classification
  % ------------------------

  if strcmp(algo,'CEM')
    cik = stepC(n,k,tik);

  % -------------------------------------
  % ETAPE S : classification stochastique
  % -------------------------------------

  elseif strcmp(algo,'SEM')
    cik = stepS(n,k,tik);
  end

  % ------------------------------------------------------------
  % fixe la totalite (ou une partie) de cik a z en fonction zfix
  % ------------------------------------------------------------

  if ~isempty(wherechange)
    cik(wherechange,:) = z(wherechange,:);	% affectation
  end

  % ---------------------
  % cas d'une classe vide
  % ---------------------

  nk = sum(cik);			% population floue
  if isemptycluster(nk)
    warning('---------- Empty clusters ----------')
    xml = NaN;				% critere a NaN
    p = []; mu = []; S = [];		% les parametres vides
    tik = []; sumfk = [];
    return				% sort de la fonction
  end

  % ----------------------
  % ETAPE M : maximisation
  % ----------------------

  [p,mu,S] = stepM(n,d,k,x,ip,il,iD,iA,cik,nk,p,mu,S,pfix,mufix,Sfix);

  % ----------------------------------------------
  % cas d'une matrice de variance mal conditionnee
  % ----------------------------------------------

  if isSbadcond(d,k,S)
    warning('---------- Bad condionned variance matrices ----------')
    xml = NaN;				% critere a NaN
    p = []; mu = []; S = [];		% les parametres vides
    tik = []; sumfk = [];
    return				% sort de la fonction
  end

  % ---------------------
  % calcul du critere xml
  % ---------------------

  xml = sum(sum(cik .* logfik)) + calentro(cik);

  % --------------------------------------------------------------
  % evaluation de la convergence ou stockage de la chaine pour SEM
  % --------------------------------------------------------------

  if ~strcmp(algo,'SEM')	% cas de EM et CEM
    if (strcmp(cvg,'xml') & (abs(xml-xmlold) <= 1e-3)) | ...
       (strcmp(cvg,'partition') & all(all(stepC(n,k,cik) == stepC(n,k,cikold))))
      iscvg = 1;
    end
  else				% cas de SEM :  stockage des parametres
    pSEM{nbit} = p;
    muSEM{nbit} = mu;
    SSEM{nbit} = S;
  end

  % ----------------------------------------------------------
  % mise a jour des caracteristiques de l'iteration precedente
  % ----------------------------------------------------------

  xmlold = xml;			% critere
  cikold = cik;			% partition

end

% --------------------------------------------------------------------------
% les iterations sont finies : dans le cas de SEM il faut moyenner les para.
% --------------------------------------------------------------------------

if strcmp(algo,'SEM')
  p = 0*p;
  mu = 0*mu;
  S = 0*S;
  for i = (cutSEM+1):maxit	% add parameters between sutSEM et maxit iterations
    p  = p  + pSEM{i};
    mu = mu + muSEM{i};
    S  = S  + SSEM{i};
  end
  p  = p  / (maxit - cutSEM);	% moyenne les parametres
  mu = mu / (maxit - cutSEM);
  S  = S  / (maxit - cutSEM);
end

fprintf(1,'.%d] ',nbit)

%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%	THE STEPS OF THE ALGORITMS
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

% =============================================================================
% 	subfunction stepE
% =============================================================================

function [fik,tik,sumfk,logfik,logtik,logsumfk] = stepE(n,d,k,p,mu,S,x,cste)

% [fik,tik,sumfk,logfik,logtik,logsumfk] = setpE(n,d,k,p,mu,S,x,cste)
% phase d'EXPECTATION de l'algorithme EM
% entrees :
%	n nombre de points
%	d dimension de l'espace
%	k nombre de classes cherchees
%	p proportions (k x 1)
%	mu centres (d x k)
%	S matrices de variances (d*k x d)
%	x echantillon (d x n)
%	cste 1 / (2*pi)^(d/2)
% sorties :
%	fik matrice fik = pk * f(xi,muk,Sk) (n x k)
%	tik matrice des probabilites a posteriori (n x k)
%	sumfk vecteur de somme des lignes de fik (1 x n)
%	logfik matrice log(fik) (n x k) (calcul plus sur du log(fik))
%	logtik matrice log(tik) (n x k) (calcul plus sur du log(tik))
%	logsumfk vecteur log(sumfk) (1 x n) (calcul plus sur du log(sumfk))

% calcul des fik = pk * f(xi,mu,S) (n x k) et de logfik
% -----------------------------------------------------

fik = zeros(n,k);
logfik = zeros(n,k);
for j = 1:k
	Sj = extm(S,j,d);
        [tmp1,tmp2] = gausfast(cste,mu(:,j),Sj,x,d,n);
	fik(:,j) = p(j) * tmp1';
        logfik(:,j) = log(p(j)) + tmp2';
end

% logfik2 : logfik avec une permutation du max de chaque ligne avec la colonne 1
% (utile pour limiter les problemes numeriques dans le calcul des logsumfk)
% ------------------------------------------------------------------------------

logfik2 = logfik;
[tmp,ikmax] = max(logfik2,[],2);% ikmax : colonne des max pour chaque ligne
ind = sub2ind([n,k],1:n,ikmax')';% ind : indice des max ds le vecteur logfik2(:)
tmp = logfik2(:,1);		% tmp : 1ere colonne de logfik2
logfik2(:,1) = logfik2(ind); 	% 1ere colonne logfik2 remplacee par les max
logfik2(ind) = tmp';		% les places des max remplacees par la 1ere col.

% calcul des logsumfk (1 x n)
% ---------------------------

logsumfk = (logfik2(:,1) + log(ones(n,1) + ...
  sum(exp(logfik2(:,2:k) - logfik2(:,1)*ones(1,k-1)),2)))';

% calcul des logtik (n x k)
% -------------------------

logtik = logfik - logsumfk'*ones(1,k);

% calcul des tik (n x k)
% ----------------------

tik = exp(logtik);

% calcul des sumfk (1 x n)
% ------------------------

sumfk = exp(logsumfk);

% ------------------
% ANCIENNES VERSIONS
% ------------------

% calcul des tik (n x k)
% ----------------------

%tik = zeros(n,k);
%sumfk = sum([fik' ; zeros(1,n)]);
% vectorisation pour eviter le for
%tabsumfk = kron(ones(1,k),sumfk');
%tik = fik ./ tabsumfk;

% correction des tik
% ------------------
% ATTENTION : les tik a NaN sont dus a des sumfk egaux a zeros.
% On pose alors le tik avec le logfik le plus grand a 1, les autres a 0.

%whereNaN = find(isnan(tik(:,1)));
%if ~isempty(whereNaN)
%  tik(whereNaN,:) = c(length(whereNaN),k,logfik(whereNaN,:));
%end


% ancienne version
%for i = 1:n
%	tik(i,:) = fik(i,:) / sumfk(i);
%end

% =============================================================================
% 	subfunction stepC
% =============================================================================

function zik = stepC(n,k,tik)

% function zik = stepC(n,k,tik)
% etape C de CEM : M.A.P. des tik
% entrees :
%	n nombre de points
%	k nombre de classes
%	tik matrice d'appartenance des points aux classes (n x k)
% sorties :
%	zik matrice des tik seuillee par M.A.P. (n x k)

% si NaN dans tik alors zik est NaN aussi et fin de la fonction
if any(any(~isfinite(tik)))
  zik = NaN * tik;
  return
end

% appartenance des points aux classes
[maxtik,clas] = max([tik';-Inf*ones(1,n)]);

% fabrication de la matrice zik
zik = tik;
for j = 1:k
	zik(:,j) = (clas==j)'; 
end

% =============================================================================
% 	subfunction stepS
% =============================================================================

function zik = stepS(n,k,tik)

% function zik = stepS(n,k,tik)
% etape S de SEM : tirage d'une partition suivant les tik
% entrees :
%	n nombre de points
%	k nombre de classes
%	tik matrice d'appartenance des points aux classes (n x k)
% sorties :
%	zik partition tiree de tik (n x k)

% si NaN dans tik alors zik est NaN aussi et fin de la fonction
if any(any(~isfinite(tik)))
  zik = NaN * tik;
  return
end

% somme cumulee des tik sur chaque ligne
cumtik = cumsum(tik,2);

% matrice (n x k) de n nombres uniformes sur [0,1]
tire = rand(n,1)*ones(1,k);

% partition
zik = (cumsum(cumtik >= tire,2) == 1); 

% =============================================================================
% 	subfunction stepM
% =============================================================================

function [p,mu,S,Wk,W] = stepM(n,d,k,x,ip,il,iD,iA,tik,nk,pold,muold,Sold,pfix,mufix,Sfix)

% [p,mu,S,Wk,W] = stepM(n,d,k,x,ip,il,iD,iA,tik,nk,pold,muold,Sold,pfix,mufix,Sfix)
% phase de MAXIMISATION de l'algorithme XEM
% entrees :
%	n nombre de points
%	d dimension de l'espace
%	k nombre de classes cherchees
%	x echantillon (d x n)
%	ip 1-proportions egales 2-proportions differentes
%	il 1-volumes egaux 2-volumes differents
%	iD 1-orientations egales 2-orientations differentes 3-suivant axes
%	iA 1-formes spheriques 2-ellipses egales 3-ellipses differentes
%	tik matrice des probabilites a posteriori (n x k)
%	nk population floue de chaque classe (k x 1)
%	pold proportions precedentes (k x 1)
%	muold centres precedents des k classes (d x k)
%	Sold matrices de variance-covariance precedentes (d*k x d)
%	pfix proportions fixees
%	mufix centres fixees
%	Sfix matrices de variance fixees
% sorties :
%	p proportions (k x 1)
%	mu centres des k classes (d x k)
%	S matrices de variance-covariance (d*k x d)
%	Wk within scattering matrix of each cluster (k*d x d)
%	W within cluster scattering matrix (d x d)


% REMARQUE : la maximisation  depend du modele choisi

% --------------------------------
% calcul des proportions si libres
% --------------------------------

if (ip == 1) | pfix
  p = pold;
else
  p = nk / n;
end

% ----------------------------
% calcul des centres si libres
% ----------------------------

if mufix
  mu = muold;
else
  mu = x*tik;
  for j = 1:k
    mu(:,j) = mu(:,j) / nk(j);
  end
end

% ------------------------------
% calcul des matrices (d x d) Wk
% ------------------------------

Wk = zeros(k*d,d);
a = x;
for j = 1:k
  % centrage de l'echantillon en mu(:,j)
  for i = 1:d
    a(i,:) = x(i,:) - mu(i,j);
  end
  % calcul vectorise de Wk
  Wtmp = (a.* kron(ones(d,1),tik(:,j)')) * a';
  Wk = putm(Wk,Wtmp,j,d);
end

% ------------------------------
% calcul de la matrice W (d x d)
% ------------------------------

W = zeros(d,d);
for j = 1:k
  W = W + extm(Wk,j,d);
end

% -----------------------------------------
% calcul des matrices de variance si libres
% -----------------------------------------

if Sfix

  S = Sold;

else

  % -------------------------------------------
  % calcul des matrices S en fonction du modele
  % -------------------------------------------

  % si formes spheriques
  % ....................
  if iA == 1
    % si volumes egaux
    % ................
    if il == 1
      S = lI(W,k,n,d);%disp('lI')			% [lI]
    % si volumes differents
    % .....................
    else
      S = lkI(Wk,k,nk,d);%disp('lkI')			% [lkI]
    end
  % si formes ellipses identiques
  % .............................
  elseif iA == 2
    % si volumes egaux
    % ................
    if il == 1
      % si orientations egales
      % ......................
      if iD == 1
        S = lC(W,k,n,d);%disp('lC')			% [lC]
      % si orientations differentes
      % ...........................
      elseif iD == 2
        S = lDkADk(Wk,k,n,d);%disp('lDkADk')		% [lDkADk]
      % si orientations suivant axes
      % ............................
      else
        S = lB(W,k,n,d);%disp('lB')			% [lB]
      end
    % si volumes differents
    % .....................
    else
      % si orientations egales
      % ......................
      if iD == 1
        S = lkC(Wk,k,nk,d,Sold);%disp('lkC')		% [lkC]
      % si orientations differentes
      % ...........................
      elseif iD == 2
        S = lkDkADk(Wk,k,nk,d,Sold);%disp('lkDkADk')	% [lkDkADk]
      % si orientations suivant axes
      % ............................
      else
        S = lkB(Wk,k,nk,d,Sold);%disp('lkB')		% [lkB]
      end
    end
  % si formes ellipses differentes
  % ..............................
  else
    % si volumes egaux
    % ................
    if il == 1
      % si orientations egales
      % ......................
      if iD == 1
        S = lDAkD(Wk,k,n,d,Sold);%disp('lDAkD')		% [lDAkD]
      % si orientations differentes
      % ...........................
      elseif iD == 2
        S = lCk(Wk,k,n,d);%disp('lCk')			% [lCk]
      % si orientations suivant axes
      % ............................
      else
        S = lBk(Wk,k,n,d);%disp('lBk')			% [lBk]
      end
    % si volumes differents
    % .....................
    else
      % si orientations egales
      % ......................
      if iD == 1
        S = lkDAkD(Wk,k,nk,d,Sold);%disp('lkDAkD')	% [lkDAkD]
      % si orientations differentes
      % ...........................
      elseif iD == 2
        S = lkCk(Wk,k,nk,d);%disp('lkCk')		% [lkCk]
      % si orientations suivant axes
      % ............................
      else
        S = lkBk(Wk,k,nk,d);%disp('lkBk')		% [lkBk]
      end
    end
  end
end

% =============================================================================
% 	subfunction gausfast
% =============================================================================

function [y,logy] = gausfast(cste,mu,S,x,d,n,invS,detS)

% function [y,logy] = gausfast(cste,mu,S,x,d,n[,invS,detS])
% calcule la densite de tous les x de N(mu,S) (version vectorisee de gauss.m)
% entrees :
%	cste 1 / (2*pi)^(d/2)
%	mu vecteur moyenne (d x 1)
%	S matrice de variance-covariance (d x d)
%	x echantillon (d x n)
%	d dimension de l'espace
% 	n nombre de points
%	invS OPTIONNEL : inverse de S (d x d)
%	detS OPTIONNEL : determinant de S
% !!!   invS et detS sont soit fournis tous les 2, soit aucun n'est fourni
% sorties :
%	y vecteur des densites pour chaque point x(:,i) (1 x n)
%	logy vecteur des log-densites pour chaque point x(:,i) (1 x n) (pour eviter pbs numeriques)


% initialisations : si invS et detS non fournis, les calculer
if (nargin == 6)
	invS = inv(S);
	detS = det(S);
end

% en cas de determinant trop petit (voir <0 !), on arrete et renvoi des NaN

if detS < eps
  y = NaN * zeros(1,n);
  logy = y;
  return
end


% centrage de l'echantillon en mu

a = x;
for i = 1:d
	a(i,:) = x(i,:) - mu(i);
end


% calcul de -0.5 * a' * inv(S) * a   par vectorisation

b = -0.5 * sum([ (invS * a) .* a ; zeros(1,n) ]);

% calcul du vecteur de densites

logy = log(cste) + b - log(sqrt(detS));
y = cste * exp(b) / sqrt(detS);

%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%	CRITERIA
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

% =============================================================================
% 	subfunction calentro
% =============================================================================

function entro = calentro(tik)

% entro = calentro(tik)
% calcul de l'ENTROPIE
% entrees :
%	tik matrice des probabilites a posteriori (n x k)
% sorties :
%	entro entropie

entro = - sum(sum(tik.*log(max(tik,1e-300))));

% =============================================================================
% 	subfunction caldeglb
% =============================================================================

function deglib = caldeglb(d,k,ip,il,iD,iA,pfix,mufix,Sfix)

% deglib = caldeglb(d,k,ip,il,iD,iA,[pfix,mufix,Sfix])
% calcule le nombre de degres de liberte du modele
% entrees :
%	d dimension de l'espace
%	k nombre de classes cherche
%	ip 1-proportions egales 2-proportions differentes
%	il 1-volumes egaux 2-volumes differents
%	iD 1-orientations egales 2-orientations differentes 3-suivant axes
%	iA 1-formes spheriques 2-ellipses egales 3-ellipses differentes
%	pfix proportions fixes OPTIONNEL (defaut 0)
%	mufix centres fixes OPTIONNEL (defaut 0)
%	Sfix matrices de variance fixes OPTIONNEL (defaut 0)
% sorties :
%	deglib nombre de degres de liberte

% arguments par defaut
% --------------------

if nargin == 6
  pfix = 0;
  mufix = 0;
  Sfix = 0;
end

% centres
% -------
if mufix
  deglib = 0;
else
  deglib = k * d;
end;

% proportions
% -----------
if (ip ~= 1) & ~pfix
	deglib = deglib + k - 1;
end

% variance matrices
% -----------------

if ~Sfix

% volumes
% -------
if il == 1
	deglib = deglib + 1;
else
	deglib = deglib + k;
end

% orientations
% ------------
if iA ~= 1
	if iD == 1
		deglib = deglib + d*(d-1)/2;
	elseif iD == 2
		deglib = deglib + k*d*(d-1)/2;
	end
end

% formes
% ------
if iA == 2
	deglib = deglib + d - 1;
elseif iA == 3
	deglib = deglib + k * (d - 1);
end

end

% =============================================================================
% 	subfunction calBIC
% =============================================================================

function BIC = calBIC(xml,n,d,k,ip,il,iD,iA,pfix,mufix,Sfix)

% BIC = calBIC(xml,n,d,k,ip,il,iD,iA,pfix,mufix,Sfix)
% Calcul du critere BIC
% entrees :
%	xml maximum de vraisemblance
%	n nombre de donnees
%	d dimension de l'espace
%	k nombre de classes cherche
%	ip 1-proportions egales 2-proportions differentes
%	il 1-volumes egaux 2-volumes differents
%	iD 1-orientations egales 2-orientations differentes 3-suivant axes
%	iA 1-formes spheriques 2-ellipses egales 3-ellipses differentes
%	pfix proportions fixes OPTIONNEL (defaut 0)
%	mufix centres fixes OPTIONNEL (defaut 0)
%	Sfix matrices de variance fixes OPTIONNEL (defaut 0)
% sorties :
%	BIC critere BIC

deglib = caldeglb(d,k,ip,il,iD,iA,pfix,mufix,Sfix);
BIC = -2*xml + log(n)*deglib;

% =============================================================================
% 	subfunction calNEC
% =============================================================================

function NEC = calNEC(xml,xml1,tik,k)

% NEC = calNEC(xml,xml1,tik,k)
% Calcul du critere NEC
% entrees :
%	xml maximum de vraisemblance a k classes
%	xml1 maximum de vraisemblance pour une seule classe
%	tik probabilites a posteriori par m.v. a k classes
%	k nombre de classes
% sorties :
%	NEC critere NEC

if k ~= 1
  NEC = calentro(tik) / (xml - xml1);
else
  NEC = 1;
end

% =============================================================================
% 	subfunction calICL
% =============================================================================

function ICL = calICL(x,tik,p,mu,S,z,pfix,mufix,Sfix,zfix,n,d,k,ip,il,iD,iA,cste)

% ICL = calICL(x,tik,p,mu,S,z,pfix,mufix,Sfix,zfix,n,d,k,ip,il,iD,iA,cste)
% Calcul du critere ICL sans l'approximation de Stirling et avec une loi de Jeffreys
% entrees :
%	x echantillon (d x n)
%	tik matrice des probabilites a posteriori (n x k)
%	p proportions initiales (k x 1)
%	mu centres initiaux des k classes (d x k)
%	S matrices de variance-covariance initiales (d*k x d)
%	z partition utile en fonction des valeurs de zfix (n x k)
%	pfix proportions fixes ou non
%	mufix centres fixes ou non
%	Sfix matrices de variance fixes ou non
%	zfix partition fixee completement (ou partiellement) a z ou non
%	n nombre de points
%	d dimension de l'espace
%	k nombre de classes
%	ip 1-proportions egales 2-proportions differentes
%	il 1-volumes egaux 2-volumes differents
%	iD 1-orientations egales 2-orientations differentes 3-suivant axes
%	iA 1-formes spheriques 2-ellipses egales 3-ellipses differentes
%	cste 1 / (2*pi)^(d/2)
% sorties :
%       ICL critere ICL

% -------------------------
% partition obtenue par MAP
% -------------------------

zik = stepC(n,k,tik);

% ------------------------------------------------------------
% fixe la totalite (ou une partie) de zik a z en fonction zfix
% ------------------------------------------------------------

if length(zfix) == 1			% la totalite ou rien a fixer a z
  if zfix
    zik = z;				% la totalite
  end
else					% seulement une partie a fixer a z
  wherechange = find(zfix);
  zik(wherechange,:) = z(wherechange,:);
end

% ---------------------------
% nombre de points par classe
% ---------------------------

nk = sum(zik);

% -----------------------------------
% estime p, mu, S avec la partition z
% -----------------------------------

[p,mu,S] = stepINIT(x,n,d,'user partition',p,mu,S,zik,pfix,mufix,Sfix,zfix,ip,il,iD,iA,k,cste);

% ----------------------------------------------------------------
% calcule les logfik si aucune matrice de variance n'est degeneree
% ----------------------------------------------------------------

if isSbadcond(d,k,S)
  warning('---------- Bad condionned variance matrices ----------')
  ICL = NaN;				% critere a NaN
  return				% sort de la fonction
else
  [fik,tik,sumfk,logfik] = stepE(n,d,k,p,mu,S,x,cste);
end

% -------------------------------------
% calcule la vraisemblance classifiante
% -------------------------------------

CL = sum(sum(zik.*logfik));

% -----------------------------------------
% max vraisemblance classifiante restreinte
% -----------------------------------------

tmp = ones(n,1) * log(p);
CLR = CL - sum(sum(zik .* tmp)); % deduction de CLR a partir de CL

% ---------------------------------------------
% degres de liberte centres + matrices variance
% ---------------------------------------------

degautre = caldeglb (d,k,1,il,iD,iA,pfix,mufix,Sfix); % ip est fixe a 1

% ----------------------------------
% ICL si les proportions sont FIXEES
% ----------------------------------

if (ip == 1) | pfix
  ICL = -2*CL + degautre*log(n);

% ----------------------------------
% ICL si les proportions sont LIBRES
% ----------------------------------
 
else

  % --------------------------------
  % initialisation des penalisations
  % --------------------------------

  penak = zeros(1,k); % penalisations log(gamma(nk+1/2))
  pena = 0; % penalisation log(gamma(n+k/2))

  % ----------------
  % calcul des penak
  % ----------------

  for j = 1:k
    if nk(j) > 100
      penak(j) = nk(j) *log(nk(j)-0.5) - (nk(j)-0.5) + 0.5*log(2*pi); % approx. par Stirling
    else
      penak(j) = log(gamma(nk(j)+0.5)); % pas d'approx.
    end
  end

  % --------------
  % calcul de pena
  % --------------

  if n > 100
    pena = (n+k/2-0.5)*log(n+k/2-1) - (n+k/2-1) + 0.5*log(2*pi); % approx. par Stirling
  else
    pena = log(gamma(n+k/2)); % pas d'approx.
  end

  % -------------
  % calcul de ICL
  % -------------

  ICL = -2*CLR  + degautre*log(n) - 2*log(gamma(k/2)) + k*log(pi) - 2*sum(penak) + 2*pena; 
end
% =============================================================================
% 	subfunction valcrois
% =============================================================================

function ProbEr = valcrois(n,d,k,p,mu,S,z,pfix,mufix,Sfix,x,ip,il,iD,iA,cste)

% ProbEr = valcrois(n,d,k,p,mu,S,z,pfix,mufix,Sfix,x,ip,il,iD,iA,cste)
% Estime par validation croisee la probabilite d'erreur avec le modele donne
% entrees :
%       n nombre de points
%       d dimension de l'espace
%       k nombre de classes
%	p proportions initiales (k x 1)
%	mu centres initiaux des k classes (d x k)
%	S matrices de variance-covariance initiales (d*k x d)
%	z partition (fixe ici) (n x k)
%	pfix proportions fixes ou non
%	mufix centres fixes ou non
%	Sfix matrices de variance fixes ou non
%       x echantillon (d x n)
%       ip 1-proportions egales 2-proportions differentes
%       il 1-volumes egaux 2-volumes differents
%       iD 1-orientations egales 2-orientations differentes 3-suivant axes
%       iA 1-formes spheriques 2-ellipses egales 3-ellipses differentes
%       cste 1 / (2*pi)^(d/2)
% sorties :
%	ProbEr probabilite d'erreur (nombre de points mal classes)

% -----------------------------------------------------
% transforme z en un vecteur des numeros d'appartenance
% -----------------------------------------------------

clas = zik_clas(z,n,k);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% estimation des parametres par maximum de vraisemblance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ---------------------------
% nombre de points par classe
% ---------------------------

nk = sum(z,1);

% -----------------------------------
% estime p, mu, S avec la partition z
% -----------------------------------

[p,mu,S,Wk,W] = stepINIT(x,n,d,'user partition',p,mu,S,z,pfix,mufix,Sfix,1,ip,il,iD,iA,k,cste);

% -----------------------------------------------------------------------
% le critere de validation croisee est NaN si une Sk est mal conditionnee
% -----------------------------------------------------------------------

if isSbadcond(d,k,S)
  warning('---------- Bad condionned variance matrices ----------')
  ProbEr = NaN;				% critere a NaN
  return				% sort de la fonction
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialisations diverses : calcul des inverses ...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% determinant et inverse des Wk
% -----------------------------
detWk = zeros(1,k);
invWk = zeros(k*d,d);
for j = 1:k
	Wktmp = extm(Wk,j,d);
	detWk(j) = det(Wktmp);
	invWk = putm(invWk,inv(Wktmp),j,d);
end

% determinant et inverse de W
% ---------------------------
detW = det(W);
invW = inv(W);

% concernant la validation croisee
% --------------------------------
p_i = p; 		% proportions
n_i = n-1; 		% echantillon de taille n-1
mal_classes = 0;	% nombre de points mal classes
invB = eye(d);		% inverse matrice B (modele [lkB])

% si S fixes alors on calcule une seule fois les traces et det des Sk
% -------------------------------------------------------------------

invS_i = zeros(d*k,d);
detS_i = zeros(1,k);
if Sfix
  for j = 1:k
    Sk = extm(S,j,d);
    invS_i = putm(invS_i,inv(Sk),j,d);
    detS_i(j) = det(Sk);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pour chacun des n points
%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:n

  % point y=xi que l'on enleve a l'echantillon
  % ------------------------------------------
  y = x(:,i);

  % classe du point i
  % -----------------
  k_i = clas(i);

  % nouvel echantillon prive du point xi
  % ------------------------------------
  x_i = x(:,[1:i-1,i+1:n]);

  % actualisation de nk de la classe k_i
  % ------------------------------------
  nk_i = nk;
  nk_i(k_i) = nk_i(k_i)-1;

  % --------------------------------
  % actualisation des pk (si libres)
  % --------------------------------
  if (ip == 2) & ~pfix
    p_i = nk_i / n_i;
  end

  % -------------------------------------------------
  % actualisation du centre de la classe k_i si libre
  % -------------------------------------------------

  mu_i = mu;
  if ~mufix
    mu_i(:,k_i) = (nk(k_i)*mu(:,k_i) - y) / nk_i(k_i);
  end

  % -----------------------------------------------------
  % actualisation liee aux matrices de variance si libres
  % -----------------------------------------------------

  % flag indiquant si calcul rapide direct de invS_i et detS_i (oui par defaut)
  invdet_fast = 1;
  
  if ~Sfix

    % calcul de h et h*h' (NB : h est complexe)
    % -------------------
    h = sqrt(-nk(k_i) / nk_i(k_i)) * (y - mu(:,k_i));
    hh = h * h.';
  
    % actualisation de Wk
    % -------------------
    Wktmp = extm(Wk,k_i,d);	
    Wktmp = Wktmp + hh;
    Wk_i = putm(Wk,Wktmp,k_i,d);
  
    % actualisation de inv(Wk)
    % ------------------------
    invWktmp = extm(invWk,k_i,d);
    unplushinvWkh = 1 + h.'*invWktmp*h;
    invWkh = invWktmp*h;
    invWktmp = invWktmp - (invWkh*invWkh.') / unplushinvWkh;
    invWk_i = putm(invWk,invWktmp,k_i,d);
  
    % actualisation de det(Wk)
    % ------------------------
    detWk_i = detWk;
    detWk_i(k_i) = detWk(k_i) * unplushinvWkh;
  
    % actualisation de W
    % ------------------
    W_i = W + hh;
  
    % actualisation de invW
    % ---------------------
    invWh = invW * h;
    unplushinvWh = 1 + h.'*invW*h;
    invW_i = invW - (invWh * invWh.') / unplushinvWh;
  
    % actualisation de detW
    % ---------------------
    detW_i = detW * unplushinvWh;
  
  
    % calcul de det(S_i) et inv(S_i)
    % ------------------------------
  
    % si formes spheriques
    % ....................
    if iA == 1
    % si volumes egaux
    % ................
      if il == 1
        [invS_i,detS_i] = lIfast(W_i,k,n_i,d);			% [lI]
    % si volumes differents
    % .....................
      else
        [invS_i,detS_i] = lkIfast(Wk_i,k,nk_i,d);		% [lkI]
      end
    % si formes ellipses identiques
    % .............................
    elseif iA == 2
      % si volumes egaux
      % ................
      if il == 1
        % si orientations egales
        % ......................
        if iD == 1
          [invS_i,detS_i] = lCfast(invW_i,detW_i,k,n_i,d);	% [lC]
        % si orientations differentes
        % ...........................
        elseif iD == 2
          S_i = lDkADk(Wk_i,k,n_i,d);%disp('lDkADk')		% [lDkADk]
          invdet_fast = 0;
        % si orientations suivant axes
        % ............................
      else
        [invS_i,detS_i] = lBfast(W_i,k,n_i,d);			% [lB]
      end
      % si volumes differents
      % .....................
      else
        % si orientations egales
        % ......................
        if iD == 1
          S_i = lkC(Wk_i,k,nk_i,d,S);%disp('lkC')		% [lkC]
          invdet_fast = 0;
        % si orientations differentes
        % ...........................
        elseif iD == 2
          S_i = lkDkADk(Wk_i,k,nk_i,d,S);%disp('lkDkADk')	% [lkDkADk]
          invdet_fast = 0;
        % si orientations suivant axes
        % ............................
        else
          [invS_i,detS_i,invB] = lkBfast(Wk_i,k,nk_i,d,invB);	% [lkB]
        end
      end
    % si formes ellipses differentes
    % ..............................
    else
      % si volumes egaux
      % ................
      if il == 1
        % si orientations egales
        % ......................
        if iD == 1
          S_i = lDAkD(Wk_i,k,n_i,d,S);%disp('lDAkD')		% [lDAkD]
          invdet_fast = 0;
        % si orientations differentes
        % ...........................
        elseif iD == 2
          [invS_i,detS_i] = lCkfast(invWk_i,detWk_i,k,n_i,d);	% [lCk]
        % si orientations suivant axes
        % ............................
        else
          [invS_i,detS_i] = lBkfast(Wk_i,k,n_i,d);		% [lBk]
        end
      else
      % si volumes differents
      % .....................
        % si orientations egales
        % ......................
        if iD == 1
          S_i = lkDAkD(Wk_i,k,nk_i,d,S);%disp('lkDAkD')		% [lkDAkD]
          invdet_fast = 0;
        % si orientations differentes
        % ...........................
        elseif iD == 2
          [invS_i,detS_i] = lkCkfast(invWk_i,detWk_i,k,nk_i,d);	% [lkCk]
        % si orientations suivant axes
        % ............................
        else
          [invS_i,detS_i] = lkBkfast(Wk_i,k,nk_i,d);		% [lkBk]
        end
      end
    end
  end

  % -----------------------------------------------------
  % calcul de la classe de ce point apres l'actualisation
  % -----------------------------------------------------

  % calcul des fik_i = pk_i * f(y,mu_i(k_i),S_i(k_i)) (1 x k)
  % ---------------------------------------------------------
 
  fik_i = zeros(1,k);

  % si invS_i et detS_i existent (version actualisee du modele) ou bien Sfix
  if invdet_fast | Sfix
    for j = 1:k
      invStmp = extm(invS_i,j,d);
      detStmp = detS_i(j);
      fik_i(1,j) = p_i(j) * (gausfast(cste,mu_i(:,j),[],y,d,1,invStmp,detStmp))';
    end
  % sinon
  else
    for j = 1:k
      Stmp = extm(S_i,j,d);
      fik_i(1,j) = p_i(j) * (gausfast(cste,mu_i(:,j),Stmp,y,d,1))';
    end
  end


  % le point y est-il bien classe ?
  % -------------------------------
  if (k_i ~= find(fik_i == max(fik_i)))
    mal_classes = mal_classes + 1;
  end

%%%
end % Pour chacun des n points
%%%

% probabilite d'erreur
% --------------------
ProbEr = mal_classes / n;

%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%	THE 14 MODELS
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

% =============================================================================
% 	subfunction decompSk
% =============================================================================

function [lk,Dk,Ak] = decompSk (d,Sk)

% [lk,Dk,Ak] = decompSk (d,Sk)
% decomposition de la matrice Sk = lk*Dk*Ak*D'k
% entrees :
%	d dimension de l'espace
%	Sk matrice de variance (d x d)
% sorties :
%	lk volume des classes (1 x 1)
%	Dk matrice d'orientation des classes (d x d)
%	Ak matrice de forme des classes (d x d)

% reinitialise Sk a identite si valeurs NaN ou (-)Inf
if sum(sum(~finite(Sk))) ~= 0
	Sk = eye(d);
end
lk = (det(Sk))^(1/d);
[Dk,Ak,Dtk] = svd(Sk);
Ak = Ak/lk;


% =============================================================================
% 	subfunction lI
% =============================================================================

function S = lI(W,k,n,d)

% S = lI(W,k,n,d)
% estime les matrices de variance pour le modele lI
% entrees :
%	W within cluster scattering matrix (d x d)
%	k nombre de classes
%	n nombre de points
%	d dimension de l'espace
% sorties :
%	S matrices de variance estimees (d*k x d)

Wtmp = (trace(W) / (n*d)) * eye(d,d);
S = zeros(d*k,d);
for j = 1:k
	S = putm(S,Wtmp,j,d);
end

% =============================================================================
% 	subfunction lkI
% =============================================================================

function S = lkI(Wk,k,nk,d)

% S = lkI(Wk,k,n,d)
% estime les matrices de variance pour le modele lkI
% entrees :
%	Wk within scattering matrix of each cluster (k*d x d)
%	k nombre de classes
%	nk nombre flou de points par classe (1 x k)
%	d dimension de l'espace
% sorties :
%	S matrices de variance estimees (d*k x d)

S = zeros(d*k,d);
for j = 1:k
	S = putm(S,(trace(extm(Wk,j,d)) / (d*nk(j))) * eye(d,d),j,d);
end

% =============================================================================
% 	subfunction lB
% =============================================================================

function S = lB(W,k,n,d)

% S = lB(W,k,n,d)
% estime les matrices de variance pour le modele lB
% entrees :
%	W within cluster scattering matrix (d x d)
%	k nombre de classes
%	n nombre de points
%	d dimension de l'espace
% sorties :
%	S matrices de variance estimees (d*k x d)

% calcul de Sk
% ------------

Sk = diag(diag(W))/n;

% calcul de S
% -----------

S = zeros(d*k,d);
for j = 1:k
	S = putm(S,Sk,j,d);
end

% =============================================================================
% 	subfunction lkB
% =============================================================================

function S = lkB(Wk,k,nk,d,Sold)

% S = lkB(Wk,k,nk,d,Sold)
% estime les matrices de variance pour le modele lkB
% entrees :
%	Wk within scattering matrix of each cluster (k*d x d)
%	k nombre de classes
%	nk nombre flou de points par classe (1 x k)
%	d dimension de l'espace
%	Sold les k matrices Sk de l'iteration precedente (k*d x d)
%	     (pour initialiser la procedure iterative) 
% sorties :
%	S matrices de variance estimees (d*k x d)

% extraction de l'ancienne matrice B (B=B1=B2=...=Bk)
% ----------------------------------
% permet d'initialiser "le mieux possible" B

Soldk = extm(Sold,1,d);
[loldk,Doldk,Aoldk] = decompSk(d,Soldk);
B = Doldk*Aoldk*Doldk';

% initialisations (criteres F courant et Fold prededent, nb iterations, l)
% --------------------------------------------------------------------------

F = 0;
Fold = -inf;
nbit = 0;
l = zeros(1,k);
invd = 1/d;

% procedure iterative
% -------------------

% tant que pas convergence et que pas encore trop d'iterations

while (abs(F-Fold) > 1e-3) & (nbit < 6)

Fold = F;
nbit = nbit + 1;

% calcul des lk

tabtrace = zeros(1,k);
invB = inv(B);
for j = 1:k
	tabtrace(j) = trace(extm(Wk,j,d)*invB);
	l(j) =  tabtrace(j)/ (d*nk(j));
end

% calcul de B

Mtmp = zeros(d,d);
for j = 1:k
	Mtmp = Mtmp + extm(Wk,j,d) / l(j);
end
Mtmp = diag(diag(Mtmp));
B = Mtmp / real((det(Mtmp))^invd); % !!! : "real" pour que NaN^invd = NaN et pas NaN+iNaN

% calcul du critere

F = sum(tabtrace ./ l + d * nk .* log(l));

end

% fin procedure iterative

% calcul de S
% -----------

S = zeros(k*d,d);
for j = 1:k
	S = putm(S,l(j)*B,j,d);
end

% =============================================================================
% 	subfunction lBk
% =============================================================================

function S = lBk(Wk,k,n,d)

% S = lBk(Wk,k,n,d)
% estime les matrices de variance pour le modele lBk
% entrees :
%	Wk within scattering matrix of each cluster (k*d x d)
%	k nombre de classes
%	n nombre de points
%	d dimension de l'espace
% sorties :
%	S matrices de variance estimees (d*k x d)

B = zeros(d*k,d);
tabdetdiagWk = zeros(k,1);
invd = 1/d;

% calcul des Bk (stockes dans B)
% ------------------------------

for j = 1:k
	diagWk = diag(diag(extm(Wk,j,d)));
	tabdetdiagWk(j) = real((det(diagWk))^invd); % !!! : "real" pour que NaN^invd = NaN et pas NaN+iNaN
	B = putm(B,diagWk / tabdetdiagWk(j),j,d);
end

% calcul de l
% -----------

l = sum(tabdetdiagWk)/n;

% calcul de S
% -----------

S = l*B;

% =============================================================================
% 	subfunction lkBk
% =============================================================================

function S = lkBk(Wk,k,nk,d)

% S = lkBk(Wk,k,nk,d)
% estime les matrices de variance pour le modele lkBk
% entrees :
%	Wk within scattering matrix of each cluster (k*d x d)
%	k nombre de classes
%	nk nombre flou de points par classe (1 x k)
%	d dimension de l'espace
% sorties :
%	S matrices de variance estimees (d*k x d)

S = zeros(d*k,d);
for j = 1:k
	S = putm(S,diag(diag(extm(Wk,j,d))) / nk(j),j,d);
end

% =============================================================================
% 	subfunction lC
% =============================================================================

function S = lC(W,k,n,d)

% S = lC(W,k,n,d)
% estime les matrices de variance pour le modele lC
% entrees :
%	W within cluster scattering matrix (d x d)
%	k nombre de classes
%	n nombre de points
%	d dimension de l'espace
% sorties :
%	S matrices de variance estimees (d*k x d)

Wtmp = W / n;
S = zeros(d*k,d);
for j = 1:k
	S = putm(S,Wtmp,j,d);
end

% =============================================================================
% 	subfunction lkC
% =============================================================================

function S = lkC(Wk,k,nk,d,Sold)

% S = lkC(Wk,k,nk,d,Sold)
% estime les matrices de variance pour le modele lkC
% entrees :
%	Wk within scattering matrix of each cluster (k*d x d)
%	k nombre de classes
%	nk nombre flou de points par classe (1 x k)
%	d dimension de l'espace
%	Sold les k matrices Sk de l'iteration precedente (k*d x d)
%	     (pour initialiser la procedure iterative) 
% sorties :
%	S matrices de variance estimees (d*k x d)

% extraction de l'ancienne matrice C (C=C1=C2=...=Ck)
% ----------------------------------
% permet d'initialiser "le mieux possible" C

Soldk = extm(Sold,1,d);
[loldk,Doldk,Aoldk] = decompSk(d,Soldk);
C = Doldk*Aoldk*Doldk';

% initialisations (criteres F courant et Fold prededent, nb iterations, l)
% --------------------------------------------------------------------------

F = 0;
Fold = -inf;
nbit = 0;
l = zeros(1,k);
invd = 1/d;

% procedure iterative
% -------------------

% tant que pas convergence et que pas encore trop d'iterations

while (abs(F-Fold) > 1e-3) & (nbit < 6)

Fold = F;
nbit = nbit + 1;

% calcul des lk

tabtrace = zeros(1,k);
invC = inv(C);
for j = 1:k
	tabtrace(j) = trace(extm(Wk,j,d)*invC);
	l(j) =  tabtrace(j)/ (d*nk(j));
end

% calcul de C

Mtmp = zeros(d,d);
for j = 1:k
	Mtmp = Mtmp + extm(Wk,j,d) / l(j);
end
C = Mtmp / real((det(Mtmp))^invd); % !!! : "real" pour que NaN^invd = NaN et pas NaN+iNaN

% calcul du critere

F = sum(tabtrace ./ l + d * nk .* log(l));

end

% fin procedure iterative

% calcul de S
% -----------

S = zeros(k*d,d);
for j = 1:k
	S = putm(S,l(j)*C,j,d);
end

% =============================================================================
% 	subfunction lCk
% =============================================================================

function S = lCk(Wk,k,n,d)

% S = lCk(Wk,k,n,d)
% estime les matrices de variance pour le modele lCk
% entrees :
%	Wk within scattering matrix of each cluster (k*d x d)
%	k nombre de classes
%	n nombre de points
%	d dimension de l'espace
% sorties :
%	S matrices de variance estimees (d*k x d)

C = zeros(d*k,d);
tabdetWk = zeros(k,1);
invd = 1/d;

% calcul des Ck (stockes dans C)
% ------------------------------

for j = 1:k
	Wktmp = extm(Wk,j,d);
	tabdetWk(j) = real((det(Wktmp))^invd); % !!! : "real" pour que NaN^invd = NaN et pas NaN+iNaN
	C = putm(C,Wktmp / tabdetWk(j),j,d);
end

% calcul de l
% -----------

l = sum(tabdetWk)/n;

% calcul de S
% -----------

S = l*C;

% =============================================================================
% 	subfunction lkCk
% =============================================================================

function S = lkCk(Wk,k,nk,d)

% S = lkCk(Wk,k,nk,d)
% estime les matrices de variance pour le modele lkCk
% entrees :
%	Wk within scattering matrix of each cluster (k*d x d)
%	k nombre de classes
%	nk nombre flou de points par classe (1 x k)
%	d dimension de l'espace
% sorties :
%	S matrices de variance estimees (d*k x d)

S = zeros(d*k,d);
for j = 1:k
	S = putm(S,extm(Wk,j,d) / nk(j),j,d);
end

% =============================================================================
% 	subfunction lDAkD
% =============================================================================

function S = lDAkD(Wk,k,n,d,Sold)

% S = lDAkD(Wk,k,n,d,Sold)
% estime les matrices de variance pour le modele lDAkD
% entrees :
%	Wk within scattering matrix of each cluster (k*d x d)
%	k nombre de classes
%	n nombre de points
%	d dimension de l'espace
%	Sold les k matrices Sk de l'iteration precedente (k*d x d)
%	     (pour initialiser la procedure iterative)
% sorties :
%	S matrices de variance estimees (d*k x d)

% REMARQUE : ICI, Ak n'est pas necessairement une matrice dont les elements
% diagonaux sont classes par ordre decroissant.

Ak = zeros(d*k,d);
invd = 1/d;
q2 = zeros(2,1);


% extraction de l'ancienne matrice D (D=D1=D2=...=Dk)
% ----------------------------------
% permet d'initialiser "le mieux possible" D

Soldk = extm(Sold,1,d);
[loldk,D,Aoldk] = decompSk(d,Soldk);


% initialisations pour la 1ere procedure iterative
% (criteres F1 courant et F1old prededent, nb iterations1)
% --------------------------------------------------------------------------

F1 = 0;
F1old = -inf;
nbit1 = 0;

% %%%%%%%%%%%%%%%%%%%%%%%%
% procedure iterative no 1
% %%%%%%%%%%%%%%%%%%%%%%%%

% tant que pas convergence et que pas encore trop d'iterations

while (abs(F1-F1old) > 1e-3) & (nbit1 < 6)

F1old = F1;
nbit1 = nbit1 + 1;

% calcul des Ak
% -------------

for j = 1:k
	Mtmp = diag(diag(D'*extm(Wk,j,d)*D));
	Ak = putm(Ak,Mtmp / (real(det(Mtmp))^invd),j,d); % !!! : "real" pour que NaN^invd = NaN et pas NaN+iNaN
end

% calcul de D
% -----------

% initialisations pour la 2eme procedure iterative
% (criteres F2 courant et F2old prededent, nb iterations2)
% --------------------------------------------------------------------------

F2 = 0;
F2old = -inf;
nbit2 = 0;

% %%%%%%%%%%%%%%%%%%%%%%%%
% procedure iterative no 2 (imbriquee dans la 1)
% %%%%%%%%%%%%%%%%%%%%%%%%

% tant que pas convergence et que pas encore trop d'iterations
% ------------------------------------------------------------

while (abs(F2-F2old) > 1e-3) & (nbit2 < 6)

F2old = F2;
nbit2 = nbit2 + 1;

for il = 1:d-1
	for im = il+1:d
%	for im = [1:il-1,il+1:d]
%		extraction des deux colonnes dl et dm
		dl = D(:,il);
		dm = D(:,im);
%		calcul de la matrice R dont q1 est le 2eme vecteur propre
		R = zeros(2);
		for j = 1:k
			Aktmp = extm(Ak,j,d);
			R = R + (1/Aktmp(il,il) - 1/Aktmp(im,im))...
				*[dl dm]'*extm(Wk,j,d)*[dl dm];
		end
%		calcul de q1
		if any(~isfinite(R)) % au cas ou R est degeneree, on termine la fonction
			S = NaN * Sold;
			return;
		end
		[V,Dvalue] = eig(R);
		[valmin,ivalmin] = min(diag(Dvalue));
		q1 = V(:,ivalmin);
%		calcul de q2
		q2(1) = q1(2);
		q2(2) = -q1(1);
%		remplacement des colonnes il et im de D
		D(:,il) = [dl,dm]*q1;
		D(:,im) = [dl,dm]*q2;
	end
end

% calcul du critere F2

F2 = 0;
for j = 1:k
	F2 = F2 + trace(D*inv(extm(Ak,j,d))*D'*extm(Wk,j,d));
end
%F2,nbit2,pause
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fin procedure iterative no 2
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%


% calcul du critere F1

F1 = F2;

%F1,nbit1,pause
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fin procedure iterative no 1
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%



% calcul de l

l = F1 / (n*d);


% calcul de S
% -----------

S = zeros(k*d,d);
for j = 1:k
	S = putm(S,l*D*extm(Ak,j,d)*D',j,d);
end

% =============================================================================
% 	subfunction lkDAkD
% =============================================================================

function S = lkDAkD(Wk,k,nk,d,Sold)

% S = lkDAkD(Wk,k,nk,d,Sold)
% estime les matrices de variance pour le modele lkDAkD
% entrees :
%	Wk within scattering matrix of each cluster (k*d x d)
%	k nombre de classes
%	nk nombre flou de points par classes (1 x k)
%	d dimension de l'espace
%	Sold les k matrices Sk de l'iteration precedente (k*d x d)
%	     (pour initialiser la procedure iterative)
% sorties :
%	S matrices de variance estimees (d*k x d)

% REMARQUE : ICI, on prend Sk = D*Ak*D' (volume non explicite)

Ak = zeros(d*k,d);
q2 = zeros(2,1);
detAk = zeros(1,k); % pour eviter boucle lors du calcul de F1

% extraction de l'ancienne matrice D (D=D1=D2=...=Dk)
% ----------------------------------
% permet d'initialiser "le mieux possible" D

Soldk = extm(Sold,1,d);
[loldk,D,Aoldk] = decompSk(d,Soldk);


% initialisations pour la 1ere procedure iterative
% (criteres F1 courant et F1old prededent, nb iterations1)
% --------------------------------------------------------------------------

F1 = 0;
F1old = -inf;
nbit1 = 0;

% %%%%%%%%%%%%%%%%%%%%%%%%
% procedure iterative no 1
% %%%%%%%%%%%%%%%%%%%%%%%%

% tant que pas convergence et que pas encore trop d'iterations

while (abs(F1-F1old) > 1e-3) & (nbit1 < 6)

F1old = F1;
nbit1 = nbit1 + 1;

% calcul des Ak et detAk
% ----------------------

for j = 1:k
	Aktmp = diag(diag(D'*extm(Wk,j,d)*D)) / nk(j);
	Ak = putm(Ak,Aktmp,j,d);
	detAk(j) = det(Aktmp);
end

% calcul de D
% -----------

% initialisations pour la 2eme procedure iterative
% (criteres F2 courant et F2old prededent, nb iterations2)
% --------------------------------------------------------------------------

F2 = 0;
F2old = -inf;
nbit2 = 0;

% %%%%%%%%%%%%%%%%%%%%%%%%
% procedure iterative no 2 (imbriquee dans la 1)
% %%%%%%%%%%%%%%%%%%%%%%%%

% tant que pas convergence et que pas encore trop d'iterations
% ------------------------------------------------------------

while (abs(F2-F2old) > 1e-3) & (nbit2 < 6)

F2old = F2;
nbit2 = nbit2 + 1;

for il = 1:d-1
	for im = il+1:d
%	for im = [1:il-1,il+1:d]
%		extraction des deux colonnes dl et dm
		dl = D(:,il);
		dm = D(:,im);
%		calcul de la matrice R dont q1 est le 2eme vecteur propre
		R = zeros(2);
		for j = 1:k
			Aktmp = extm(Ak,j,d);
			R = R + (1/Aktmp(il,il) - 1/Aktmp(im,im))...
				*[dl dm]'*extm(Wk,j,d)*[dl dm];
		end
%		calcul de q1
		if any(~isfinite(R)) % au cas ou R est degeneree, on termine la fonction
			S = NaN * Sold;
			return;
		end
		[V,Dvalue] = eig(R);
		[valmin,ivalmin] = min(diag(Dvalue));
		q1 = V(:,ivalmin);
%		calcul de q2
		q2(1) = q1(2);
		q2(2) = -q1(1);
%		remplacement des colonnes il et im de D
		D(:,il) = [dl,dm]*q1;
		D(:,im) = [dl,dm]*q2;
	end
end

% calcul du critere F2

F2 = 0;
for j = 1:k
	F2 = F2 + trace(D*inv(extm(Ak,j,d))*D'*extm(Wk,j,d));
end
%F2,nbit2,pause
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fin procedure iterative no 2
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%


% calcul du critere F1

F1 = F2 + sum(nk .* log(detAk));

%F1,nbit1,pause
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fin procedure iterative no 1
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%


% calcul de S
% -----------

S = zeros(k*d,d);
for j = 1:k
	S = putm(S,D*extm(Ak,j,d)*D',j,d);
end

% =============================================================================
% 	subfunction lDkADk
% =============================================================================

function S = lDkADk(Wk,k,n,d)

% S = lDkADk(Wk,k,n,d)
% estime les matrices de variance pour le modele lDkADk
% entrees :
%	Wk within scattering matrix of each cluster (k*d x d)
%	k nombre de classes
%	n nombre de points
%	d dimension de l'espace
% sorties :
%	S matrices de variance estimees (d*k x d)

Dk = zeros(d*k,d);
sumOmk = zeros(d,d);

% calcul des Dk, extraction des Omk et somme des Omk
% --------------------------------------------------

for j = 1:k
	Wktmp = extm(Wk,j,d);
%	decomposition Wk = Lk*Omk*Dk'
	if any(~isfinite(Wktmp)) % au cas ou Wktmp est degeneree, on termine la fonction
		S = NaN * Wk;
		return;
	end
	[Dktmp,Omktmp,Uktmp] = svd(Wktmp);
%	sauve Lktmp
	Dk = putm(Dk,Dktmp,j,d);
% 	calcule sumOmk 
	sumOmk = sumOmk + Omktmp;
end

% calcul de l*A
% -------------

lA = sumOmk / n;

% calcul de S
% -----------

S = [];
for j = 1:k
	Dktmp = extm(Dk,j,d);
	S = putm(S,Dktmp*lA*Dktmp',j,d);
end

% =============================================================================
% 	subfunction lkDkADk
% =============================================================================

function S = lkDkADk(Wk,k,nk,d,Sold)

% S = lkDkADk(Wk,k,nk,d,Sold)
% estime les matrices de variance pour le modele lkDkADk
% entrees :
%	Wk within scattering matrix of each cluster (k*d x d)
%	k nombre de classes
%	nk nombre flou de points par classe (1 x k)
%	d dimension de l'espace
%	Sold les k matrices Sk de l'iteration precedente (k*d x d)
%	     (pour initialiser la procedure iterative)
% sorties :
%	S matrices de variance estimees (d*k x d)

Dk = zeros(d*k,d);
Omk = zeros(d*k,d);

% extraction de l'ancienne matrice A (A=A1=A2=...=Ak)
% ----------------------------------
% permet d'initialiser "le mieux possible" A

Soldk = extm(Sold,1,d);
[loldk,Doldk,A] = decompSk(d,Soldk);

% calcul des Dk et des Omk
% ------------------------

for j = 1:k
	Wktmp = extm(Wk,j,d);
%	decomposition Wk = Dk*Omk*Dk'
	if any(~isfinite(Wktmp)) % au cas ou Wktmp est degeneree, on termine la fonction
		S = NaN * Wk;
		return;
	end
	[Dktmp,Omktmp,Uktmp] = svd(Wktmp);
%	sauve Dktmp
	Dk = putm(Dk,Dktmp,j,d);
% 	sauve Omktmp 
	Omk = putm(Omk,Omktmp,j,d);
end


% initialisations (criteres F courant et Fold prededent, nb iterations, l)
% ------------------------------------------------------------------------

F = 0;
Fold = -inf;
nbit = 0;
l = zeros(1,k);
invd = 1/d;

% procedure iterative
% -------------------

% tant que pas convergence et que pas encore trop d'iterations

while (abs(F-Fold) > 1e-3) & (nbit < 6)

Fold = F;
nbit = nbit + 1;

% calcul des lk

tabtrace = zeros(1,k);
invA = inv(A);
for j = 1:k
	Dktmp = extm(Dk,j,d);
	tabtrace(j) = trace(extm(Wk,j,d)*Dktmp*invA*Dktmp');
	l(j) =  tabtrace(j)/ (d*nk(j));
end

% calcul de A

Mtmp = zeros(d,d);
for j = 1:k
	Mtmp = Mtmp + extm(Omk,j,d) / l(j);
end

A = Mtmp / real((det(Mtmp))^invd); % !!! : "real" pour que NaN^invd = NaN et pas NaN+iNaN

% calcul du critere

F = sum(tabtrace ./ l + d * nk .* log(l));

end
%nbit,F,pause
% fin procedure iterative

% calcul de S
% -----------

S = zeros(k*d,d);
for j = 1:k
	Dktmp = extm(Dk,j,d);
	S = putm(S,l(j)*Dktmp*A*Dktmp',j,d);
end

%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%	SOME MODELS WITH FAST COMPUTATION FOR CROSS-VALIDATION
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

% =============================================================================
% 	subfunction lIfast
% =============================================================================

function [invS,detS] = lIfast(W,k,n,d)

% [invS,detS] = lIfast(W,k,n,d)
% Inverse et le determinant des matrices de variance pour le modele lI
% entrees :
%	W within cluster scattering matrix (d x d)
%	k nombre de classes
%	n nombre de points
%	d dimension de l'espace
% sorties :
%	invS inverse des matrices de variance estimees (d*k x d)
%	detS determinant des matrices de variance estimees (1 x k)

tmp = trace(W) / (n*d);
detS = tmp^d .* ones(1,k);
Wtmp = eye(d,d) / tmp;
invS = zeros(d*k,d);
for j = 1:k
	invS = putm(invS,Wtmp,j,d);
end

% =============================================================================
% 	subfunction lkIfast
% =============================================================================

function [invS,detS] = lkIfast(Wk,k,nk,d)

% [invS,detS] = lkIfast(Wk,k,n,d)
% Inverse et le determinant des matrices de variance pour le modele lkI
% entrees :
%	Wk within scattering matrix of each cluster (k*d x d)
%	k nombre de classes
%	nk nombre flou de points par classe (1 x k)
%	d dimension de l'espace
% sorties :
%       invS inverse des matrices de variance estimees (d*k x d)
%       detS determinant des matrices de variance estimees (1 x k)


invS = zeros(d*k,d);
detS = zeros(1,k);
for j = 1:k
	tmp = trace(extm(Wk,j,d)) / (d*nk(j));
	invS = putm(invS,eye(d,d)/tmp,j,d);
	detS(j) = tmp^d;
end

% =============================================================================
% 	subfunction lBfast
% =============================================================================

function [invS,detS] = lBfast(W,k,n,d)

% [invS,detS] = lBfast(W,k,n,d)
% Inverse et le determinant des matrices de variance pour le modele lB
% entrees :
%	W within cluster scattering matrix (d x d)
%	k nombre de classes
%	n nombre de points
%	d dimension de l'espace
% sorties :
%       invS inverse des matrices de variance estimees (d*k x d)
%       detS determinant des matrices de variance estimees (1 x k)

% calcul de invSk et detSk
% ------------------------

tmp = diag(W);
invSk = n*diag(1./tmp);
detSk = prod(tmp) / (n^d);

% calcul de invS et detS
% ----------------------

invS = zeros(d*k,d);
detS = detSk .* ones(1,k);
for j = 1:k
	invS = putm(invS,invSk,j,d);
end

% =============================================================================
% 	subfunction lkBfast
% =============================================================================

function [invS,detS,invB] = lkBfast(Wk,k,nk,d,invBold)

% [invS,detS,invB] = lkBfast(Wk,k,nk,d,invBold)
% estime les matrices de variance pour le modele lkB
% entrees :
%	Wk within scattering matrix of each cluster (k*d x d)
%	k nombre de classes
%	nk nombre flou de points par classe (1 x k)
%	d dimension de l'espace
%	invBold inverse de B de l'iteration precedente (d x d)
%	     (pour initialiser la procedure iterative) 
% sorties :
%       invS inverse des matrices de variance estimees (d*k x d)
%       detS determinant des matrices de variance estimees (1 x k)
%	invB inverse de la matrice B (d x d)


% initialisations (criteres F courant et Fold prededent, nb iterations, l)
% --------------------------------------------------------------------------

F = 0;
Fold = -inf;
nbit = 0;
l = zeros(1,k);
invd = 1/d;
invB = invBold;

% procedure iterative
% -------------------

% tant que pas convergence et que pas encore trop d'iterations

while (abs(F-Fold) > 1e-3) & (nbit < 6)

Fold = F;
nbit = nbit + 1;

% calcul des lk

tabtrace = zeros(1,k);
for j = 1:k
	tabtrace(j) = trace(extm(Wk,j,d)*invB);
	l(j) =  tabtrace(j)/ (d*nk(j));
end

% calcul de invB

Mtmp = zeros(d,d);
for j = 1:k
	Mtmp = Mtmp + extm(Wk,j,d) / l(j);
end
Vtmp = diag(Mtmp);
invB = real((prod(Vtmp))^invd) * diag(1./Vtmp); % !!! : "real" pour que NaN^invd = NaN et pas NaN+iNaN

% calcul du critere

F = sum(tabtrace ./ l + d * nk .* log(l));

end

% fin procedure iterative

% calcul de invS et detS
% ----------------------

invS = zeros(k*d,d);
for j = 1:k
	invS = putm(invS,invB/l(j),j,d);
end
detS = l.^d;

% =============================================================================
% 	subfunction lBkfast
% =============================================================================

function [invS,detS] = lBkfast(Wk,k,n,d)

% [invS,detS] = lBkfast(Wk,k,n,d)
% Inverse et le determinant des matrices de variance pour le modele lBk
% entrees :
%	Wk within scattering matrix of each cluster (k*d x d)
%	k nombre de classes
%	n nombre de points
%	d dimension de l'espace
% sorties :
%       invS inverse des matrices de variance estimees (d*k x d)
%       detS determinant des matrices de variance estimees (1 x k)

invSk = zeros(d*k,d);
sumdetdiagWk = 0;
invd = 1/d;

% calcul de detS et invS
% ----------------------

invS = [];
for j = 1:k
	Wktmp = extm(Wk,j,d);
	diagWktmp = diag(Wktmp);
	detdiagWktmp = real((prod(diagWktmp))^invd); % !!! : "real" pour que NaN^invd = NaN et pas NaN+iNaN
	sumdetdiagWk = sumdetdiagWk + detdiagWktmp;
	invS = putm(invS,detdiagWktmp * diag(1./diagWktmp),j,d);
end
invS = invS .* n ./ sumdetdiagWk;
detS = (sumdetdiagWk / n)^d .* ones(1,k);

% =============================================================================
% 	subfunction lkBkfast
% =============================================================================

function [invS,detS] = lkBkfast(Wk,k,nk,d)

% [invS,detS] = lkBkfast(Wk,k,nk,d)
% Inverse et le determinant des matrices de variance pour le modele lkBk
% entrees :
%	Wk within scattering matrix of each cluster (k*d x d)
%	k nombre de classes
%	nk nombre flou de points par classe (1 x k)
%	d dimension de l'espace
% sorties :
%       invS inverse des matrices de variance estimees (d*k x d)
%       detS determinant des matrices de variance estimees (1 x k)

invS = zeros(d*k,d);
detS = zeros(1,k);
for j = 1:k
	tmp = diag(extm(Wk,j,d));
	detS(j) = prod(tmp)/nk(j)^d;
	invS = putm(invS,nk(j) .* diag( 1./tmp ),j,d);
end

% =============================================================================
% 	subfunction lCfast
% =============================================================================

function [invS,detS] = lCfast(invW,detW,k,n,d)

% [invS,detS] = lCfast(invW,detW,k,n,d)
% eInverse et le determinant des matrices de variance pour le modele lC
% entrees :
%	invW inverse of within cluster scattering matrix (d x d)
%	detW determinant of within cluster scattering matrix
%	k nombre de classes
%	n nombre de points
%	d dimension de l'espace
% sorties :
%       invS inverse des matrices de variance estimees (d*k x d)
%       detS determinant des matrices de variance estimees (1 x k)

invS = zeros(d*k,d);
tmp = n * invW;

for j = 1:k
	invS = putm(invS,tmp,j,d);
end
detS = detW/n^d .* ones(1,k);

% =============================================================================
% 	subfunction lCkfast
% =============================================================================

function [invS,detS] = lCkfast(invWk,detWk,k,n,d)

% [invS,detS] = lCkfast(invWk,detWk,k,n,d)
% Inverse et le determinant des matrices de variance pour le modele lCk
% entrees :
%	invWk inverse within scattering matrix of each cluster (k*d x d)
%	detWk determinant within scattering matrix of each cluster
%	k nombre de classes
%	n nombre de points
%	d dimension de l'espace
% sorties :
%       invS inverse des matrices de variance estimees (d*k x d)
%       detS determinant des matrices de variance estimees (1 x k)


invd = 1/d;
sumdetWk = 0;
invS = zeros(d*k,d);

% calcul de detS et invS
% ----------------------

for j = 1:k
	invWktmp = extm(invWk,j,d);
	detWktmp = real(detWk(j)^invd); % !!! : "real" pour que NaN^invd = NaN et pas NaN+iNaN
	sumdetWk = sumdetWk + detWktmp;
	invS = putm(invS,detWktmp * invWktmp,j,d);
end
invS = invS .* n ./ sumdetWk;
detS = (sumdetWk / n)^d .* ones(1,k);	

% =============================================================================
% 	subfunction lkCkfast
% =============================================================================

function [invS,detS] = lkCkfast(invWk,detWk,k,nk,d)

% [invS,detS] = lkCkfast(invWk,detWk,k,nk,d)
% Inverse et le determinant des matrices de variance pour le modele lkCk
% entrees :
%	invWk inverse within scattering matrix of each cluster (k*d x d)
%	detWk determinant within scattering matrix of each cluster
%	k nombre de classes
%	nk nombre flou de points par classe (1 x k)
%	d dimension de l'espace
% sorties :
%       invS inverse des matrices de variance estimees (d*k x d)
%       detS determinant des matrices de variance estimees (1 x k)

invS = zeros(d*k,d);
for j = 1:k
	invS = putm(invS,extm(invWk,j,d) * nk(j),j,d);
end
detS = detWk ./ nk.^d;

%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%	OTHER FUNCTIONS
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

% =============================================================================
% 	subfunction stepINIT
% =============================================================================

function [p,mu,S,Wk,W] = stepINIT(x,n,d,init,p_in,mu_in,S_in,z_in,pfix,mufix,Sfix,zfix,ip,il,iD,iA,k,cste)

% Initialization Step of the XEM algorithm

% --------------------------
% the equal proportions case
% --------------------------

if ip == 1
  p_in = ones(1,k) / k;
end

% --------------------
% some initialisations
% --------------------

kp = length(p_in);
[dmu,kmu] = size(mu_in);
[kS,dS] = size(S_in);
if dS == 0
  kS = 0;
else
  kS = kS / dS;
end
[nz,kz] = size(z_in);

% -----------------------------
% verify coherence of arguments
% -----------------------------

if (pfix | strcmp(init,'user parameters')) & (kp ~= k)
  error('========== Argument ''p'': error in dimension ==========')
end

if (mufix | strcmp(init,'user parameters')) & ((kmu ~= k) | (dmu ~= d))
  error('========== Argument ''mu'': error in dimension ==========')
end

if (Sfix | strcmp(init,'user parameters')) & ((kS ~= k) | (dS ~= d))
  error('========== Argument ''S'': error in dimension ==========')
end

if (length(zfix) > 1) & (length(zfix) ~= n)
  error('========== Argument ''zfix'': error in dimension ==========')
end

if (zfix(1) | (length(zfix) > 1) | strcmp(init,'user partition')) ...
   & ((kz ~= k) | (nz ~= n))
  error('========== Argument ''z'': error in dimension ==========')
end

% ------------------------
% manage random situations
% ------------------------

switch init

  % --------------
  % random centers
  % --------------

  case 'random centers'

    % -----------------------------------
    % centers at random only if not mufix
    % -----------------------------------

    if ~mufix
      mu_in = x(:,max(ones(size(1:k)),round(rand(size(1:k))*n)));
    else
      warning('---------- no random centers since mufix is true ----------')
    end

    % -------------------------------------------------
    % set S_in to identity if not of the good dimension
    % -------------------------------------------------

    if (kS ~= k)
      S_in = zeros(d*k,d);
      for i = 1:k
        S_in = putm(S_in,eye(d),i,d);
      end
    end

    % ----------------------------------------------
    % set p_in to equal if not of the good dimension
    % ----------------------------------------------

    if (kp ~= k)
      p_in = ones(1,k) / k;
    end

  % ----------------
  % random partition
  % ----------------

  case 'random partition'

    % ----------------------------------
    % fabrique une partition aleatoire z
    % ----------------------------------

    zfind = 0;
    while ~zfind
      z = rand(n,k);
      z = (z == max(z,[],2)*ones(1,k));
      if sum(z(:)) == n
        zfind = 1;
      end
    end

    % -------------------------------------------------------------
    % fixe la totalite (ou une partie) de z a z_in en fonction zfix
    % -------------------------------------------------------------

    if length(zfix) == 1		% la totalite ou rien a fixer a z_in
      if zfix
        z = z_in;			% la totalite
      end
    else				% seulement une partie a fixer a z_in
      wherechange = find(zfix);
      z(wherechange,:) = z_in(wherechange,:);
    end

    z_in  = z;				% z_in devient z pour la suite

end

% -------------------
% the different cases
% -------------------

switch init

  % ---------------------------------
  % user parameters or random centers
  % ---------------------------------

  case {'user parameters','random centers'}
    p = p_in; mu = mu_in; S = S_in;

  % ----------------------------------
  % user partition or random partition
  % ----------------------------------

  case {'user partition','random partition'}
    nk = sum(z_in);			% population of each cluster

    % ----------------------------------------------------
    % the empty cluster case: no computation of parameters
    % ----------------------------------------------------

    if isemptycluster(nk)		% compute parameters only
      p = []; mu= []; S = [];		% if no empty clusters
      warning('---------- Empty clusters  ----------')

    % ------------------------------------------
    % the no empty cluster case: run computation
    % ------------------------------------------

    else

      % -------------------------------------------------
      % set S_in to identity if not of the good dimension
      % -------------------------------------------------
      % may be useful in stepM for some models as an initial matrix

      if (kS ~= k)
        S_in = zeros(d*k,d);
        for i = 1:k
          S_in = putm(S_in,eye(d),i,d);
        end
      end

      % ------------------------------------
      % the computation of parameters itself
      % ------------------------------------

      [p,mu,S,Wk,W] = stepM(n,d,k,x,ip,il,iD,iA,z_in,nk,p_in,mu_in,S_in,pfix,mufix,Sfix);
    end

end

% =============================================================================
% 	subfunction putm
% =============================================================================

function C = putm(A,B,k,d)

% C = putm(A,B,k,d)
% place la sous matrice B dans A en ((k-1)*d+1,1) et (dxd)
% entrees
%	A matrice au moins (k*d x d)
%	B matrice (d x d) 
%	k numero de la classe
%	d dimension de l'espace
% sorties
%	C matrice A partiellement remplacee par B

C = A;
C((k-1)*d+1:(k-1)*d+d,:) = B;

% =============================================================================
% 	subfunction extm
% =============================================================================

function B = extm(A,k,d)

% B = extm(A,k,d)
% extrait la kieme matrice en respectant le format du fichier de parametres
% donc extrait la sous matrice B de A situee en ((k-1)*d+1,1) et (dxd)
% entrees
%	A matrice du fichier parametre : forme ou orientation
%	k numero de la classe
%	d dimension de l'espace
% sorties
%	B sous-matrice

B = A((k-1)*d+1:(k-1)*d+d,:);

% =============================================================================
% 	subfunction zik_clas
% =============================================================================

function clas = zik_clas(zik,n,k)

% clas = zik_clas(zik,n,k)
% transforme une matrice de classification dure en des classes d'appartenance
% entrees :
%       zik matrice de classification dure (n x k)
%	n nombre de points
%	k nombre de classes
% sorties :
%	clas vecteur d'appartenance des points aux classes (1 x n)

[clas,tmp]=find([zik' ; zeros(1,n)]);
clas = clas';

% =============================================================================
% 	subfunction isemptycluster(nk)
% =============================================================================

function empty = isemptycluster(nk)

% Return 1 if at least one cluster is empty

empty = ~all(nk > 0);

% =============================================================================
% 	subfunction isSbadcond(d,k,S)
% =============================================================================

function Scond = isSbadcond(d,k,S)

% Return 1 if S is a set a variance matrices with at least one ill conditionned

Scond = 0;
for j = 1:k
  Sk = extm(S,j,d);
  if rcond(Sk) < 1e-10
    Scond = 1;
    return
  end
end

% =============================================================================
% 	subfunction transmod
% =============================================================================

function [ip,il,iD,iA] = transmod(mod)

% Translate mod in [ip,il,iD,iA] specifications
% mod: ['mixing proportion' 'volume' 'orientation' 'shape']
%		mixing proportions: 'propequal'	  'propfree'
%		volume: 	    'volequal'	  'volfree'
%		orientation:	    'orientequal' 'orientaxis' 'orientfree'
%		shape:		    'shapespher'  'shapeequal' 'shapefree'
% [ip il iD iA]:
%        ip 1-proportions egales 2-proportions differentes
%        il 1-volumes egaux 2-volumes differents
%        iD 1-orientations egales 2-orientations differentes 3-suivant axes
%        iA 1-formes spheriques 2-ellipses egales 3-ellipses differentes

% -----------
% proportions
% -----------

switch mod{1}
  case 'propequal', ip = 1;
  case 'propfree', ip = 2;
  otherwise error('========== error in transmod for mixing proportions ==========')
end

% -------
% volumes
% -------

switch mod{2}
  case 'volequal', il = 1;
  case 'volfree', il = 2;
  otherwise error('========== error in transmod for volumes ==========')
end

% ------------
% orientations
% ------------

switch mod{3}
  case 'orientequal', iD = 1;
  case 'orientfree', iD = 2;
  case 'orientaxis', iD = 3;
  otherwise error('========== error in transmod for orientations ==========')
end

% ------
% shapes
% ------

switch mod{4}
  case 'shapespher', iA = 1;
  case 'shapeequal', iA = 2;
  case 'shapefree', iA = 3;
  otherwise error('========== error in transmod for shapes ==========')
end

% =============================================================================
% 	subfunction controlarg
% =============================================================================

function args = controlarg(n,d,argstmp)

% Control all arguments and set default values
% Return a structure array

% --------------------
% make structure array
% --------------------

if ~isempty(argstmp)				% some arguments are present
  nameargs = argstmp(1:2:end);			% get names of arguments
  valargs = argstmp(2:2:end);			% get values of arguments
  args = cell2struct(valargs,nameargs,2);	% structure array
else
  args = {};
end

% -------------------
% --- p
% -------------------

if ~isfield(args,'p')				% set default
  args.p = [];
end

% -------------------
% --- mu
% -------------------

if ~isfield(args,'mu')				% set default
  args.mu = [];
end

% -------------------
% --- S
% -------------------

if ~isfield(args,'S')				% set default
  args.S = [];
end

% -------------------
% --- z
% -------------------

if ~isfield(args,'z')

  % ------------------------
  % set default if not exist
  % ------------------------

  args.z = [];

else

  % ---------------------------------------------------
  % if already exist, cancel colums with empty clusters
  % ---------------------------------------------------

  nk = sum(args.z);				% population of each cluster
  clasnoempty = find(nk~=0);			% the no empty classes
  args.z = args.z(:,clasnoempty);		% empty classes are cancel

end

% -------------------
% --- pfix
% -------------------

if isfield(args,'pfix')
  if ~strcmp(args.pfix,'yes') & ...		% verify value
     ~strcmp(args.pfix,'no')
    error('========== Argument ''pfix'': unknown value ==========')
  end
else						% set default
  args.pfix = 'no';
end

% -------------------
% --- mufix
% -------------------

if isfield(args,'mufix')
  if ~strcmp(args.mufix,'yes') & ...		% verify value
     ~strcmp(args.mufix,'no')
    error('========== Argument ''mufix'': unknown value ==========')
  end
else						% set default
  args.mufix = 'no';
end

% -------------------
% --- Sfix
% -------------------

if isfield(args,'Sfix')
  if ~strcmp(args.Sfix,'yes') & ...		% verify value
     ~strcmp(args.Sfix,'no')
    error('========== Argument ''Sfix'': unknown value ==========')
  end
else						% set default
  args.Sfix = 'no';
end

% -------------------
% --- zfix
% -------------------

if isfield(args,'zfix')
  if isstr(args.zfix)				% verify value
    if (~strcmp(args.zfix,'yes') & ~strcmp(args.zfix,'no'))
      error('========== Argument ''zfix'': unknown value ==========')
    end
  elseif (length(args.z(:,1)) ~= length(args.zfix))	% same sample size ?
    error('========== Argument ''zfix'': value must have the same length as z ==========')
  end
else						% set default
  args.zfix = 'no';
end

if ~isstr(args.zfix)

  % --------------------------------------
  % control that zfiz has only 0's and 1's
  % --------------------------------------

  if (sum(args.zfix == 0) + sum(args.zfix == 1)) ~= n
    error('========== Argument ''zfix'': only 0 and 1 values possible ==========')
  end

  % ----------------------------------------
  % transform to 'yes' a zfix with only ones
  % ----------------------------------------

  if sum(args.zfix) == n
    args.zfix = 'yes';

  % ----------------------------------------
  % transform to 'no' a zfix with only zeros
  % ----------------------------------------

  elseif sum(args.zfix) == 0
    args.zfix = 'no';
  end

end

if ~strcmp(args.zfix,'yes') & ~strcmp(args.zfix,'no')

  % --------------------------------------
  % cancel colums of z with empty clusters
  % --------------------------------------

  nk = sum(args.z(find(args.zfix),:));		% population of each cluster
  clasnoempty = find(nk~=0);			% the no empty classes
  args.z = args.z(:,clasnoempty);		% empty classes are cancel

end

% -------------------
% --- init
% -------------------

if isfield(args,'init')
  if ~strcmp(args.init,'random centers') & ...	% verify value
     ~strcmp(args.init,'random partition') & ...
     ~strcmp(args.init,'user parameters') & ...
     ~strcmp(args.init,'user partition')
    error('========== Argument ''init'': unknown value ==========')
  end
else						% set default
  args.init = 'random centers';
end

if strcmp(args.zfix,'yes')			% fixed partition
  args.init = 'user partition';
end

if strcmp(args.pfix,'yes') & strcmp(args.mufix,'yes') ...
   & strcmp(args.Sfix,'yes')			% fixed parameters
  args.init = 'user parameters';
end

% -------------------
% --- nbXEM
% -------------------

if ~isfield(args,'nbXEM')			% set default
  if strcmp(args.init,'user partition') | ...
     strcmp(args.init,'user parameters')
    args.nbXEM = 1;
  else
    args.nbXEM = 5;
  end
end

if strcmp(args.zfix,'yes')			% fixed partition:
  args.nbXEM = 1;				% only one XEM
end

% -------------------
% --- nbfailXEM
% -------------------

if ~isfield(args,'nbfailXEM')			% set default
  if strcmp(args.init,'user partition') | ...
     strcmp(args.init,'user parameters')
    args.nbfailXEM = 0;
  else
    args.nbfailXEM = 4;
  end
end

% -------------------
% --- algo
% -------------------

if isfield(args,'algo')				% verify value
  isEM = strcmp(args.algo,'EM');
  isCEM = strcmp(args.algo,'CEM');
  isSEM = strcmp(args.algo,'SEM');
  if ~all(isEM | isCEM | isSEM)
    error('========== Argument ''algo'': unknown value ==========')
  end
else
  args.algo = {'SEM' 'CEM' 'EM'};		% default value
end

if ~iscell(args.algo)				% algo is a cell
  args.algo = {args.algo};
end

if strcmp(args.zfix,'yes')			% fixed partition: only EM
  args.algo = {'EM'};
end

if strcmp(args.pfix,'yes') & strcmp(args.mufix,'yes') ...
   & strcmp(args.Sfix,'yes')			% fixed parameters : only EM
  args.algo = {'EM'};
end

nbalgo = length(args.algo);			% number of chained algo

% -------------------
% --- maxit
% -------------------

if ~isfield(args,'maxit')			% set default
  args.maxit = 500;
end

if strcmp(args.pfix,'yes') & strcmp(args.mufix,'yes') ...
   & strcmp(args.Sfix,'yes')			% fixed parameters : only 1 it.
  args.maxit = 1;
end

if length(args.maxit) == 1
  args.maxit = args.maxit * ones(1,nbalgo);	% maxit has same length as algo
end

if length(args.maxit) ~= nbalgo			% verify this length
  error('========== Argument ''maxit'': invalid length ==========')
end


% -------------------
% --- cvg
% -------------------

if isfield(args,'cvg')
  isxml = strcmp(args.cvg,'xml');
  ispart = strcmp(args.cvg,'partition');
  ismaxit = strcmp(args.cvg,'maxit');
  if ~all(isxml | ispart | ismaxit)		% verify value
    error('========== Argument ''cvg'': unknown value ==========')
  end
else
  args.cvg = cell(1,nbalgo);			% cvg has same length as algo
  for i = 1:nbalgo				% set default
    switch args.algo{i}
      case {'EM','SEM'}, args.cvg{i} = 'maxit';
      case 'CEM', args.cvg{i} = 'partition';
    end
  end
end

if ~iscell(args.cvg)
  args.cvg = {args.cvg};			% must be a cell
end

if length(args.cvg) == 1
  tmp = args.cvg{1};
  args.cvg = cell(1,nbalgo);			% cvg has same length as algo
  for i = 1:nbalgo
    args.cvg{i} = tmp;
  end
end

if strcmp(args.zfix,'yes')			% fixed partition:
  args.cvg = {'partition'};			% only cvg = 'partition'
end

if length(args.cvg) ~= nbalgo			% verify this length
  error('========== Argument ''cvg'': invalid length ==========')
end

% -------------------
% --- cutSEM
% -------------------

if ~isfield(args,'cutSEM')			% set default
  args.cutSEM = 30;
end

if length(args.cutSEM) == 1
  args.cutSEM = args.cutSEM * ones(1,nbalgo);	% cutSEM: same length as algo
end

if length(args.cutSEM) ~= nbalgo		% verify this length
  error('========== Argument ''cutSEM'': invalid length ==========')
end


for i = 1:nbalgo
  if strcmp(args.algo{i},'SEM')
    if args.maxit(i) <= args.cutSEM(i)		% cutSEM must be less that maxit
      error('========== Argument ''cutSEM'': must be less than maxit ==========')
    end
    if args.cutSEM(i) < 0			% cutSEM must be postive
      error('========== Argument ''cutSEM'': must be positive ==========')
    end
  end
end

% -------------------
% --- mod
% -------------------

if isfield(args,'mod')				% verify value
  if length(args.mod(1,:)) ~= 4			% length
    error('========== Argument ''mod'': proportions, volume, orientation and shape ==========')
  end
  ispropfree = strcmp(args.mod(:,1),'propfree');
  ispropequal = strcmp(args.mod(:,1),'propequal');
  isvolequal = strcmp(args.mod(:,2),'volequal');
  isvolfree = strcmp(args.mod(:,2),'volfree');
  isorientequal = strcmp(args.mod(:,3),'orientequal');
  isorientaxis = strcmp(args.mod(:,3),'orientaxis');
  isorientfree = strcmp(args.mod(:,3),'orientfree');
  isshapespher = strcmp(args.mod(:,4),'shapespher');
  isshapeequal = strcmp(args.mod(:,4),'shapeequal');
  isshapefree = strcmp(args.mod(:,4),'shapefree');
  if ~all(ispropfree | ispropequal) | ...
     ~all(isvolfree | isvolequal) | ...
     ~all(isorientequal | isorientaxis | isorientfree) | ...
     ~all(isshapespher | isshapeequal | isshapefree)
    error('========== Argument ''mod'': unknown value ==========')
  end
else						% set default
  args.mod = {'propfree' 'volfree' 'orientfree' 'shapefree'};
end

% -------------------
% --- K
% -------------------

if ~isfield(args,'K')				% set default
  Ksup = ceil(n^0.3);				% define Ksup
  if strcmp(args.init,'user parameters')
    args.K = length(args.mu(1,:));		% given by mu if user parameters
  elseif strcmp(args.init,'user partition')
    args.K = length(args.z(1,:));		% given by z if user partition
  elseif strcmp(args.zfix,'yes')
    args.K = length(args.z(1,:));		% given by z if z is fixed
  elseif strcmp(args.pfix,'yes')
    args.K = length(args.p(1,:));		% given by p if p is fixed
  elseif strcmp(args.mufix,'yes')
    args.K = length(args.mu(1,:));		% given by mu if mu is fixed
  elseif strcmp(args.Sfix,'yes')
    args.K = length(args.S(:,1)) / length(args.S(1,:));
						% given by S if S is fixed
  elseif ~strcmp(args.zfix,'yes') & ...		% Kinf given by z if
         ~strcmp(args.zfix,'no')		% z is partially fixed
    Kinf = length(args.z(1,:));
    args.K = Kinf:max(Kinf,Ksup);
  else
    args.K = 1:Ksup;
  end
end

% -------------------
% --- crit
% -------------------

if isfield(args,'crit')
  if ~strcmp(args.crit,'ICL') & ...		% verify value
     ~strcmp(args.crit,'BIC') & ...
     ~strcmp(args.crit,'NEC') & ...
     ~strcmp(args.crit,'CV')
    error('========== Argument ''crit'': unknown value ==========')
  end
else						% set default
  if strcmp(args.zfix,'yes')
    args.crit = 'CV';				% CV in discriminant analysis
  else
    args.crit = 'ICL';				% ICL otherwise
  end
end

% =============================================================================
