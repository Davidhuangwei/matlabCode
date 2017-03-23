% Perceptron(Data, Class, w0, lr, anneal)
%
% Demo Perceptron program for classification of vectors
% Data is an nxm matrix.  Class is a nx1 matrix of -1 or 1
% w0 is a mx1 matrix - initial weight
%
% m is usually 3 with the third coordinate a bias
%
% lr is the learning rate - defaults to 0.1

function w = Perceptron(Data, Class, w0, lr, anneal)

w0 = w0(:);

if (nargin<4) lr = 0.1; end;
if (nargin<5) anneal = 0.9; end;

% plot the points and initial line
PlotStuff(Data, Class, w0);

% now the main loop ....

w = w0;

while(1)
	Guess = sign(Data*w); 				% classification so far
	Wrong = find(Guess~=Class);
	if (isempty(Wrong)) break; end;
	dw =lr*Data(Wrong,:)'*Class(Wrong);
	pause
	w = w + dw;
	fprintf('number wrong %d\n', prod(size(Wrong)));
	PlotStuff(Data, Class, w);
	lr = lr*anneal;
end;

function PlotStuff(Data, Class, w)
% plot the points and line
cla
axis auto
scatter(Data(:,1), Data(:,2), 10, Class);
hold on
axis manual
PlotLine(w(1:2), w(3));