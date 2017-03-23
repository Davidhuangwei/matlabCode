function out=icassoGet(sR,field,index)
%function out=icassoGet(sR,field,[index])
%
%PURPOSE 
%
%To return information from the Icasso result data struct related to 
%original data: data matrix, 
%               (de)whitening matrix
%IC estimates:  total number of estimates, 
%               number of estimates on each round, 
%               estimated independent components (sources), 
%               estimated (de)mixing matrices 
%
%EXAMPLES OF BASIC USAGE
%
%First we compute estimates...
%
% sR=icassoEst('randinit',sf12,10); 
%
%Let's see what happened:
%
%  M=icassoGet(sR,'m');        
% 
%returns total number of estimates into worksapce variable M.
% 
% s=icassoGet(sR,'source'); 
%
%returns _all_ M estimated independent components (sources)
%into workspace variable s:
%
% W=icassoGet(sR,'demixingmatrix',[25 17 126]); 
%
%returns the demixing matrix row for estimates 25, 17, and 126
% 
%  r=icassoGet(sR,'round',[25 17 126]); 
% 
%r contais now a 3x2 matrix where the first column shows
%estimation round and second order of appearance within round for
%the estimate: 
%e.g. 2  5 : estimate 25 was 5th estimate on round 2
%     1 17 :          17     1st                   1
%     7  6           126     6th                   7
%
%INPUTS []'s mean optional arguments 
%
% sR   (struct) Icasso result data struct resulting from icassoEst.
% field (string) determines, what icassoGet returns. It has to be
%         one of the following string (case insensitive)
%
% 'data'           the original data (mean is removed) 
% 'N'              the number of estimation rounds (N)  made
% 'M'              the number of estimates (M) available in sR
% 'round'          an Mx2 matrix (out) that identifies from which estimation 
%                  round each estimate originates from: 
%                   out(i,1) is the estimation round for estimate i,
%                   out(i,2) is the ordinal number of the estimate
%                   within the round, respectively.
% 'dewhitemat'     dewhitening matrix for the original data
% 'whitemat'       dewhitening matrix for the original data
% 'mixingmatrix'   mixing matrix rows ('A' works as well)  
% 'demixingmatrix' demixing matrix columns ('W' works as well)
% 'source'         (estimated) source signals 
%
% [index] (vector of integers) specifies which estimates to return 
%          Applies only for 'mixingmatrix','demixingmatrix', and 'source'
%          Default: leaving this argument out corresponds to selecting all
%          estimates, i.e., giving [1:M] as index vector.
%
%INDEXING CONVENTION
% See function icassoEst.
%
%OUTPUT
%
% out   (type and meaning vary according to input argument 'field')
%

%COPYRIGHT NOTICE
%This function is a part of Icasso software library
%Copyright (C) 2003 Johan Himberg
%
%This program is free software; you can redistribute it and/or
%modify it under the terms of the GNU General Public License
%as published by the Free Software Foundation; either version 2
%of the License, or any later version.
%
%This program is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.
%
%You should have received a copy of the GNU General Public License
%along with this program; if not, write to the Free Software
%Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

M=size(sR.index,1);

if nargin<3,
   index=1:M;
end

switch lower(field)
 case 'm'
   out=size(sR.index,1);
 case 'n'
  out=length(sR.A);
 case {'a','mixingmatrix'}
  out=getMixing(sR,index);   
 case {'w','demixingmatrix'}
  out=getDeMixing(sR,index);   
 case 'data'
  out=sR.signal;   
 case {'dewhitemat'}
  out=sR.dewhiteningMatrix;
 case {'whitemat'}
  out=sR.whiteningMatrix;
 case 'source'
  out=getSource(sR,index);
 case 'round'
  out=sR.index(index,:)
 otherwise  
   error('Unknown operation.');
end

function A=getMixing(sR,index);
%
%function A=getMixing(sR,index);
%

% reindex
index2=sR.index(index,:);
N=size(index2,1); A=[];
for i=1:N,
   A(:,i)=sR.A{index2(i,1)}(:,index2(i,2));
end
   
function W=getDeMixing(sR,index);
%
%function W=getDeMixing(sR,index);
%

% reindex
index2=sR.index(index,:);
N=size(index2,1); W=[];
for i=1:N,
   W(i,:)=sR.W{index2(i,1)}(index2(i,2),:);
end
   
function S=getSource(sR,index)
%function S=getSource(sR,index)
%
%

X=sR.signal;
W=getDeMixing(sR,index);
S=W*X;

%% Old stuff 
%function dWh=getDeWhitening(sR,index);
%
%function dWh=getDeWhitening(sR,index);
%
%
%index=sR.index(index,:);
%Nindex=size(index,1); W=[];
%for i=1:Nindex,
%   dWh(:,i)=sR.dewhiteningMatrix{1}(:,index(i,2));
%end


%function W=getWhitening(sR,index);
%
%function W=getWhitening(sR,index);
%
%
%index=sR.index(index,:);
%Nindex=size(index,1); W=[];
%for i=1:Nindex,
%   W(:,i)=sR.whiteningMatrix{index(i,1)}(:,index(i,2));
%end

