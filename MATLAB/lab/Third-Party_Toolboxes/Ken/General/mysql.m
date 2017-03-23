% Out = mysql(Query, db);
% or [Out1, Out2, ...] = mysql(Query, db, FormatString)
%
% runs a mysql command Query on database db, as default user.
%
% the output is returned in a structure array of strings.
% unless you select FormatString, in which case they are read
% in according to that and placed in the variable number of 
% output arguments.  If FormatString is 'numeric', all inputs
% will be parsed as numbers, and returned in a single struct array
% like you might pass to xgobi.

function varargout = mysql(Query, db, FormatString);

if nargin<3
	FormatString='';
end

QueryFile = tempname;
OutFile = tempname;

fp = fopen(QueryFile, 'w');
fprintf(fp, '%s\n', Query);
fclose(fp);

Cmd = sprintf('/usr/bin/mysql -h theta %s < %s > %s', db, QueryFile, OutFile);
[s w] = system(Cmd);

if s
    error(sprintf('SQL produced error %s', w));
end

if strcmp(FormatString, 'numeric')
    varargout{1} = LoadHeadedArray(OutFile);   
elseif isempty(FormatString)
    Data = LoadStringArray(OutFile,9);
	if length(Data)>1
        % now make headed array
	
		Out = [];
        for i=1:size(Data, 2);
        	Out = setfield(Out, Data{1,i}, Data(2:end,i));
        end
	else
        Out = [];
	end
    
    varargout{1} = Out;
else
    nout = nargout + (nargout==0);
    [varargout{1:nout}] = textread(OutFile, FormatString, 'headerlines', 1);
end

% remove temp files
eval(['!rm ' QueryFile]);
eval(['!rm ' OutFile]);
