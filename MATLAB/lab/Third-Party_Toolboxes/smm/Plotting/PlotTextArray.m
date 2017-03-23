function PlotTextArray(textCell,varargin)
textProperties = DefaultArgs(varargin,{{'color','w','HorizontalAlignment','center'}});

%  holdStatus = get(figHandle,'NextPlot');
%  if ~iscell(textCell)
%      textCell = num2cell(textCell);
%  end
%  
for m=1:size(textCell,2)
    for k=1:size(textCell,1)
        text(m,k,textCell(k,m),textProperties{:});
    end
end
