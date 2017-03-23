% SaveHeadedArray(FileName, Data, Headers)
% or SaveHeaddedArray(FileName, StructArray)
%
% Saves a white space-separated numeric array which has a
% single line on top giving column headings.  If 3 argument form
% is used, Headers is in a cell array.  Otherwise, input is
% a structure array.

function SaveHeadedArray(FileName, Data, Headers)


if nargin<3
	StructArray = Data;
	Data = [];
	Headers = fieldnames(StructArray);
	for i=1:length(Headers)	
        Column = getfield(StructArray, Headers{i});
		Data(:,i) = Column(:);
	end
end

fp = fopen(FileName, 'w');

for i=1:length(Headers)
	fprintf(fp, '%s ', Headers{i});
end
fprintf(fp, '\n');

format = repmat('%d ', 1, length(Headers));
format = [format '\n'];
fprintf(fp, format, Data');

fclose(fp);