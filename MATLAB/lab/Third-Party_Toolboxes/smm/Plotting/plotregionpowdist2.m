function plotregionpowdist2(returnarmPowMat,centerarmPowMat,choicepointPowMat,choicearmPowMat,chanmat,badchan)

if ~exist('samescale','var')
    samescale = 0;
end
if ~exist('badchan','var')
    badchan = 0;
end
if ~exist('dbscale','var')
    dbscale = 0;
end
smoothlen =9;

[chan_y chan_x chan_z] = size(chanmat);

accumfactor = 4;

for z=1:chan_z
    figure(z)
    clf
    for y=1:chan_y
        for x=1:chan_x
            if isempty(find(badchan==chanmat(y,x,z))), % if the channel isn't bad
               subplot(chan_y,chan_x,(y-1)*chan_x+x);
               xmin = [];
               xmax = [];
               
               RTaccum = Accumulate(round(returnarmPowMat(:,chanmat(y,x,z))*accumfactor));
               CAaccum = Accumulate(round(centerarmPowMat(:,chanmat(y,x,z))*accumfactor));
               CPaccum = Accumulate(round(choicepointPowMat(:,chanmat(y,x,z))*accumfactor));
               RWaccum = Accumulate(round(choicearmPowMat(:,chanmat(y,x,z))*accumfactor));

               RTaccum = [RTaccum; zeros(200,1)];
               CAaccum = [CAaccum; zeros(200,1)];
               CPaccum = [CPaccum; zeros(200,1)];
               RWaccum = [RWaccum; zeros(200,1)];
               
               

hanfilter = hanning(smoothlen);
hanfilter = hanfilter./sum(hanfilter);
RTaccum = Filter0(hanfilter,RTaccum);
CAaccum = Filter0(hanfilter,CAaccum);
CPaccum = Filter0(hanfilter,CPaccum);
RWaccum = Filter0(hanfilter,RWaccum);              
               
               xmin = min([min(find(RWaccum)/accumfactor) min(find(RTaccum)/accumfactor) min(find(CPaccum)/accumfactor) min(find(CAaccum)/accumfactor)]);
               xmax = max([max(find(RWaccum)/accumfactor) max(find(RTaccum)/accumfactor) max(find(CPaccum)/accumfactor) max(find(CAaccum)/accumfactor)]);
               hold on
                %colormap([0 0 1;1 0 0;1 1 0;0 1 0]);
                
                 plot([xmin:1/accumfactor:xmax],RTaccum(xmin*accumfactor:xmax*accumfactor),'LineWidth',1,'color',[0 0 1]);
                plot([xmin:1/accumfactor:xmax],CAaccum(xmin*accumfactor:xmax*accumfactor),'LineWidth',1,'color',[1 0 0]);
                plot([xmin:1/accumfactor:xmax],CPaccum(xmin*accumfactor:xmax*accumfactor),'LineWidth',1,'color',[0 1 0]);
                plot([xmin:1/accumfactor:xmax],RWaccum(xmin*accumfactor:xmax*accumfactor),'LineWidth',1,'color',[0 0 0]);
                %bar([xmin:1/accumfactor:xmax]',[RTaccum(xmin*accumfactor:xmax*accumfactor) CAaccum(xmin*accumfactor:xmax*accumfactor) RWaccum(xmin*accumfactor:xmax*accumfactor) CPaccum(xmin*accumfactor:xmax*accumfactor)],width*range([xmin xmax]),'grouped');
                %bar(cab,caa,widthscaler/mean(diff(cab))*range([xmin xmax]),'r');
                %bar(cpb,cpa,widthscaler/mean(diff(cpb))*range([xmin xmax]),'y');
                %bar(rwb,rwa,widthscaler/mean(diff(rwb))*range([xmin xmax]),'g')
                
               %shading flat
               shading faceted
                title(['channel ' num2str(chanmat(y,x,z))]);
               set(gca,'xlim',[xmin xmax],'xtick',[ceil(xmin) floor(xmax)],'ylim',[0 6],'fontsize', 8);
%'xlim',[xmin-0.5 xmax+0.5],'xtick',[ceil(xmin-0.5) floor(xmax+0.5)],
            end
        end
    end
end
