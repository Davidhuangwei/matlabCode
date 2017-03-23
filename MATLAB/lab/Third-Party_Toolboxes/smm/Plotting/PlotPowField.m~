function PlotPowField(powMap,occupancyMap,colorLimits)

plot_low_thresh = 0.1;

norm_smooth_pos_sum = occupancyMap/sum(sum(occupancyMap));
norm_plot_low_thresh = plot_low_thresh/sum(sum(occupancyMap));
[below_thresh_indexes] = find(norm_smooth_pos_sum<=norm_plot_low_thresh);
%[above_thresh_x above_thresh_y] = find(norm_smooth_pos_sum>norm_plot_low_thresh);
smooth_pos_sum_nan = occupancyMap;
smooth_pos_sum_nan(below_thresh_indexes)= NaN;

imagesc(powMap./smooth_pos_sum_nan);
if exist('colorLimits','var')
    set(gca,'clim',colorLimits)
    colorbar
end
