% ColorScatter(Data, Colors, Size, ColorOrder, Shape)
%
% draws a 2d scatter plot of the data with colors allocated according to the vector Colors
% in size Size (default value 5)
%
% ColorOrder is an optional vector specifying what the colors are
% which overrides the default
%
% Shape is a character (eg '.') giving the shape, as passed to plot
% if it is an array of the length of the data, different points
% are plotted with different glyphs.  Alternatively you can give
% numbers between 1 and 12 and it will assign shapes to the numbers 
%
% optional output h returns a vector of handles for the colors, sorted in the
% order of unique([Colors Shapes]);

function h = ColorScatter(Data, Colors, Size, ColorOrder, Shapes)

if (nargin<3) Size = 5; end;

if (nargin<4) | isempty(ColorOrder)
    %ColorOrder = get(gca, 'ColorOrder'); 
    ColorOrder = rand(size(Data,2),max(Colors));
end;

if nargin<5 Shapes = 'o'; end;

if length(Shapes)==1
    Shapes = repmat(Shapes, size(Data,1), 1);
end
if isnumeric(Shapes)
    GlyphStr = 'os^x+*v<d>ph';
    Shapes = GlyphStr(Shapes);
end

if length(Colors)==1
    Colors = repmat(Colors, size(Data,1), 1);
end

% Make point identifyer of color and shape
ID = [Colors(:), Shapes(:)];
% find unique IDs
[dummy Exemplar Class] = unique(ID, 'rows');

if (size(ColorOrder,1)==1) ColorOrder=ColorOrder(:); end;

ih = ishold;
h = [];
for c=1:max(Class)
	Pts = find(Class==c);

    Col = ColorOrder(Colors(Exemplar(c)),:);
    Marker = Shapes(Exemplar(c));
	
	hh = plot3(Data(Pts,1), Data(Pts,2),Data(Pts,3), Marker, 'MarkerSize', Size, ...
		'MarkerEdgeColor', Col, 'MarkerFaceColor', Col, 'Color', Col);
	h = [h ; hh];
	hold on
end;

%legend(num2str((MinColor:MaxColor)'));
	
if (ih==0) hold off; end;
