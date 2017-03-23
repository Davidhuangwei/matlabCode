function Xzoom(varargin)
%% zooms in and out of plots
%% left/middle/right mouse : zoom in/break/zoom out
%% 
%% optional input: 
%%  'x'  (default) only zoom x axis
%%  'y'  only zoom y axis
%%  'xy' zoom x and y
%%
[mode] = DefaultArgs(varargin,{'x'});

fprintf('\n left mouse:   zoom in \n');
fprintf(' right mouse:  zoom out \n');
fprintf(' middle mouse: break \n');

switch mode
 case 'x'
  f = [1 0];
 case 'y'
  f = [0 1];
 case 'xy'
  f = [1 1];
end

ox = get(gca,'xlim');
oy = get(gca,'ylim');

s = [-1 1]; %% axis symmetry

while 1
  [dumx dumy button]=PointInput(1);
  switch button(1)
   case 1 % left button
    x = get(gca,'xlim');
    y = get(gca,'ylim');

    nx = (dumx + s * diff(x)/2 * 0.5) * f(1)  +  ox * ~f(1);
    ny = (dumy + s * diff(y)/2 * 0.5) * f(2)  +  oy * ~f(2);
    
    ch = get(gcf,'Children');
    for n=1:length(ch)
      set(gcf,'CurrentAxes', ch(n));
      xlim(nx);
      ylim(ny);
    end
    
   
   case 2 % middle button
    break;
   
   
   case 3 % right button
    x = get(gca,'xlim');
    y = get(gca,'ylim');

    nx = (dumx + s * diff(x)/2 * 2) * f(1)  +  ox * ~f(1);
    ny = (dumy + s * diff(y)/2 * 2) * f(2)  +  oy * ~f(2);
       
    ch = get(gcf,'Children');
    for n=1:length(ch)
      set(gcf,'CurrentAxes', ch(n));
      xlim(nx);
      ylim(ny);
    end

  end
end

return;
  


figure
m = 3;
for n=1:m
  subplotfit(n,m);
  plot(rand(1,100));
end

