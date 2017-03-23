function XYTitle(titleCell, axesHandles)
% Input: MxN cell array containing titles to be added to the MxN subplots in the
% current figure window

[x, y] = size(titleCell);

for i=1:x
    for j=1:y
        if ~exist('axesHandles') | isempty(axesHandles)
            subplot(x,y,(i-1)*y+j);
            title(titleCell{i,j});
        else
            if axesHandles(i,j)~=0
                axes(axesHandles(i,j));
                title(titleCell{i,j});
            end
        end
    end
end