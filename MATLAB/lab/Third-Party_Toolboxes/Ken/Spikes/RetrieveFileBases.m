% FileBases = RetrieveFileBases(Description, db)
%
% helper function to find filebases matching a given description
% or list of descriptions.
%
% empty = any description
% string = uses SQL "LIKE" to match - so use % as a wildcard
% cell array of strings = all matching any.
%
% if db is [], or only 1 arg passed, Description should be a list of
% FileBases, passed straight back out.

function FileBases = RetrieveFileBases(Description, db)

if nargin==1 | isempty(db)
    FileBases = Description;
    return;
end

if isempty(Description)
    FileBases = mysql(['SELECT FileBase FROM Files'], db, '%s');
elseif ischar(Description)
    FileBases = mysql(['SELECT FileBase FROM Files WHERE Description LIKE "' ...
        Description '"'], db, '%s');
elseif iscell(Description)
	DescriptionList = ['"' Description{1} '"'];
	for i=2:length(Description)
		DescriptionList = sprintf('%s, "%s"', DescriptionList, Description{i});
	end
    FileBases = mysql(['SELECT FileBase FROM Files WHERE Description IN (' ...
        DescriptionList ')'], db, '%s');
else
    error('Description must be empty (for any description), string, or cell array of strings');
end
