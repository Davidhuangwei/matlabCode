function ezbode(mag,phase,w,lims);

%   usage ---->  ezbode(mag,phase,w,limits)
%   example: [m,p,w]=bode(num,den); or state space
%   ezbode(m,p,w)
%   optional limits= [xmin,xmax,mag_min,mag_max,phase_min,phase_max]
%
%  origin ver developed by 	David B. Doman,	Wright Lab , Jan 95
%  modified for EZ use  by      R. Cobb, Phillips Lab, Nov 96 
if nargin ~= 1;
	bode_plot=figure(...
                'WindowButtonDownFcn','ezbode(''down'');',...
		'NumberTitle','off',...
		'MenuBar','none',...
		'name','EZ BODE                    RGC, 11/96',...
		'Units','Normalized');
	h(6)=subplot(211); set(h(6),...
		'Units','Normalized',...
		'Position',[.15 .57 .55 .35]);
        if size(w,2) ~=1;w=w';end;
	mag=20*log10(mag);
	semilogx(w,mag);
        temp=axis;
	line([temp(1),temp(2)],[0,0],'Color','b','linestyle','-');
	ylabel('Gain dB');
	h(7)=subplot(212);set(h(7),...
		'Units','Normalized',...
		'Position',[.15 .15 .55 .35]);
	semilogx(w,phase);	
	line([temp(1),temp(2)],[-180,-180],'Color','b','linestyle','-');
	xlabel('Frequency');
	ylabel('Phase (deg)');

%  Control Panel Frame       
	uicontrol('Style','Frame','Units','Normalized',...
			'Position',[.73 .05 .29 .92],...
			'BackGroundColor',[.7 .7 .7]);
	uicontrol('Style','Text','Units','Normalized',...
			'Position',[.74 .91 .25 .05],...
			'BackGroundColor',[.7 .7 .7],...
			'String','Plot Control Panel');
%  Crosshair Text           
	uicontrol('Style','text','Units','Normalized',...
			'Position',[.74 .87 .15 .045],...
			'String','Frequency',...
			'BackGroundColor',[.7 .7 .7]);
	h(9)=uicontrol('Style','edit','Units','Normalized',...
			'Position',[.88 .87 .1 .045],...
			'String',' ',...
			'BackGroundColor',[0 .7 .7]);
	uicontrol('Style','text','Units','Normalized',...
			'Position',[.74 .82 .15 .045],...
			'String','Gain dB',...
			'BackGroundColor',[.7 .7 .7]);
	h(11)=uicontrol('Style','edit','Units','Normalized',...
			'Position',[.88 .82 .1 .045],...
			'String',' ',...
			'BackGroundColor',[0 .7 .7]);
	uicontrol('Style','text','Units','Normalized',...
			'Position',[.74 .77 .15 .045],...
			'String','Phase deg.',...
			'BackGroundColor',[.7 .7 .7]);
	h(13)=uicontrol('Style','edit','Units','Normalized',...
			'Position',[.88 .77 .1 .045],...
			'String',' ',...
			'BackGroundColor',[0 .7 .7]);
%  Grid on/off           
	h(21)=uicontrol('Style','Radio','String','Grid',...
			'Units','Normalized',...
			'BackGroundColor',[.5 .5 .5],...
			'Position',[.74 .7 .1 .05],...
			'Callback','ezbode(''grid'')');
%    lin or log axis   
	h(23)=uicontrol('Style','Push','String','Linear',...
			'Units','Normalized',...
			'BackGroundColor',[1 0 0],...
			'Position',[.86 .7 .1 .05],...
			'Callback','ezbode(''logax'')');

%   Axis Range Selector 
                 
      if nargin == 4 
    	x_rng=lims(1:2);
	y_rng_mag=lims(3:4);
	y_rng_phase=lims(5:6);
      elseif nargin == 3
	x_rng=get(h(6),'Xlim');
	y_rng_mag=get(h(6),'Ylim');
	y_rng_phase=get(h(7),'Ylim');
      end
  	axis_text_top=.62;
	uicontrol('style','Frame','Units','Normalized',...
		'Position',[.735 axis_text_top-.2 .27 .26]);
	uicontrol('Style','text','Units','Normalized',...
		'Position',[.74 axis_text_top .25 .05],...
		'String','Axis Ranges');
	uicontrol('Style','text','Units','Normalized',...
		'Position',[.91 axis_text_top-.05 .05 .05],...
		'String','Hi');	
	uicontrol('Style','text','Units','Normalized',...
		'Position',[.85 axis_text_top-.05 .05 .05],...
		'String','Lo');
	uicontrol('Style','text','Units','Normalized',...
		'Position',[.74 axis_text_top-.10 .09 .05],...
		'String','Freq.');		
	uicontrol('Style','text','Units','Normalized',...
		'Position',[.74 axis_text_top-.15 .09 .05],...
		'String','Mag.');		
	uicontrol('Style','text','Units','Normalized',...
		'Position',[.74 axis_text_top-.2 .09 .05],...
		'String','Phs.');
	h(15)=uicontrol('Style','edit','Units','Normalized',...
		'Position',[.82 axis_text_top-.09 .08 .045],...
		'String',num2str(x_rng(1)),'Backgroundcolor',[.9 .9 .9],...
		'CallBack','ezbode(''freq'')');	
	h(16)=uicontrol('Style','edit','Units','Normalized',...
		'Position',[.91 axis_text_top-.09 .08 .045],...
		'String',num2str(x_rng(2)),'Backgroundcolor',[.9 .9 .9],...
		'CallBack','ezbode(''freq'')');		
	h(17)=uicontrol('Style','edit','Units','Normalized',...
		'Position',[.82 axis_text_top-.14 .08 .045],...
		'String',num2str(y_rng_mag(1)),'Backgroundcolor',[.9 .9 .9],...
		'CallBack','ezbode(''mag'')');		
	h(18)=uicontrol('Style','edit','Units','Normalized',...
		'Position',[.91 axis_text_top-.14 .08 .045],...
		'String',num2str(y_rng_mag(2)),'Backgroundcolor',[.9 .9 .9],...
		'CallBack','ezbode(''mag'')');			
	h(19)=uicontrol('Style','edit','Units','Normalized',...
		'Position',[.82 axis_text_top-.19 .08 .045],...
		'String',num2str(y_rng_phase(1)),'Backgroundcolor',[.9 .9 .9],...
		'CallBack','ezbode(''phase'')');		
	h(20)=uicontrol('Style','edit','Units','Normalized',...
		'Position',[.91 axis_text_top-.19 .08 .045],...
		'String',num2str(y_rng_phase(2)),'Backgroundcolor',[.9 .9 .9],...
		'CallBack','ezbode(''phase'')');	

	h(24)=uicontrol('Style','Text','Units','Normalized',...
				'Position',[.735 .37 .2 .04],...				
				'String','Crosshairs on:',...
				'Visible','off');

	traces=[];
	z(1,:)=['Trace ' num2str(1) '|'];
	for i=2:min(size(mag)),
		s(i,:)=['Trace ' num2str(i) '|'];
		z=[z s(i,:)];
	end
	traces=z;

	h(22)=uicontrol('Style','Popup','Units','Normalized',...
			'Position',[.735 .32 .2 .05],...
			'String',traces,...
			'BackGroundColor','w',...
			'Visible','off');
			
	if min(size(mag))>1,
		set(h(22),'Visible','On');
		set(h(24),'Visible','On');
	end

	subplot(h(6));
		h(2)=line(x_rng,[y_rng_mag(1) y_rng_mag(1)]);
		h(3)=line(x_rng,[y_rng_mag(1) y_rng_mag(1)]);
		set(h(2),'Color','r');set(h(3),'Color','r');
		set(h(2),'EraseMode','xor');set(h(3),'EraseMode','xor');
	subplot(h(7));
		h(4)=line(x_rng,[y_rng_phase(1) y_rng_phase(1)]);
		h(5)=line(x_rng,[y_rng_phase(1) y_rng_phase(1)]);
		set(h(4),'Color','r');set(h(5),'Color','r');
		set(h(4),'EraseMode','xor');set(h(5),'EraseMode','xor');	
	subplot(h(6));
%	x_text=text(x_rng(1),y_rng_mag(2)+.1*(y_rng_mag(2)-y_rng_mag(1)),' ');
%	set(x_text,'FontSize',9,'EraseMode','xor');
	h(14)=uicontrol('Style','Push','Units','Normalized',...
		'Position',[.74 .07 .25 .07],...
		'String','Close',...
		'CallBack','delete(gcf)',...
		'Visible','on');
	set(gcf,'UserData',h);
        set(h(6),'UserData',[mag,phase,w]);
	ezbode('mag');
	ezbode('freq');
        ezbode('phase');

elseif strcmp(mag,'down');
	bode_plot=gcf;
	h=get(bode_plot,'UserData');
        mag=get(h(6),'UserData');
        w=mag(:,size(mag,2));
        phase=mag(:,1+(size(mag,2)-1)/2:size(mag,2)-1);
        mag=mag(:,1:(size(mag,2)-1)/2);
	index=get(h(22),'Value');
	if index ~= 0;
        	mag=mag(:,index);phase=phase(:,index);
	end
	
	set(bode_plot,'WindowButtonMotionFcn','ezbode(''move'');');
	set(bode_plot,'WindowButtonUpFcn','ezbode(''up'');');
	pt=get(h(6),'Currentpoint');
	w_pt=pt(1,1);
	if w_pt>=max(w),
		w_pt=max(w);
		k=max(size(w));
	elseif w_pt<=min(w),
		w_pt=min(w);
		k=2;
	else, 
		k=find(w>w_pt);k=k(1);
	end
	mag_pt=table1([w(k-1) mag(k-1);w(k) mag(k)],w_pt);
	phase_pt=table1([w(k-1) phase(k-1);w(k) phase(k)],w_pt);
	x_rng=get(h(6),'Xlim');
	y_rng_mag=get(h(6),'Ylim');
	y_rng_phase=get(h(7),'Ylim');
	figure(bode_plot);
	subplot(h(6));
		set(h(2),'Xdata',[w_pt w_pt],'Ydata',y_rng_mag);
		set(h(3),'Xdata',x_rng,'Ydata',[mag_pt mag_pt]);
	subplot(h(7));
		set(h(4),'Xdata',[w_pt w_pt],'Ydata',y_rng_phase);
		set(h(5),'Xdata',x_rng,'Ydata',[phase_pt phase_pt]);
	set(h(9),'String',num2str(w_pt,6));
	set(h(11),'String',num2str(mag_pt,6));
	set(h(13),'String',num2str(phase_pt,6));
	
elseif strcmp(mag,'move');
	bode_plot=gcf;
	h=get(bode_plot,'UserData');
	mag=get(h(6),'UserData');
        w=mag(:,size(mag,2));
        phase=mag(:,1+(size(mag,2)-1)/2:size(mag,2)-1);
        mag=mag(:,1:(size(mag,2)-1)/2);
	index=get(h(22),'Value');
	if index ~=0
    		mag=mag(:,index);phase=phase(:,index);
	end
	pt=get(h(6),'Currentpoint');
	w_pt=pt(1,1);
	if w_pt>=max(w),
		w_pt=max(w);
		k=max(size(w));
	elseif w_pt<=min(w),
		w_pt=min(w);
		k=2;
	else, 
		k=find(w>w_pt);k=k(1);
	end
	mag_pt=table1([w(k-1) mag(k-1);w(k) mag(k)],w_pt);
	phase_pt=table1([w(k-1) phase(k-1);w(k) phase(k)],w_pt);
	x_rng=get(h(6),'Xlim');
	y_rng_mag=get(h(6),'Ylim');
	y_rng_phase=get(h(7),'Ylim');
	figure(bode_plot);
	subplot(h(6));
		set(h(2),'Xdata',[w_pt w_pt],'Ydata',y_rng_mag);
		set(h(3),'Xdata',x_rng,'Ydata',[mag_pt mag_pt]);	
	subplot(h(7));
		set(h(4),'Xdata',[w_pt w_pt],'Ydata',y_rng_phase);
		set(h(5),'Xdata',x_rng,'Ydata',[phase_pt phase_pt]);	
	set(h(9),'String',num2str(w_pt,6));
	set(h(11),'String',num2str(mag_pt,6));
	set(h(13),'String',num2str(phase_pt,6));

elseif strcmp(mag,'up');
	bode_plot=gcf;
	h=get(bode_plot,'UserData');
	mag=get(h(6),'UserData');
        w=mag(:,size(mag,2));
        phase=mag(:,1+(size(mag,2)-1)/2:size(mag,2)-1);
        mag=mag(:,1:(size(mag,2)-1)/2);

	index=get(h(22),'Value');
	if index ~= 0;
  		mag=mag(:,index);phase=phase(:,index);
	end
	set(bode_plot,'WindowButtonMotionFcn',' ');
	set(bode_plot,'WindowButtonUpFcn',' ');
	pt=get(h(6),'Currentpoint');
	w_pt=pt(1,1);
	if w_pt>=max(w),
		w_pt=max(w);
		k=max(size(w));
	elseif w_pt<=min(w),
		w_pt=min(w);
		k=2;
	else, 
		k=find(w>w_pt);k=k(1);
	end
	mag_pt=table1([w(k-1) mag(k-1);w(k) mag(k)],w_pt);
	phase_pt=table1([w(k-1) phase(k-1);w(k) phase(k)],w_pt);
	x_rng=get(h(6),'Xlim');
	y_rng_mag=get(h(6),'Ylim');
	y_rng_phase=get(h(7),'Ylim');
	figure(bode_plot);
	subplot(h(6));
		set(h(2),'Xdata',[w_pt w_pt],'Ydata',y_rng_mag);
		set(h(3),'Xdata',x_rng,'Ydata',[mag_pt mag_pt]);
	subplot(h(7));
		set(h(4),'Xdata',[w_pt w_pt],'Ydata',y_rng_phase);
		set(h(5),'Xdata',x_rng,'Ydata',[phase_pt phase_pt]);
	set(h(9),'String',num2str(w_pt,6));
	set(h(11),'String',num2str(mag_pt,6));
	set(h(13),'String',num2str(phase_pt,6));

elseif strcmp(mag,'grid');
	h=get(gcf,'UserData');
        if strcmp(get(h(6),'Xgrid'),'off')
          set(h(6),'Xgrid','on','Ygrid','on');
          set(h(7),'Xgrid','on','Ygrid','on');
 	else
          set(h(6),'Xgrid','off','Ygrid','off');
          set(h(7),'Xgrid','off','Ygrid','off');
	end
elseif strcmp(mag,'logax');
	h=get(gcf,'UserData');
	if strcmp(get(h(6),'Xscale'),'log')
          set(h(6),'Xscale','linear');
          set(h(7),'Xscale','linear');
	  set(h(23),'String','Log');
 	else
          set(h(6),'Xscale','log');
          set(h(7),'Xscale','log');
	  set(h(23),'String','Linear');
	end
elseif strcmp(mag,'freq');
	h=get(gcf,'UserData');
	lo_freq=str2num(get(h(15),'String'));
	hi_freq=str2num(get(h(16),'String'));
	set(h(6),'Xlim',[lo_freq hi_freq]);
	set(h(7),'Xlim',[lo_freq hi_freq]);
elseif strcmp(mag,'phase');
	h=get(gcf,'UserData');
	lo_phase=str2num(get(h(19),'String'));
	hi_phase=str2num(get(h(20),'String'));
	set(h(7),'Ylim',[lo_phase hi_phase]);
elseif strcmp(mag,'mag');
	h=get(gcf,'UserData');
	lo_mag=str2num(get(h(17),'String'));
	hi_mag=str2num(get(h(18),'String'));
	set(h(6),'Ylim',[lo_mag hi_mag]);
end
%eof
