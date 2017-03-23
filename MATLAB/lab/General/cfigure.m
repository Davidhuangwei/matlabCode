function hout=cfigure(h);
%h=DefaultArgs(varargin,{1});
%keyboard
if exist('h') %isempty(h) 
	if isnumeric(h)==1
		if nargout>0
		hout = figure(h);
		else
		figure(h);
		end
		cfigure('caro');
		set(gcf,'WindowButtonDownFcn','cfigure(''flower'')');  
		set(gcf,'WindowButtonUpFcn','cfigure(''caro'')');  
	elseif isstr(h)==1
	
		switch h
	
		case 'caro'
			map = load('/u12/antsiro/matlab/General/caro.map');
			set(gcf,'Pointer','custom');
			set(gcf,'PointerShapeCData',map);
		case  'flower'
			map = load('/u12/antsiro/matlab/General/flower.map');
			set(gcf,'Pointer','custom');
			set(gcf,'PointerShapeCData',map);
		end
	end
else
	if nargout>0
	hout=figure;
	else
	figure;
	end
	cfigure('caro');
	set(gcf,'WindowButtonDownFcn','cfigure(''flower'')');  
	set(gcf,'WindowButtonUpFcn','cfigure(''caro'')');  
end