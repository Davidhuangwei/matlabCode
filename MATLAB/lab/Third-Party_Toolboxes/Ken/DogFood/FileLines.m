% FileLines(FileName)
%
% Returns the number of lines in the specified file
% If the file is not there, returns -1.


function n = FileLines(FileName);

fp = fopen(FileName);

if (fp == -1)
	n = -1;
	return;
end;

n = 0;
while(~feof(fp))
	line = fgets(fp);
	n = n+1;
end;