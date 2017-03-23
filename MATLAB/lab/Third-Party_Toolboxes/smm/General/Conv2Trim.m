function output = Conv2Trim(varargin)
%function output = Conv2Trim(varargin)
% calls matlab built in funtion conv2 and then trims edges to return an
% output matrix of the same size as the input matrix A
%
%CONV2 Two dimensional convolution.
%   C = CONV2(A, B) performs the 2-D convolution of matrices
%   A and B.   If [ma,na] = size(A) and [mb,nb] = size(B), then
%   size(C) = [ma+mb-1,na+nb-1].
%
%   C = CONV2(H1, H2, A) convolves A first with the vector H1 
%   along the rows and then with the vector H2 along the columns.
%
%   C = CONV2(..., SHAPE) returns a subsection of the 2-D
%   convolution with size specified by SHAPE:
%     'full'  - (default) returns the full 2-D convolution,
%     'same'  - returns the central part of the convolution
%               that is the same size as A.
%     'valid' - returns only those parts of the convolution
%               that are computed without the zero-padded
%               edges. size(C) = [ma-mb+1,na-nb+1] when
%               all(size(A) >= size(B)), otherwise C is 
%               an empty matrix [].
%
%   If any of A, B, H1, and H2 are empty, then C is 
%   an empty matrix [].
%
%   See also CONV, CONVN, FILTER2 and, in the Signal Processing
%   Toolbox, XCORR2.

%   Copyright 1984-2005 The MathWorks, Inc.
%   $Revision: 5.21.4.4 $  $Date: 2005/04/28 19:52:27 $
%   Built-in function.
output = conv2(varargin{:});
if ndims(varargin{2})<2
    output = output(ceil(length(varargin{2})/2):end-floor(length(varargin{2})/2),ceil(length(varargin{2})/2):end-floor(length(varargin{2})/2));
else
    output = output(ceil(length(varargin{1})/2):end-floor(length(varargin{1})/2),ceil(length(varargin{2})/2):end-floor(length(varargin{2})/2));
end  
return
end


%CONV2 Two dimensional convolution.
%   C = CONV2(A, B) performs the 2-D convolution of matrices
%   A and B.   If [ma,na] = size(A) and [mb,nb] = size(B), then
%   size(C) = [ma+mb-1,na+nb-1].
%
%   C = CONV2(H1, H2, A) convolves A first with the vector H1 
%   along the rows and then with the vector H2 along the columns.
%
%   C = CONV2(..., SHAPE) returns a subsection of the 2-D
%   convolution with size specified by SHAPE:
%     'full'  - (default) returns the full 2-D convolution,
%     'same'  - returns the central part of the convolution
%               that is the same size as A.
%     'valid' - returns only those parts of the convolution
%               that are computed without the zero-padded
%               edges. size(C) = [ma-mb+1,na-nb+1] when
%               all(size(A) >= size(B)), otherwise C is 
%               an empty matrix [].
%
%   If any of A, B, H1, and H2 are empty, then C is 
%   an empty matrix [].
%
%   See also CONV, CONVN, FILTER2 and, in the Signal Processing
%   Toolbox, XCORR2.

%   Copyright 1984-2005 The MathWorks, Inc.
%   $Revision: 5.21.4.4 $  $Date: 2005/04/28 19:52:27 $
%   Built-in function.

