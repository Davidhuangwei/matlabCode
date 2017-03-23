%function subplotfit(index,totnum) or
%function subplotfit(xi, yi,totnum) or
%plots the subplot in the position indicated by the index or xi,yi grid coordinates.
%(1,1) is in left top corner. 
%ns - total number of subplots or if vector [totnumx totnumy]
function hand = subplotfit(varargin)
if nargin==2
    index = varargin{1};
    totnum= varargin{2};
    if length(totnum)==1
        xnum=ceil(totnum/sqrt(totnum));
        ynum=ceil(totnum/xnum);
    else
        xnum=totnum(2); 
        ynum=totnum(1); 
        totnum = prod(totnum);
    end
else
    xi = varargin{2};
    yi = varargin{1};
    if length(varargin{3})==1
        totnum= varargin{3};
    else
        [xnum ynum] = deal(varargin{3}(2), varargin{3}(1));
        totnum= ynum*xnum;
    end
    index = (yi-1)*xnum + xi;
end
if totnum~=3
    hand = subplot(ynum,xnum,index);
else
    hand = subplot(3,1,index);
end