% String = CommaList(Vec, Format)
%
% a simple function that produces a comma-separated list using
% sprintf. e.g.: CommaList(1:3) is '1, 2, 3'.
%
% second argument default is '%d'.  Use '%f' for floating point.
%
% also works if first arg is a cell array of strings

function String = CommaList(Vec, Format)

if iscell(Vec)
    String = [];
    for i=1:length(Vec)
        String = [String ', ' Vec{i}];
    end
    String(1:2) = [];
    return
end

if nargin<2
	Format = '%d';
end

String = sprintf([', ' Format], Vec);
String(1:2) = [];