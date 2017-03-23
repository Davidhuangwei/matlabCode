function SortIntoStrct_KamranCompr(xx)

%% 
% each column is a different cell pair.
% each row is:
%
%  1 theta-lag in ms
%  2 distance in cm
%  3 running time in ms
%  4 preferred loc of cell 1
%  5 preferred loc of cell 2
%  6 session directory (gor/one or gor/two)
%  7 session order (1-6 within each directory, corresponding to the dates)
%  8 direction
%  9 shank of cell 1
% 10 cluster # of cell 1
% 11 shank of cell 2
% 12 cluster # of cell 2
% 13 oscillation frequency of the cell-pair CCG in Hertz
% 14 CA region for cell 1 (1 or 3)
% 15 CA region for cell 2 (1 or 3)


gore = unique(xx(6,:));
for g=1:length(gore)  
  L = LoadStringArray(['Kamran_gore' num2str(g) '.txt']);
  for s=1:6
    FileBase = [L{s} '/' L{s}] 
    
    indx = find(xx(6,:)==gore(g) & xx(7,:)==s);
    
    length(indx)
    
    compr.theta = xx(1,indx);
    compr.dist  = xx(2,indx);
    compr.runt  = xx(3,indx);
    compr.pos1  = xx(4,indx);
    compr.pos2 =  xx(5,indx);
    compr.dir  =  xx(8,indx);
    compr.shank1 = xx(9,indx);
    compr.clu1 = xx(10,indx);
    compr.shank2 = xx(11,indx);
    compr.clu2 = xx(12,indx);
    compr.fccg = xx(13,indx);
    compr.region1 = xx(14,indx);
    compr.region2 = xx(15,indx);
        
    
    save([FileBase '.seqcompr'],'compr')
    
  end
end