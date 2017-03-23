%   MULT_HIST       Present multiple histograms.
%
%       call:   MULT_HIST(MAT,VEC1,VEC2,TSTR,XSTR1,XSTR2,YSTR).
%       does:       For each column of mat, plot a historam;
%                   use 4 histograms per figure. 
%                   title is as in tstr (only on top hist),
%                   xlabel is as xstr w/ the numbers in vecs,
%                   and ylabel is as ystr.

% directional statistics package
% Dec-2001 ES

function mult_hist(mat,vec1,vec2,tstr,xstr1,xstr2,ystr);

[row,col] = size(mat);

if col~=length(vec1) | col~=length(vec2)
   error('number of columns is inappropriate')
end

plot_num = 0;
for i=1:col
   plot_num = plot_num + 1;
   plot_num = mod(plot_num,4);
   switch plot_num
   case 1
      figure
   case 0
      plot_num = 4;
   end
   subplot(4,1,plot_num), hist(mat(:,i));
   if plot_num==1
      title(tstr)
   end
   xbuf = sprintf('%s %d %s %d', xstr1, vec1(i), xstr2, vec2(i));
   xlabel(xbuf);
   ylabel(ystr);
end