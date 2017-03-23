function plotData = MakeBufferedPlotMat(data,chanMat,varargin)
%function plotData = MakeBufferedPlotMat(data,chanMat,varargin)
%[buffFrac,badChans] = DefaultArgs(varargin,{0.1,0});
[buffFrac,badChans] = DefaultArgs(varargin,{[0.1 0.1],0});

buffer = round([buffFrac(1)*size(data,2) buffFrac(2)*size(data,3)]);

plotData = NaN*ones(size(chanMat,1)*(size(data,2)+buffer(1)),...
    size(chanMat,2)*(size(data,3)+buffer(2)));

for j=1:size(chanMat,1)
    for k=1:size(chanMat,2)
        if isempty(find(chanMat(j,k)==badChans))
            plotData((j-1)*(size(data,2)+buffer(1))+round(buffer(1)/2)+1:...
                (j-1)*(size(data,2)+buffer(1))+round(buffer(1)/2)+size(data,2),...
                (k-1)*(size(data,3)+buffer(2))+round(buffer(2)/2)+1:...
                (k-1)*(size(data,3)+buffer(2))+round(buffer(2)/2)+size(data,3))...
                = data(chanMat(j,k),:,:);
        end
    end
end
return
        
