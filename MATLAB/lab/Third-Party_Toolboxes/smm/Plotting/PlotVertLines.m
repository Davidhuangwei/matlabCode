% function PlotVertLines(x, yVals, varargin)
% plot([x x]',repmat(yValues, [length(x) 1])',varargin)

function PlotVertLines(x, yVals, varargin)

plot([x x]',repmat(yVals, [length(x) 1])',varargin{:})