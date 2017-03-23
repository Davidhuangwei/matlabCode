% Pos = ContainsToken(Tok, Str)
%
% searches for token Tok in string Str.  Returns the positions of
% tokens which are preceded and ended by non-alphanumeric characters.
%
% e.g. the token 'The' would be found in '(10+The)' but not in '(10+Theta)'
%
% see also findstr

function Pos = ContainsToken(Tok, Str)

% pad string
%Str = strcat(' ', Str, ' ');
Str = [' ' Str ' '];

AllPos = findstr(Tok, Str);

AlphaChars = [double('0'):double('9') double('a'):double('z') double('A'):double('Z')];

LeftOK = ~ismember(Str(AllPos-1), AlphaChars);
RightOK = ~ismember(Str(AllPos+length(Tok)), AlphaChars);

Pos = AllPos(find(LeftOK & RightOK))-1; % subtract 1 to correct for space added