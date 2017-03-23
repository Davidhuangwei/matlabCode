%
% Example of the use of Nonlinear factor analysis Matlab package
%

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.


% Generate the data for the helix
generate_helix

% Visualize it
plot3(data(1,:), data(2,:), data(3,:), '.')
axis image
drawnow

% Set the number of hidden neurons to use
hidneurons = 15;

% Set the number of sources to look for
searchsources = 1;

% Do the initializations
nlfa_init

% Set the number of iterations
status.iters = 7500;

% Iterate (this may take a *LONG* time)
nlfa_iter

% The results are returned in structures sources and net
% From these we can calculate the reconstructions of the data
x = feedfw(sources, net);

% Which can then be plotted to the same picture
hold on;
y = x{4}.e;
plot3(y(1,:), y(2,:), y(3,:), 'r.')
