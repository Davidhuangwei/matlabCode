% QPerceptron(Data, Class, lr, Beta, anneal)
%
% Quadratic Perceptron program for classification of vectors
% Data is an nx2 matrix.  Class is a nx1 matrix of -1 or 1
%
% lr is the learning rate - defaults to 0.01
% anneal is the annealing factor - which
% multiplies the learning rate each step - default 0.9;

function w = Perceptron(Data, Class, lr, Beta, anneal)

if (nargin<4) lr = 0.01; end;
if (nargin<5) anneal = 0.9; end;

% set up axes
xmin = min(Data(:,1));
xmax = max(Data(:,1));
ymin = min(Data(:,2));
ymax = max(Data(:,2));
axis([xmin xmax ymin ymax]);

%Make the quadratic data matrix
% it goes [x^2 xy y^2 x y 1]
nPoints = size(Data,1);
QData = zeros(nPoints, 6);
QData(:,1) = Data(:,1).^2;
QData(:,2) = Data(:,1).*Data(:,2);
QData(:,3) = Data(:,2).^2;
QData(:,4:5) = Data;
QData(:,6) = ones(nPoints,1);

%initial weights will be given by covariance matrix
w = zeros(6,1);
wOld = w;
dwOld = zeros(6,1);
PartialOld = zeros(6,1);

while(1)
	for i=1:200
		Output = tanh(Beta*QData*w);
		Partial = -Beta*QData'*((Class-Output).*(1-Output.^2));
		dw = Partial./(PartialOld-Partial).*dwOld;
		dwOld = dw;
		PartialOld = Partial;
		%pause
		%drawnow
		w = w + dw;
	end;
	w'
	subplot(2,1,1)
	PlotStuff(Data, Class, w);
	subplot(2,1,2)
	
	Guess = sign(Output); 				% classification so far
	Wrong = find(Guess~=Class);
		
	FalsePos = find(Guess==1 & Class==-1);
	nFalsePos = prod(size(FalsePos));
	FalseNeg = find(Guess==-1 & Class==1);
	nFalseNeg = prod(size(FalseNeg));
	nTruePos = sum(Class==1);
	nFound = sum(Guess==1);
	fprintf('False negatives %d error %f percent\n', nFalseNeg, 100*nFalseNeg/nTruePos);
	fprintf('False Positives %d error %f percent\n', nFalsePos, 100*nFalsePos/nFound);

	PlotStuff(Data, Guess, w);	
	
	fprintf('dw = '); disp ((w-wOld)');
	wOld = w;
	
	lr = lr*anneal;
	pause
end;

function PlotStuff(Data, Class, w)
% plot the points and line
cla
scatter(Data(:,1), Data(:,2), 10, Class);
hold on

% make matrix and vector for PlotConic
M = [w(1) w(2)/2 ; w(2)/2 w(3)];
v = w(4:5);
c = w(6);
PlotConic(M,v,c, 'r', 1000);