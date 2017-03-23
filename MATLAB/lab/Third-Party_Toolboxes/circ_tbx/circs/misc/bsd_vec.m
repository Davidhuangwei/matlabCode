% BSD_VEC - bootstrap directions, for vector statistics.   
% modified from BSD 
% call              [ RANK, PD, R, MX ] = BSD_VEC( X, NBS, THETA, GRAPHICS )
%
% gets              x           cell array (1 dimensional - each cell =
%                               1 dir, matrix of rows = time, cols = trials
%                   nbs         number of bootstrap trials
%                   theta       angles of the directions
%                   v2s         string, how to reduce vector to scalar. 
%                               eg 'rms'           
%
% returns           rank        of original sample among bootstrapped
%                   pd, R       mean and resultant length of original sample
%                   mx          the mean response per direction
%
% does              algorithm as in Crammond & Kalaska 1996
%
% note              1. x should have same number of columns as theta
%                   2. data in x are vectors (eg lfp, ifr) - all should be with same length 
%
% see also          COMP_RS, MIXMAT, DIR_MEAN, DO_RMS, MY_MEAN

% 21oct04 IA from every vector create scalar (internal function do_v2s), from the 6 scalars compute scalar statistic 
%            only cell array input format supported.         
% 12jan05 mixmat w/o replacement, rank computation w/o + 1 
function [ rank, pd, R, mxs, Rs ] = bsd_vec( x, nbs, theta, v2s, graphics )

debugMode = 0;
lf=0; 
MAXNBS = 250; % for memory handling was 2500, bad for 06sep02  
% input check
if nargin < 2, error( '2 arguments' ), end
if nargin < 3 | isempty( theta )
    theta = [1/6 0 5/6:-1/6:1/3]'*2*pi;
end
if nargin<4 | isempty(v2s), 
    v2s='rms'; 
end 
if nargin < 5 | isempty( graphics )
    graphics = 0;
end

% handle cell array & change to 3d array 
if iscell( x )
    len = length( x );
    if prod( size( x ) ) ~= len
        error( 'input format mismatch' )
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
if n ~= length( theta )
    error( 'input size mismatch' )
end

% compute statistics
% mx = my_mean( x, 1 )';
mx=nanmean(x); % returns size 1*6*dur, my_mean cannot be used (>2 dim)   
mx=reshape(mx,len,dur(1)); % 6*dur 
mx=mx'; % dur*6 
mxs=do_v2s(mx,v2s); 
[ pd S0 s0 ] = dir_mean( theta, mxs );
R = 1 - S0;

% format and replicate
% nans = isnan( x );
% ridx = [ 0 cumsum( sum( ~nans, 1 ) ) ];
ridx = [0 cumsum(nt)];  
allinds=1:ridx(end); 
allinds=allinds(:); 
ALLINDS=repmat(allinds, 1, nbs); 
% x = x( : );
% x( nans ) = [];
% X = repmat( x, 1, nbs );
x=reshape(x,m*n,t); % total N*dur  
x=x'; % dur * N   
trial_exists=trial_exists( : );
x(:,~trial_exists)=[]; 
% mix and compute rank
% mixX = mixmat( X, 1, 2 );
mixINDS = mixmat( ALLINDS, 1, 1 ); % size total nt * nbs 
temp_mean=zeros(t,nbs); 
meanX=zeros(n,nbs); 
for i = 1 : n
    %     disp(['dir ' num2str(i)]);
    indx = ridx( i ) + 1 : ridx( i + 1 ); % which nt(i) trials to take as belonging to this dir 
    if lf 
        for j=1:nbs 
            temp_mean(:, j) = my_mean(x(:,mixINDS( indx, j ) ), 2); % an averaging of resampled vectors produces vector 
        end      
    else  
        % w/o loop 
        bsinds=unique([MAXNBS*[0:floor(nbs/MAXNBS)] nbs]);
        for j=1:length(bsinds)-1   
            %         tx=x(:,mixINDS( indx, : )); % this is dur * (nt*nbs) nt trials' traces, then nt trials etc. 
            %         tx=reshape(tx,dur(i),nt(i),nbs);
%             tx=zeros(dur(i),nt(i)*(bsinds(j+1)-bsinds(j)));
            tx=x(:,mixINDS( indx, bsinds(j)+1:bsinds(j+1) )); % this is dur * (nt*nbs) nt trials' traces, then nt trials etc. 
            tx=reshape(tx,dur(i),nt(i),bsinds(j+1)-bsinds(j));
            temp_mean(:,bsinds(j)+1:bsinds(j+1))=mean(tx,2); 
        end 
                temp_mean=reshape(temp_mean,dur(i),nbs); 
    end %  
    meanX(i, : ) = do_v2s(temp_mean,v2s); % in order to compute R we reduce to scalar         
end

Rs = comp_rs( theta, meanX );
% rank = ( sum( Rs < R ) + 1 ) / ( nbs + 1 );
rank = ( sum( Rs < R ) ) / ( nbs  );

if debugMode
    subplot( 222 ), hist( Rs, 20 ), separators( R );
    tstr = sprintf( 'rank = %0.3g; pd = %0.3g; r = %0.3g', rank, pd, R );
    h = subplot( 2, 1, 2 );
    plot_circ( theta, mxs, h, [], 8 );
    title( tstr )
end

if graphics
    newplot
    plot_circ( theta, mxs, gca, [], 0 );
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