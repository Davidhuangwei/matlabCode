% [H, XBins, YBins] = HistMatrix(Y, nBins, Axis, Labels, Norm)
% Takes an array Y and computes  or makes a plot of histograms
% if Y is a 4d, then histograms are computed for each column of the 2nd dimension
% Norm normalizes the histogram, if Norm>0 it tells along which dimension
% (remember, 1st -is bins of the values in Y, 2nd dimension - Axis)
function [H, XBins, YBins] = HistMatrix(Y, nBins, Axis, Labels, Norm)

if nargin<5
    Norm =0;
end
if (ndims(Y) == 4)
	nPlotsX = size(Y,3);
	nPlotsY = size(Y,4);
elseif (ndims(Y) == 3)
	nPlotsX = size(Y,2);
	nPlotsY = size(Y,3);
elseif (ndims(Y) == 2)
    Y = permute(shiftdim(Y,-1),[2 3 1]);
  	nPlotsX = size(Y,2);
	nPlotsY = size(Y,3);

else
	error('Input Y must have 2 to 4 dimensions');
end


% now make the plot matrix
for i=1:nPlotsX
	for j=1:nPlotsY
		% select correct subplot
		subplot(nPlotsY, nPlotsX, i + (j-1)*nPlotsX);
        
        if ndims(Y)<4
            thisGraph = Y(:,i,j);
    		[thishist, bins] = hist(thisGraph,nBins);
            if Norm>0
                thishit = thishist./sum(thishist);
            end
            if nargout<1
                bar(bins, thishist);
        		axis tight
            else
                H(:,i,j) = thishist;
                XBins(:,i,j) = bins;
            end
                
        else
            thisGraph = sq(Y(:,:,i,j));
            [thishist, bins] = hist(thisGraph,nBins);
            [nx,ny] = size(thishist);
            if Norm==1
                thishist = thishist ./ (repmat(mean(thishist,1),nx,1)+eps);
            elseif Norm==2
                thishist = thishist ./ (repmat(mean(thishist,2),1,ny)+eps);
            end
            if nargout<1
                imagesc(Axis,bins,thishist);
                axis xy
            else
                H(:,:,i,j) = thishist;
                XBins(:,i,j) = Axis;
                YBins(:,i,j) = bins;
            end
            
        end
        if nargin>3 
            xlabel(Labels{i,j});
        end
	end
end
