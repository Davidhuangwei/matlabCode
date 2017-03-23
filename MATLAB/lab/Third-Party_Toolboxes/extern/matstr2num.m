function x = matstr2num(s)
%MATSTR2NUM String to number conversion.
%       X = MATSTR2NUM(S)  converts the matrix of strings S, which should 
%       be an ASCII character representation of numeric values, to MATLAB's
%       numeric representation.  The string may contain digits, a decimal
%       point, a leading + or - sign, an 'e' preceeding a power of 10 scale
%       factor, and an 'i' for a complex unit.
%	If the string S is a matrix, then MATSTR2NUM will return a column
%	vector, otherwise the answer will be a scalar.
%       If the string S does not represent a valid number, STR2NUM(S)
%       returns the empty matrix.
%
%       See also NUM2STR, HEX2NUM.

%       Copyright (c) 1984-93 by The MathWorks, Inc.
%	Modified by Tristram Scott 30/10/93 to handle vectors.
[m,n]=size(s);
if min(m,n) > 1
	%must be expecting a column vector
	s=str2mat('[',s,']');
	s(1:m+1,n+1)=';'*ones(m+1,1);
	s=setstr(s);
end
x = eval(s','[]');
