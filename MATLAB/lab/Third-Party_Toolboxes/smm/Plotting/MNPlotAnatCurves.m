function MNPlotAnatCurves(anatCurvesFiles, axesHandles, multiplier, offset,curvesColor, lineWidth)
% Input: MxN Cell array with filenames for AnatCurves files to be overlain on
%   the MxN subplots in the current figure window
% axesHandles offers a method to bypass subplot, which fails after a colorbar
%   is added

if ~exist('curvesColor','var') | isempty(curvesColor)
    curvesColor = [];
end
if ~exist('lineWidth','var') | isempty(lineWidth)
    lineWidth = [];
end
if ~exist('multiplier','var') | isempty(multiplier)
    multiplier = [];
end
if ~exist('offset','var') | isempty(offset)
    offset = [];
end

if ~exist('anatCurvesFiles') | isempty(anatCurvesFiles)
    fprintf('No Anat Curves File specified');
else
    [m, n] = size(anatCurvesFiles);
    for i=1:m
        for j=1:n
            if ~exist('axesHandles') | isempty(axesHandles)
                subplot(m,n,(i-1)*n+j);
            else
                axes(axesHandles{i,j});
            end
            PlotAnatCurves(anatCurvesFiles{i,j}, multiplier, offset, curvesColor, lineWidth);
        end
    end
end

