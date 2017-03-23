% [nLines, nWords, nChars] = WordCount(FileName)
%
% Counts number of lines words and characters in 
% specified file.  Works by running unix wc command
%
% NB if you have only one output variable it is number
% of LINES, not words.

function [nLines, nWords, nChars] = WordCount(FileName)

Command = ['wc ', FileName];

[status, result] = unix(Command);

if (status~=0) 
	error(['WordCount failed!  Unix error: ', result]);
end;

Parsed =  sscanf(result, '%d');

nLines = Parsed(1);
nWords = Parsed(2);
nChars = Parsed(3);