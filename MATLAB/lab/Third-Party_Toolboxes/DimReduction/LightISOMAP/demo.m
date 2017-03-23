% This script implements a demonstration of the fast-isomap
% presented at ESANN 2002 by J.J. Verbeek
%
%
%
%@InProceedings{Verbeek02esann,
%  author = 	 {J.J. Verbeek and N. Vlassis and B. Kr\"ose},
%  title = 	 {Fast nonlinear dimensionality reduction using topology preserving  networks},
%  booktitle = 	 {Proc. of European Symposium on Artificial Neural Networks},
%  pages = 	 {193-198},
%  year = 	 {2002},
%  editor = 	 {M. Verleysen},
%  publisher = {D-side, Evere, Belgium}
%}


load small

% you should have the data in the matrix X
% in every ROW one data item is stored


figure(1);figure(2)
set(1,'Double','on');
set(2,'Double','on');



llrec2;   % All the work is here



beta = [];
butt = 1;

colormap([0:1/255:1]'*ones(1,3))

pict2   % visual inspection of the images








