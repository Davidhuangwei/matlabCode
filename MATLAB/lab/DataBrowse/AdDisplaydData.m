function  AdDisplaydData(myData,dNumber)   
global gBrowseData
global gBrowsePar
MAXDATAFORPLOT=32;
% data contain args, plotfunc, layout
nargs = 0;
argsend=0;
for ii=1:length(myData)
    % parse myData 
    if isnumeric(myData{ii}) 
        if ~argsend
            nargs=nargs+1;
        else
            gBrowseData(dNumber).Layout = myData{ii};
        end
    elseif isstr(myData{ii})
        gBrowseData(dNumber).DisplayFunc = myData{ii};
        argsend=1;
    else
        error('wrong data enry # %d format', dNumber);
    end
end
gBrowseData(dNumber).Data = myData(1:nargs);
if length(myData) <= nargs+1
    gBrowseData(dNumber).Layout = [1 1];
end
% if no function specified make it automatically???
if length(myData) == nargs
    gBrowseData(dNumber).DisplayFunc = 'plot';
    % add automatic selection of function here......
%     xdim = find(
%     if nargs==2 & ndims(myData{2})==2 & max(size(myData{2}))==1
%     if nargs==2 & ndims(myData{2})==2 & max(size(myData{2}))<MAXDATAFORPLOT
%         gBrowseData(dNumber).DisplayFunc ='PlotManyCh';
end
    





    