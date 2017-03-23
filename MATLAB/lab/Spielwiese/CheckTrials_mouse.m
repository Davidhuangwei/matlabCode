function CheckTrials_mouse()

global gExamSegs

whatbutton = get(gcf,'SelectionType');
mousecoord = get(gca,'CurrentPoint');
mousecoord  = mousecoord(1,1:2);
%whatbutton
switch whatbutton
  
 case 'normal'  % left 
  mat = gExamSegs.Fet(:,gExamSegs.curDim);
  if length(gExamSegs.curDim)>1
    dist = sum((mat - repmat(mousecoord(:)',size(mat,1),1)).^2,2);
    
  else	   
    dist = (mat - repmat(mousecoord(1),size(mat,1),1)).^2;
    mousecoord = mousecoord(1);
  end
  [sorted,index] = sort(dist);
  gExamSegs.curSegs = index(2:(1+gExamSegs.nNeighb));
	   
  gExamSegs.curPointer = mousecoord;
  gExamSegs.curSeg = 1;
  gExamSegs.chgPlot = 2;

 case 'extend'  % middle - change dimensions to display
  if length(gExamSegs.curDim) > 1
    axh = get(gExamSegs.figh,'Children');
    ax = axis(axh(1));
    dist2axes =  [(mousecoord(1)-ax(1))/(ax(2)-ax(1)), (mousecoord(2)-ax(3))/(ax(4)-ax(3))];
    % choose to which axes the pointer is closer - which axes to change dimension on
    [dummy whichdim] = max(dist2axes);
    gExamSegs.curDim(whichdim) =  mod(gExamSegs.curDim(whichdim),gExamSegs.nDims)+1;
  else
    gExamSegs.curDim =  mod(gExamSegs.curDim,gExamSegs.nDims)+1;
  end
  
  gExamSegs.chgPlot = 1;
  
 case 'alt'      % right - get next segment
  gExamSegs.curSeg = mod(gExamSegs.curSeg,gExamSegs.nNeighb)+1;
  gExamSegs.chgPlot = 2;
  
 case 'open'     %double click 
  
end

ExamSegs('update');







