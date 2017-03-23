% [Data Headers] = LoadHeadedArray(FileName)
% or Out = LoadHeadedArray(FileName)
%
% Loads up a white space-separated NUMERIC array which has a 
% single line on top giving column headings.  If two output arg
% is used, returns headers in cell array.  Otherwise, output is
% a structure array.


function [Data, Headers] = LoadHeadedArray(FileName)

fp = fopen(FileName);


% Get header line

HeadLine = fgetl(fp);

Headers = {};
cnt = 1;
while(HeadLine)
	[Token HeadLine] = strtok(HeadLine);
    if isempty(Token)
        break;
    end
	Headers{cnt} = Token;
	cnt = cnt+1;
end;

nColumns = length(Headers);

% now load the whole file, using atofEngine ... so it's not thrown by non-numerics
TmpFile = tempname;
eval(['!/u5/b/ken/bin/atofEngine "' FileName '" ' TmpFile]);
RawData = bload(TmpFile, [1 inf], 0, 'double');
Size = RawData(1:2);

Data = reshape(RawData(3:end),Size)';
Data(1,:) = [];

if nargout==1
	Out = [];

	for i=1:nColumns
		Out = setfield(Out, Headers{i}, Data(:,i));
	end

	Data = Out;
end


return