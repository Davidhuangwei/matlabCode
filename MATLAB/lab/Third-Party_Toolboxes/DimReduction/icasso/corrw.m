function R=corrw(W,C)
%function R=corrw(W,C)
%
%PURPOSE
%
%To compute mutual linear correlation coefficients between M
%independent component estimates (sources) s using the demixing
%matrix W and the covariance matrix C of the original data. 
%
% R=W*C*W'; 
%
%which corresponds to computing 
% 
% R=corrcoef(s');
%
%but obviously requires less computing.
%
%INPUTS
%
% W (Mxd matrix) demixing matrix 
% C (dxd matrix) the covariance of the original data
%
%OUTPUTS 
%
% R (MxM matrix) of linear correlation coefficients
%
%SEE ALSO
% icassoSimilarity.m

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

R=W*C*W';

