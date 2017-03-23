%function PlotManyCh(x,t,sr,scale,color,norm,AxesIncr)
% x is a matrix of signals to plot (dims order doesn't matter)
% t is time axis, sr - sampling, scale - coefficient to scale up the signals
% color - to use, norm - if you want ot normolize them all evenly
% AxesIncr - incriment of the axes to plot in higher axes than current
% e.g. when you have more channels than CSD 
function PlotManyCh(x,varargin)
method=2;
x=squeeze(x);
nChannels = min(size(x));
nTime = max(size(x));
if (size(x,1)~=nTime)
    x=x';
end
[ t,sr,scale,color,norm,AxesIncr] = DefaultArgs(varargin, { [1:nTime], 1250,  1, 'k', 0, 0});
t= t/sr;

curAxes = get(gca,'Position');
%[left bottom width height]

if AxesIncr~=0
    if length(AxesIncr)==1
        curAxes = [curAxes(1) curAxes(2)-0.5*AxesIncr*curAxes(4) curAxes(3) curAxes(4)*(1+AxesIncr)];
    else
        curAxes = [curAxes(1) curAxes(2)-AxesIncr(1)*curAxes(4) curAxes(3) curAxes(4)*AxesIncr(2)];
    end
        
end

ChAmp = range(x);
MaxChAmp = max(ChAmp);
MinChAmp = min(ChAmp);
MeanChAmp = mean(ChAmp);
ChScale = ChAmp/MaxChAmp;
totRange = sum(ChAmp);
if (nChannels>1)
    if norm==1
		for i=1:nChannels
			dw = curAxes(4)*scale/nChannels;
			bot_offset = curAxes(4)*(scale-1)/(nChannels-1);
			Aleft = curAxes(1);
			Abottom = curAxes(2)+(i-1)*(dw-bot_offset);
			Awidth = curAxes(3);
			Aheight = dw;
			h(i)=axes('Position',[Aleft Abottom Awidth Aheight]);
			plot(t,x(:,nChannels-i+1)*ChScale(nChannels-i+1),color); % plotting first trace on top
            axis tight
		end
    else
        if method == 1

            totRange = sum(ChAmp);
            ChHeight = curAxes(4)*ChAmp*scale/totRange;
            ChBaseline = mean(x([1:3,30:32],:),1);
            ChOffset = ChBaseline - min(x,[],1);
            ChOffset = ChOffset.*ChHeight./ChAmp;
            dw = curAxes(4)/nChannels;
            if (max(ChHeight)>2*dw)
                ChHeight = ChHeight*dw/max(ChHeight);
                ChOffset = ChOffset*dw/max(ChHeight);
            end
            for i=nChannels:-1:1
            	Aleft = curAxes(1);
				Abottom = curAxes(2)+dw/2+(nChannels-i)*dw-ChOffset(i);
                Awidth = curAxes(3);
				Aheight = ChHeight(i);
				h(i)=axes('Position',[Aleft Abottom Awidth Aheight]);
				plot(t,x(:,i),color); % plotting first trace on top
                axis tight
                
            end
        end
        if method==2
%            method =2
            %substract the baseline
            if ~isempty(get(gca,'Children'))
                h = axes('Position',curAxes);
            end
            x = x*scale;
            newx = x - repmat(mean(x([1:2,end-1:end],:),1),nTime,1);
            shift = max(ChAmp);
            newx = newx - shift/2-repmat([0:nChannels-1]*shift,nTime,1);
            plot(t,newx,color);
            axis tight
            if (shift ~= 0)
                set(gca,'YLim',[-shift*nChannels shift*0.3]);
            end
        end
       
    end
else
    plot(t,x,color);
end
set(h,'Visible','off');

function y= range(x)
y = max(x) - min(x);
return