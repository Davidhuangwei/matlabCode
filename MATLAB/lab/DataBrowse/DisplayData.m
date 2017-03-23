% function DisplayData([Action],[Data])
% auxillary funtion for TimeBrowse, plots the Data in current segment
% Data is in format: DataEntry1, DataEnry2,..
% where each DataEntry={x axis, y axis, z axis, plotFunc, plotLayot}
%
function DisplayData(varargin)
global gBrowsePar;
global gBrowseData
%figure(FigHandle);
Action = 'update';
if isempty(gBrowseData) & nargin>0
    
    % parse the Data input and feed into structure
    gBrowseData.nPlots = nargin;
    for d=1:gBrowsePar.nPlots
        myData=varargin{d};
        if ~isstr(myData{1})
            AdDisplayData(myData);
        else
            % read from the file
            error('not implemented yet');
        end
    end
    % generate layout if not passed
    %gBrowsePar.PlotsFormat = [gBrowseData.nPlots, 1];
    nVert = 0;
    for d=1:gBrowsePar.nPlots
        if d>2 & gBrowseData(d).Layout(2)==1/2
            if gBrowseData(d-1).Layout(2)~=1/2  
                nVert = nVert + gBrowseData(d).Layout(1);
            end
        else
            nVert = nVert + gBrowseData(d).Layout(1);
        end
    end
    lastVert=0;
    
    for d=1:gBrowsePar.nPlots
        if gBrowseData(d).Layout(1)==1
            gBrowseData(d).Layout = [nVert, 1, lastVert+1];
            nHoriz =1;
            lastVert=lastVert+1;
        elseif gBrowseData(d).Layout(1)>2
            if nHoriz==1 
                nHoriz = 1/gBrowseData(d).Layout(2);
                posind = lastVert*nHoriz+[1:gBrowseData(d).Layout(1)*nHoriz];
                matposind=reshape(posind,nHoriz,[])';
                gBrowseData(d).Layout = [nVert, nHoriz, matposind(:,1)'];
                lastcol=1;
            else
                gBrowseData(d).Layout = [nVert, nHoriz, matposind(:,lastcol+1)'];
                lastcol = lastcol + 1;
            end
            if lastcol==nHoriz
                lastVert=lastVert+gBrowseData(d).Layout(1);
            end
        end
    end
end

% display data

switch Action
case
    'update'
    Seg = gBrowsePar.Center+gBrowsePar.Width/2*[-1 1];
    for d=1:gBrowsePar.nPlots
        % select subplot according to Layout
        subplot(gBrowseData(d).Layout(1), gBrowseData(d).Layout(2), gBrowseData(d).Layout(3:end));
        cla
        SegData={};
        xDim = length(gBrowseData(d).Data{1});
        
        % find the segment index from the first arg (assume it is time)
        SegInd = find(gBrowseData(d).Data{1}>=Seg(1) & gBrowseData(d).Data{1}<=Seg(2))
        for ii=1:length(gBrowseData(d).Data)
            % now select subset of the matrix in dimension that matches time ... nontrivial, ah?
            sz = size(gBrowseData(d).Data{ii});
            whatdim = find(sz==xDim)
            s = SegInd;
            if ~isempty(whatdim)
                wstr = [repmat(':,',1,length(sz)-1) ':'];
                wstr(2*whatdim-1)='s';
                datastr = ['gBrowseData(d).Data{ii}(' wstr ')'];  
                SegData{ii} = eval(datastr);
            else
                SegData{ii}= gBrowseData(d).Data{ii};
            end
        end
        % call the display function with selected segment of the data..
        FuncEval(gBrowseData(d).DisplayFunc, SegData);
        
    end
end









