% ImageMatrix(C, [gamma]) or ImageMatrix(X,Y,C, [gamma])
%
% Takes a 4D array C and displays a matrix of imagesc plots
%
% input arguments are as in imagesc - the only difference is that C is 4D
% the first 2 dimensions of C are X and Y the second 2 are X and Y of the subplots
% (i think).
%
% if C is complex it will call ComplexImage - this is where [gamma] comes in.

function ImageMatrix(varargin)

% sort out input arguments (BORING!) 
if nargin == 1
	AxesSpecified = 0;
	C = varargin{1};
	gamma = 1;
elseif nargin == 2
	AxesSpecified = 0;
	C = varargin{1};
	gamma = varargin{2};
elseif nargin == 3
	AxesSpecified = 1;
	X = varargin{1};
	Y = varargin{2};
	C = varargin{3};
	gamma = 1;
elseif nargin == 4
	AxesSpecified = 1;
	X = varargin{1};
	Y = varargin{2};
	C = varargin{3};
	gamma = varargin{4};
else 
	error('number of arguments needs to be 1 to 4');
end

nPlotsX = size(C,3);
nPlotsY = size(C,4);

% now make the plot matrix
for i=1:nPlotsX
	for j=1:nPlotsY
	
		% select correct subplot
		subplot(nPlotsY, nPlotsX, i + (j-1)*nPlotsX);
		
		% make individual plot
		ThisPlot = squeeze(C(:,:,i,j));
		if AxesSpecified
            if (size(X,1)==1) X=X(:); end
            if (size(Y,1)==1) Y=Y(:); end  
            if (size(X,2)>1 | size(X,3)>1)
                ThisX = squeeze(X(:,i,j));
            else 
                ThisX = X(:);
            end
            if (size(Y,2)>1 | size(Y,3)>1)
                ThisY = squeeze(Y(:,i,j));
            else
                ThisY = Y(:);
            end
            if (isreal(ThisPlot))
                contour(ThisX,ThisY,ThisPlot, gamma);
%                set(gca,'ydir','norm');
			else
                error('cannot contout complex matrix');
%				ComplexImage(ThisX,ThisY,ThisPlot,gamma);
            end
		else
			if (isreal(ThisPlot))
				contour(ThisPlot,gamma);
 %               set(gca,'Ydir','norm')
            else
                error('cannot contout complex matrix');
%				ComplexImage(ThisPlot,gamma);
			end
		end
		%colorbar
	end
end
