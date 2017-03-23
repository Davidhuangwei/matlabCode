function crsshr2(action);
%         crsshr2
%
%  A gui interface for reading (x,y) values from a plot. 
%
%  Two mouse driven crosshairs are placed on the current axes.
%  Text boxes display delta x, delta y and the slope of the line defined by 
%  the cursors.
%  "Grab" the cursor of choice by clicking near it. 
%  Select done after using to remove the gui stuff,
%  and to restore the mouse buttons to previous values. 
%
%   The essence of this function is derived from
%       the original crsshr.m by Richard G. Cobb 
%
%       David Ferster
%%
global xhr_plot xhr_xdata xhr_ydata xhr_plot_data xhr_button_data 
if nargin == 0
        xhr_plot=gcf;
        xhrx_axis=gca;
        xhr_xdata=[];
        xhr_ydata=[];
        sibs=get(xhrx_axis,'Children');
        found=0;
        for i=1:size(sibs)
         if strcmp(get(sibs(i),'Type'),'line')
           if max(size(get(sibs(i),'Xdata'))) > max(size(xhr_xdata))
             found=1;
             xhr_xdata=[];
             xhr_ydata=[];
             xhr_xdata(:,found)=get(sibs(i),'Xdata').'; 
             xhr_ydata(:,found)=get(sibs(i),'Ydata').';
           elseif max(size(get(sibs(i),'Xdata'))) == max(size(xhr_xdata))
             found=found+1;
             xhr_xdata(:,found)=get(sibs(i),'Xdata').'; 
             xhr_ydata(:,found)=get(sibs(i),'Ydata').';
           end
         end
        end
        xhr_button_data=get(xhr_plot,'WindowButtonDownFcn'); 
        set(xhr_plot,'WindowButtonDownFcn','crsshr2(''down'');'); 
        x_rng=get(xhrx_axis,'Xlim');
                ypos = .8;
        xaxis_text=uicontrol('Style','edit','Units','Normalized',...
                'Position',[.9 ypos .1 .045],...
                'String','X',...
                'BackGroundColor','r');
        x_num=uicontrol('Style','edit','Units','Normalized',...
                'Position',[.9 ypos-.045 .1 .045],... 
                'String',' ',...
                'BackGroundColor',[0 .7 .7]);
                y_text=uicontrol('Style','edit','Units','Normalized',... 
                'Position',[.9 ypos-.045*2 .1 .045],...
                'String','Y',...
                'BackGroundColor','r');
                y_num=uicontrol('Style','edit','Units','Normalized',... 
                'Position',[.9 ypos-.045*3 .1 .045],...
                'String',' ',...
                'BackGroundColor',[0 .7 .7]);
        s_text=uicontrol('Style','edit','Units','Normalized',...
                'Position',[.9 ypos-.045*4 .1 .045],... 
                'String','RMS',...
                'BackGroundColor','r');
        s_num=uicontrol('Style','edit','Units','Normalized',...
                'Position',[.9 ypos-.045*5 .1 .045],... 
                'String',' ',...
                'BackGroundColor',[0 .7 .7]);
        closer=uicontrol('Style','Push','Units','Normalized',...
                'Position',[.92 0 .08 .04],...
                'String','Done',...
                'CallBack','crsshr2(''close'')',... 
                'Visible','on');
                hold on;
        xhr_xdata_col=xhr_xdata(:,1);
        xhr_ydata_col=xhr_ydata(:,1);
                xdata_pt = (2*x_rng(1)+x_rng(2))/3;
                k=find(xhr_xdata_col>xdata_pt);k=k(1); 
                ydata_pt=table1([xhr_xdata_col(k-1) xhr_ydata_col(k-1);...
                        xhr_xdata_col(k) xhr_ydata_col(k)],xdata_pt);
                cursor_data(1)=plot(xdata_pt,ydata_pt,'+','markersize',12,...
        'color','g','LineWidth',2,'EraseMode','xor');
                xdata_pt = (2*x_rng(2)+x_rng(1))/3;
                k=find(xhr_xdata_col>xdata_pt);k=k(1); 
                ydata_pt=table1([xhr_xdata_col(k-1) xhr_ydata_col(k-1);...
                        xhr_xdata_col(k) xhr_ydata_col(k)],xdata_pt);
                cursor_data(2)=plot(xdata_pt,ydata_pt,'+','markersize',12,... 
        'color','r','LineWidth',2,'EraseMode','xor');
                hold off;
        xhr_plot_data=[cursor_data s_text s_num  ...
                           xhrx_axis   xaxis_text x_num...
                       y_text y_num  1 ...
                       closer ];
elseif strcmp(action,'down') | strcmp(action,'up') | strcmp(action,'move');
        cursor_data = xhr_plot_data(1:2);
                s_num = xhr_plot_data(4);
        xhrx_axis = xhr_plot_data(5);
        x_num = xhr_plot_data(7);
        y_num = xhr_plot_data(9);
        mouse_pt = get(xhrx_axis,'Currentpoint'); 
        mouse_x = mouse_pt(1,1);
                if strcmp(action,'down')
set(xhr_plot,'WindowButtonMotionFcn','crsshr2(''move'');');
                set(xhr_plot,'WindowButtonUpFcn','crsshr2(''up'');');
                        d1=abs(mouse_x - get(xhr_plot_data(1),'Xdata')); 
                        d2=abs(mouse_x - get(xhr_plot_data(2),'Xdata')); 
                        xhr_plot_data(10) = 1 + (d1 > d2);    %index (which cursor?)
                        end
                if strcmp(action,'up')
                    set(xhr_plot,'WindowButtonMotionFcn',' ');
                set(xhr_plot,'WindowButtonUpFcn',' ');
                        end
                index=xhr_plot_data(10);
        %must stay down here in case 'down' changes it 
        xhr_xdata_col = xhr_xdata(:,1);
        xhr_ydata_col = xhr_ydata(:,1);
         if mouse_x>=max(xhr_xdata_col),
                mouse_x=max(xhr_xdata_col);
                k=max(size(xhr_xdata_col));
        elseif mouse_x<=min(xhr_xdata_col),
                mouse_x=min(xhr_xdata_col);
                k=2;
        else,
                k=find(xhr_xdata_col>mouse_x);k=k(1);
        end
        ydata_pt=table1([xhr_xdata_col(k-1) xhr_ydata_col(k-1);...
                 xhr_xdata_col(k) xhr_ydata_col(k)],mouse_x);
        set(cursor_data(index),'Xdata',mouse_x,'Ydata',ydata_pt);
                dx = get(cursor_data(1),'Xdata')
                dx2= get(cursor_data(2),'Xdata');
        %convert to ms
                dy = get(cursor_data(1),'Ydata')
                dy2= get(cursor_data(2),'Ydata');
                set(x_num,'String',num2str(dx(1),3));
        	set(y_num,'String',num2str(dy(1),3));
                indx=find(xhr_xdata > dx(1) & xhr_xdata < dx(2));
                rms =xhr_ydata(indx);
                rms=sqrt(mean(rms'*rms);
                set(s_num,'String',num2str(rms,3));
elseif strcmp(action,'close')
        index=xhr_plot_data(10);
        handles=xhr_plot_data;
        cursor_data=[handles(1) handles(2)];
                s_text=handles(3);
                s_num=handles(4);
        xhrx_axis=handles(5);
        xaxis_text=handles(6);
        x_num=handles(7);
        y_text=handles(8);
        y_num=handles(9);
        closer=handles(11);
        delete(xaxis_text);
        delete(cursor_data);
        delete(x_num);
        delete(y_text);
        delete(y_num);
        delete(closer);
                delete(s_text);
                delete(s_num);
        set(xhr_plot,'WindowButtonUpFcn',''); 
        set(xhr_plot,'WindowButtonMotionFcn',''); 
        set(xhr_plot,'WindowButtonDownFcn',xhr_button_data); 
        refresh(xhr_plot)
        clear xhr_plot xhr_xdata xhr_ydata xhr_plot_data xhr_button_data
                Zoom on
end
