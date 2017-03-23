%   PLOT_UNIFORMITY_PDFS

function plot_uniformity_pdfs(S);

[row col] = size(S);

for i=2:row
    figure
    hist(S(i,:),100)
    tbuf = sprintf('%g observations, %g repetitions',i,col)
    title(tbuf)
end