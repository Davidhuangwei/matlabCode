function XYTitle(titleCell, axesHandles)
% Input: MxN cell array containing titles to be added to the MxN subplots in the
% current figure window

[x, y] = size(titleCell);

for i=1:x
    for j=1:y
        if ~exist('axesHandles') | isempty(axesHandles)
            subplot(x,y,(i-1)*y+j);
        else
            axes(axesHandles{i,j});
        end
        title(titleCell{i,j});
    end
end
