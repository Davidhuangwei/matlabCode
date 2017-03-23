% Words = SplitString(String, Delimiters)
%
% splits string using strtok.  Output is a cell array of words

function Words = SplitString(String, Delimiters)

if (nargin == 1)
	Delimiters = [9:13 32]; % White space characters
end

Remainder = String;

i = 1;
while(~isempty(Remainder))
	[Word Remainder] = strtok(Remainder, Delimiters);
	if ~isempty(Word)
		Words{i} = Word;
	end
	i = i+1;
end