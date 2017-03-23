function x=MonthsYear(varargin)
% function x=MonthsYear(year) returns the first day of each month in year
% input: year: the year you are interested in, e.g., 2001
% default: year = 1980;
% output: x-> in row; size: 1*12
% YY C
if nargin<1
    y=1980;
else
    y=varargin{1};
end
x=[1,eomday(y,1:12)]*triu(ones(13));
x=x(1:12);