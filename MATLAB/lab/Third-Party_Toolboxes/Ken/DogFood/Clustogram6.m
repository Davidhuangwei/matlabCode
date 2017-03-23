% ClustoGram6(Fet, Clu)
%
% Plots 6 2d clustograms.
% You are advised not to send the whole
% fet and clu files to this.
% Fet should have 4 columns.
% and Clu should be only 1 and 2.

function ClustoGram6(Fet, Clu)

Clu1 = find(Clu==1);
Clu2 = find(Clu==2);


subplot(2,3,1);
hold on;
scatter(Fet(Clu1,1), Fet(Clu1,2), 1, 'b');
scatter(Fet(Clu2,1), Fet(Clu2,2), 1, 'r');
xlabel(1);
ylabel(2);

subplot(2,3,2);
hold on;
scatter(Fet(Clu1,1), Fet(Clu1,3), 1, 'b');
scatter(Fet(Clu2,1), Fet(Clu2,3), 1, 'r');
xlabel(1);
ylabel(3);


subplot(2,3,3);
hold on;
scatter(Fet(Clu1,1), Fet(Clu1,4), 1, 'b');
scatter(Fet(Clu2,1), Fet(Clu2,4), 1, 'r');
xlabel(1);
ylabel(4);

subplot(2,3,4);
hold on;
scatter(Fet(Clu1,2), Fet(Clu1,3), 1, 'b');
scatter(Fet(Clu2,2), Fet(Clu2,3), 1, 'r');
xlabel(2);
ylabel(3);

subplot(2,3,5);
hold on;
scatter(Fet(Clu1,2), Fet(Clu1,4), 1, 'b');
scatter(Fet(Clu2,2), Fet(Clu2,4), 1, 'r');
xlabel(2);
ylabel(4);

subplot(2,3,6);
hold on;
scatter(Fet(Clu1,3), Fet(Clu1,4), 1, 'b');
scatter(Fet(Clu2,3), Fet(Clu2,4), 1, 'r');
xlabel(3);
ylabel(4);