% [colors glyphs] = xgobi(data, colors, glyphs, labels)
%
% initiates an xgobi process from the array data
% colors is an optional array of colors.
% The entries of colors should be numbers in the
% range 1 to 10, which are then translated to the
% color names used by xgobi.
%
% glyphs is an optional array of glyph numbers -
% to find out what number means what glyph look at
% the 'Glyph' menu on the 'Brush' screen of xgobi.
% "Points" is 31.  Default "tiny filled circle" is 26.
%
% Any Infs or NaNs will cause removal of that data line
%
% labels gives labels for the _points_.  This should be a
% cell array or character array.
%
% to get labels for columns, pass a structure array as data
% -then you get the structure fields as labels
%
% optional output arguments give final brushing

function [colorsOut, glyphsOut] = xgobi(data, colors, glyphs, labels)

% generate file name
FileBase = tempname;

% is data a structure array?
if isstruct(data)
	FieldNames = fieldnames(data);
	for i=1:length(FieldNames)	
		d = getfield(data, FieldNames{i});
        nPoints(i) = length(d);
		d2(1:nPoints(i),i) = d(:);
%		d2(:,i) = eval(['[data.' FieldNames{i} ']'])';
	end
    if max(nPoints)~=min(nPoints)
        MaxLen = max(nPoints);
        warning('Not all columns are the same length! Only plotting points for which all columns are there');
        for i=1:length(FieldNames)
            d2(nPoints(i)+1:MaxLen) = NaN;
        end
    end
	data = d2;
	
	fp = fopen([FileBase '.col'], 'w');
	fprintf(fp, '%s\n', FieldNames{:});
	fclose(fp);
end

% Look for missing data
% delete rows with NaNs or infs, but remember original row number
Infinities = ~isfinite(data);
OriginalRow = 1:size(data,1);
if (any(Infinities(:)))
	% find rows with infinities 
	InfinityRows = find(any(Infinities,2));
	% delete those rows
	data(InfinityRows, :) = [];	
	OriginalRow(InfinityRows) = [];
	if exist('colors'), if length(colors)>1, colors(InfinityRows) = []; end; end;
	if exist('glyphs'), if length(glyphs)>1, glyphs(InfinityRows) = []; end; end;
	if exist('labels'), if length(labels)>1, labels(InfinityRows) = []; end; end;
	disp([num2str(length(InfinityRows)), ' rows containing infinities were deleted.']);
end;

nPoints = size(data,1);

% new colors, in order not to be similar
ColorNames = [
	'Default           ';... % color 1
	'DeepPink          ';... % color 2
	'Yellow            ';... % color 6
	'DeepSkyBlue1      ';... % color 7
	'MediumSpringGreen ';... % color 10
	'MediumOrchid      ';... % color 11
	'YellowGreen       ';... % color 9
	'OrangeRed1        ';... % color 3
	'SlateBlue1        ';... % color 8
	'DarkOrange        ';... % color 4
	'Gold              ';... % color 5
	];
% new colors in regular order
ColorNamesUnsort = [
	'Default           ';... % color 1
	'DeepPink          ';... % color 2
	'OrangeRed1        ';... % color 3
	'DarkOrange        ';... % color 4
	'Gold              ';... % color 5
	'Yellow            ';... % color 6
	'DeepSkyBlue1      ';... % color 7
	'SlateBlue1        ';... % color 8
	'YellowGreen       ';... % color 9
	'MediumSpringGreen ';... % color 10
	'MediumOrchid      ';... % color 11
];


if nargin>=2 & ~isempty(colors);
	% make color file
	
	if (length(colors)==1)
		colors = repmat(colors, nPoints, 1);
	elseif (length(colors) ~= nPoints)
		error('Number of colors should be same as number of points');
	end;
	
%	old colors
% 	ColorNamesOld = [
% 	'Default     ';...
% 	'Red         ';...
% 	'Green       ';...
% 	'SkyBlue     ';...
% 	'Orange      ';...
% 	'Yellow      ';...
% 	'YellowGreen ';...
% 	'HotPink     ';...
% 	'Orchid      ';...
% 	'Peru        ';...
% 	'SlateBlue   '...
% 	];
%	end
	
%	colors = colors(:);
%	ColorIndex = 1+colors-min(colors);
%     [ColName, uCol, ColorIndex] = unique(colors);
% 	% print out color map
% 	for i=1:length(ColName)
%         if isnumeric(ColName(i))
%     		fprintf('Color %d -> %s\n', ColName(i), ColorNames(i,:));
%         else
%     		fprintf('Color %s -> %s\n', ColName(i), ColorNames(i,:));
%         end
% 	end
% 	
% 	strmat = ColorNames(ColorIndex,:);
% 	
% 	fp = fopen([FileBase, '.colors'], 'w');
% 		
% 	fprintf(fp,'%s\n',strmat');
% 	
% 	fclose(fp);
% 
msave([FileBase, '.colors'],colors);

if 0
	%make .resources file
	fp = fopen([FileBase, '.resources'], 'w');
	for i=2:size(ColorNames,1)
		fprintf(fp, '*brushColor%d:%s\n', i, ColorNames(i,:));
	end;
	fclose(fp);
end
	
end;

if nargin >=3 & ~isempty(glyphs)
	% make glyphs file
	if length(glyphs) == 1
		glyphs = repmat(glyphs, nPoints, 1);
	end;
	
	if length(glyphs) ~= nPoints
		error('number of glyphs should be same as number of points or 1');
	end;
	fp = fopen([FileBase, '.glyphs'], 'w');
	fprintf(fp, '%d\n', glyphs);
	fclose(fp);
end;

% row labels
fp = fopen([FileBase, '.row'], 'w');
if (nargin >=4 & ~isempty(labels))
    labmat = strvcat(labels);
   
    labmat = [labmat, repmat(10,size(labmat,1),1)];
    fprintf(fp, '%s', labmat');
else
	fprintf(fp, '%d\n', OriginalRow);
end
fclose(fp);

msave([FileBase, '.dat'], data);

% now run xgobi and clean up any old files...
eval(['! C:/Tools/ggobi/ggobi ' FileBase])

if nargout>=1
    fprintf('MATLAB is waiting for your color selections\n');
    fprintf('Save them, then press return here\n');
    pause
    
    while ~FileExists([FileBase, '.colors'])
        if input('You didnt save the color file! Press 1 to launch another xgobi, return to read color file\n');
            eval(['! ~/bin/xgobi ', FileBase, '&'])
        end
    end
        
    OutColorNames = textread([FileBase, '.colors'], '%s');
    [UniqueNames dummy Index] = unique(OutColorNames);
    
    for i=1:length(UniqueNames)
        Map(i) = strmatch(UniqueNames(i), ColorNamesUnsort);
    end
    
    colorsOut = Map(Index);
end
if nargout>=2
    glyphsOut = load([FileBase, '.glyphs']);
end    
    
    % find out which names correspond to which colors
    
%eval(['! rm ', FileBase, '.*']);
