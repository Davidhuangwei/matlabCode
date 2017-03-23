% BSO_VEC - bootstrap objects, for vector statistics.   
% input X - data cell array, each cell is duration*ntrials 
%        nbs - N BS repetitions
%        v2s - string, transformation method from vector to scalar (see bsd_vec)
%              used in internal function do_v2s: {'rms'}, 'max', 'min', 'p2p' 
%        alpha - significance level for 2 sided test for the statistic rank
% output po - 0/1/2 [this function currently works for 2 objs only] 
%        rank - rank of the statistic (from start or end) 
%        mxs - mean responses (scalars) 
%        S - statistic (difference / sum of scalar responses) 
%        BSS - bootstrapped statistics sample 
% 
% does              algorithm as in Crammond & Kalaska 1996
%
% note              1. x should 2 columns (2 objs) 
%                   2. data in x are vectors (eg lfp, ifr) - all should be with same length 
%
% see also          MIXMAT, DO_RMS, MY_MEAN, 
% 26oct04 IA 
% 07nov04 IA if x contains data of >2 objs, then compare the best two 
% 12jan04 IA symmetry of rank for 2-tailed corrected (see generalized form in calc_p) 
%              <= not < for significant; mixmat w/o replacement
% 28jan05 lf argument : statistic for obj preference: {1} limited (division by sum), 0 not  
function [ rank, po, mxs, S, BSS ] = bso_vec( x, nbs, v2s, alpha, lf )

debugMode = 0;
MAXNBS = 100; % for memory handling was 2500, bad for 06sep02  
% input check
if nargin < 2, error( '2 arguments' ), end
if nargin<3 | isempty(v2s), 
    v2s='rms'; 
end 
if nargin<4 | isempty(alpha), 
    alpha=0.01; 
end 
if nargin<5 | isempty(lf), 
    lf=1; 
end 

% handle cell array & change to 3d array 
if iscell( x )
    orig_x=x; 
    len = length( x );
    if prod( size( x ) ) ~= len
        error( 'input format mismatch' )
    end
    % temp 
    if len>2 
        disp('X contains >2 data groups, only 2 "best" objects will be compared'); 
    elseif len<2, error('min 2 objs needed, comparison not available')     
    end
    for i = 1 : len
        [dur( i )  nt( i )] = size( x{ i } );
    end
    if(length(unique(dur))~= 1)
        error( 'input duration mismatch' )
    end 
    xx = NaN * ones( dur(1), max( nt ), len );
    trial_exists = zeros(max(nt), len); 
    for i = 1 : len
        xx( :, 1 : nt( i ), i ) = x{ i };    
        trial_exists(1:nt(i),i)=1;     
    end
    xx=permute(xx,[2 3 1]); 
    x = xx;
    clear xx;
else error('x should be a cell array'); 
end

[ m n t] = size( x );

% compute statistics
mx=nanmean(x); % returns size 1*n*t, my_mean cannot be used (>2 dim)   
mx=reshape(mx,len,dur(1)); % len*dur 
mx=mx'; % dur*len 
mxs=do_v2s(mx,v2s); 
% reduce to only 2 best objects 
if len>2 
    [ig oinds] = sort(mxs);    
    candidate_orgs=oinds(end-1:end);         
    len=2; clear dur; clear nt; 
    for i = 1:len
        [dur( i )  nt( i )] = size( orig_x{ candidate_orgs(i) } );
    end
    xx = NaN * ones( dur(1), max( nt ), len );
    trial_exists = zeros(max(nt), len); 
    for i = 1 : len
        xx( :, 1 : nt( i ), i ) = orig_x{ candidate_orgs(i) };    
        trial_exists(1:nt(i),i)=1;     
    end
    xx=permute(xx,[2 3 1]); 
    x = xx;
    clear xx; clear orig_x; 
    [ m n t] = size( x );
    mx=mx(:,candidate_orgs); 
    mxs=mxs(candidate_orgs); 
else 
    candidate_orgs=[1 2]; 
    clear orig_x;
end    
% 
if lf 
S=diff(mxs)/sum(mxs); 
else 
S=diff(mxs); 
end    
if S>0, 
    temp_po=candidate_orgs(2); 
else, temp_po=candidate_orgs(1); 
end    
% format and replicate
ridx = [0 cumsum(nt)];  
allinds=1:ridx(end); 
allinds=allinds(:); 
ALLINDS=repmat(allinds, 1, nbs); 
x=reshape(x,m*n,t); % total N*dur  
x=x'; % dur * N   
trial_exists=trial_exists( : );
x(:,~trial_exists)=[]; 
% mix and compute rank
mixINDS = mixmat( ALLINDS, 1, 2 ); % size total nt * nbs 
temp_mean=zeros(t,nbs); 
meanX=zeros(n,nbs); 
for i = 1 : n
    indx = ridx( i ) + 1 : ridx( i + 1 ); % which nt(i) trials to take as belonging to this obj
        % w/o loop 
        bsinds=unique([MAXNBS*[0:floor(nbs/MAXNBS)] nbs]);
        for j=1:length(bsinds)-1   
            tx=x(:,mixINDS( indx, bsinds(j)+1:bsinds(j+1) )); % this is dur * (nt*nbs) nt trials' traces, then nt trials etc. 
            tx=reshape(tx,dur(i),nt(i),bsinds(j+1)-bsinds(j));
            temp_mean(:,bsinds(j)+1:bsinds(j+1))=mean(tx,2); 
        end 
    temp_mean=reshape(temp_mean,dur(i),nbs); 
    meanX(i, : ) = do_v2s(temp_mean,v2s); % in order to compute R we reduce to scalar         
end
if lf 
BSS = diff(meanX) ./ sum(meanX); 
else 
    BSS = diff(meanX); 
end 
% rank = ( sum( BSS < S ) + 1 ) / ( nbs + 1 );
rank = ( sum( BSS < S ) ) / ( nbs );
rank = min([rank 1-rank]); 
if rank<=alpha/2, % note (1) 2 sided
    po=temp_po; 
else
    po=0; % (2) in contrast to PD of bsd, bsd_vec - return '0' if ns ! 
end

if debugMode
    figure; 
    hist( BSS, 20 ), separators( S );
    tstr = sprintf( 'rank = %0.3g; po = %0.3g; S = %0.3g', rank, po, S );
    axe_title( tstr );
end

return

% do transform T on data matrix A to reduce it to a line vector B    
function B=do_v2s(A,T)
len=size(A,2); 
switch T
    case 'rms'
        [ig1,ig2,B]=do_rms(A); 
    case 'max' 
        B=max(A); 
    case 'min' 
        B=min(A); 
    case 'p2p' 
        B=zeros(1,len); 
        for k=1:len
            p=local_max(A(:,k),'ext');  
            if length(p)>1, 
                B(k)=max(abs(diff(p)));     
            else 
                B(k)=abs(p);
            end 
        end 
    otherwise
        error('unsupported vector to scalar reduction'); 
end
return