function trial = GetTrialsWheel(FileBase,whl,varargin)
[overwrite,check] = DefaultArgs(varargin,{0,0});


%% use the wheel speed to determine the beginning and end of trial


if ~FileExists([FileBase '.trials']) | overwrite
  
  xwhl = [1:length(whl.extra)]/whl.rate;
  swhl = whl.extra;
  
  
  plot(xwhl,swhl);
  
  %% find the points where the whl stands still:
  
  dwhl = diff(swhl);
  
  zdwhl = dwhl==0;
  out = [zdwhl;zdwhl(end)] + [zdwhl(1);zdwhl];
  azdwhl = dwhl~=0;
  aout = [azdwhl;azdwhl(end)] + [azdwhl(1);azdwhl];
  
  edge = [1;find(out.*aout);length(xwhl)];
  
  tt=1;
  count = 0;
  mark = [];
  stopit=0;
  while tt
    
    clf
    step = 2000;
    intv = [1:step]+(tt-1)*1000;
    if max(intv)>length(xwhl)
      intv = [1+(tt-1)*1000:length(xwhl)];
      stopit = 1;
    end
    
    plotedge = edge(find(edge>=min(intv) & edge<=max(intv)));
    
    figure(123);clf
    subplot(211)
    plot(xwhl(intv),whl.itv(intv,1))
    hold on
    plot(xwhl(intv),whl.itv(intv,2),'r')

    subplot(212)
    title('n=next; p=previous; left-mouse=new line; right-mouse=delete; midmouse=end')
    plot(xwhl(intv),swhl(intv),'.-'); 
    hold on; 
    plot(xwhl(plotedge),swhl(plotedge),'ro');
    
    plotlines = mark(find(mark>=min(intv) & mark<=max(intv)));
    Lines(xwhl(plotlines));
    
    %keyboard
    [bx,by,button,key] = PointInput(1);
    switch button
     case 0             % key press
      if key == 'n'     % n=next
	if stopit
	  continue;
	else
	  tt=tt+1;
	end
      elseif key == 'p' %p=previous
	tt=tt-1;
      else
	fprintf('keys: n=next; p=previous || mouse: left=mark; right=delete; middle=break\n');
      end
     case 1           % left mouse = new line  
      [dummy ind] = sort(abs(edge-bx*whl.rate));
      count = count+1;
      mark(count) = edge(ind(1));
     case 3           % right mouse = delete line
      count = count-1;
     case 2           % middle mouse = break 
      if mod(count,2)
	fprintf('there is a missmatch of beginnings and ends...\n');
	tt=1;
	count = 0;
	mark = [];
      stopit=0;
      else
	break
      end
    end
  end
  
  trials = reshape(mark,2,length(mark)/2)';
  trial.itv = trials;

  %% trial.dir
  jumps = find(abs(diff(whl.extra))>2900);
  newextra=whl.extra;
  for n=1:length(jumps)
    newextra(jumps(n)+1:end) = newextra(jumps(n)+1:end)-3000*sign(diff(newextra(jumps(n):jumps(n)+1)));
  end
  trial.dir=sign(newextra(trial.itv(:,2))-newextra(trial.itv(:,1)))/2+2.5;
  
  save([FileBase '.trials'],'trial');
else
  load([FileBase '.trials'],'-MAT');
end

%clf
%plot(whl.extra); 
%hold on;
%Lines(trial.itv(:,1),[],'g');
%hold on;
%Lines(trial.itv(:,2),[],'r');


if check
  for n=1:size(trial.itv,1)
    figure(222);clf
    a=trial.itv(n,1);
    b=trial.itv(n,2);
    plot(whl.itv(:,1),whl.itv(:,2),'o','markersize',10,'markerfacecolor',[1 1 1]*0.7,'markeredgecolor',[1 1 1]*0.7)
    hold on
    plot(whl.itv(a:b,1),whl.itv(a:b,2),'.')
    plot(whl.itv(a,1),whl.itv(a,2),'o','markersize',10,'markerfacecolor',[1 0 0],'markeredgecolor',[1 0 0])
    plot(whl.itv(b,1),whl.itv(b,2),'o','markersize',10,'markerfacecolor',[0 1 0],'markeredgecolor',[0 1 0])
    waitforbuttonpress
  end
end

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

