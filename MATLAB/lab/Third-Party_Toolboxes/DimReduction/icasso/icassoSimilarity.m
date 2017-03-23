function sR=icassoSimilarity(sR,simfcn)
%
%function sR=icassoSimilarity(sR,[simfcn])
%
%PURPOSE
%
%To compute a similarity matrix, e.g., linear correlation
%coefficient or absolute value of correlation, between the
%independent component estimates.  
%
%EXAMPLE OF BASIC USAGE
%
% sR=icassoSimilarity(sR); 
%
%uses the default way of computing the similarity matrix S between
%the estimates, i.e.,  the absoulute value of their mutual correlation
%coefficient. S is written back to workspace variable sR.
%
% newR=icassoSimilarity(sR,'power');
%
%as previous, but similarity function 'power' is used instead, and
%the results are copied into a new workspace variable newR.
%
%INPUTS []'s mean optional
%
% sR       (struct) Icasso result struct; output of icassoEst
% [simfcn] (string) 'abscorr' (default) | 'power' | 'corr'
%
%OUTPUT
%
% sR (struct) Updated Icasso result struct, 
%
%The function updates _only_ the following fields:
%  
%sR.cluster.simfcn     (string)     contains simfcn
%sR.cluster.similarity (MxM matrix) similarity matrix S, that is, 
%                                    similarities between ICA estimates
%
%There are other fields in Icasso result struct sR that depend on
%mutual similarities. They are not recomputed or cleared
%automatically by icassoSimilarity, but remain unchanged in
%the output, and must be updated by calling the appropriate
%functions. See icassoStruct. 
%
%DETAILS
%
%simfcn     Similarity matrix S computed as follows
%
%'abscorr'  S(i,j) the absolute value of Pearson's linear correlation
%            coefficient between estimates i and j.
%'power'    S(i,j) as 'abscorr' but the correlations are computed
%            between squared source estimates (IC estimates).
%'corr'     S(i,j) is Pearson's linear correlation coefficient between
%            estimates i and j.
%
%SEE ALSO
% icassoStruct.m
% icassoExp.m

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

%% Default simfcn
if nargin<2|isempty(simfcn),
  simfcn='abscorr';
end

% we are case insensitive
simfcn=lower(simfcn);

switch simfcn
 case 'corr'
  switch sR.mode
   case 'randinit'
    D=icassoGet(sR,'dewhitemat');
    W=icassoGet(sR,'demixingmatrix');
    S=corrw(W,D*D');
   case {'bootstrap','both'}
    s=icassoGet(sR,'source');
    S=corrcoef(s');
  end
 case 'abscorr'
  switch sR.mode
   case {'randinit'}
    D=icassoGet(sR,'dewhitemat');
    W=icassoGet(sR,'demixingmatrix');
    S=abs(corrw(W,D*D'));
   case {'both','bootstrap'}
    s=icassoGet(sR,'source');
    S=abs(corrcoef(s'));
  end
  S=abs(S);
 case 'power'
  switch sR.mode
   case {'randinit','bootstrap','both'}
    s=icassoGet(sR,'source');
    s=remmean(s).^2;
    S=abs(corrcoef(s'));
  end
 otherwise
  error(['Unknown similarity function ''' simfcn '''.']);
end

% Just to make things sure

switch simfcn 
 case {'abscorr','power'}
  S(S>1)=1; S(S<0)=0;
 case 'corr'
  S(S>1)=1; S(S<-1)=-1;
end

sR.cluster.similarity=S;
sR.cluster.simfcn=simfcn;