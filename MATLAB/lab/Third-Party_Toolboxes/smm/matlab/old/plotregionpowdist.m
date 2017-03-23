function plotregionpowdist(returnarmPowMat,centerarmPowMat,choicepointPowMat,choicearmPowMat,chanmat,badchan,nbins)

if ~exist('samescale','var')
    samescale = 0;
end
if ~exist('badchan','var')
    badchan = 0;
end
if ~exist('dbscale','var')
    dbscale = 0;
end

widthscaler = 0.03;
[chan_y chan_x chan_z] = size(chanmat);


for z=1:chan_z
    figure(z)
    clf
    for y=1:chan_y
        for x=1:chan_x
            if isempty(find(badchan==chanmat(y,x,z))), % if the channel isn't bad
               subplot(chan_y,chan_x,(y-1)*chan_x+x);
               xmin = [];
               xmax = [];
                hold on;
                [rta rtb]=hist(returnarmPowMat(:,chanmat(y,x,z)),nbins);
                xmin = min([xmin rtb]);
                xmax = max([xmax rtb]);
                
                [caa cab]=hist(centerarmPowMat(:,chanmat(y,x,z)),nbins);
                xmin = min([xmin cab]);
                xmax = max([xmax cab]);
                
                [cpa cpb]=hist(choicepointPowMat(:,chanmat(y,x,z)),nbins);
                xmin = min([xmin cpb]);
                xmax = max([xmax cpb]);
                
                [rwa rwb]=hist(choicearmPowMat(:,chanmat(y,x,z)),nbins);
                 xmin = min([xmin rwb]);
                xmax = max([xmax rwb]);

                bar(rtb,rta,widthscaler/mean(diff(rtb))*range([xmin xmax]),'b');
                bar(cab,caa,widthscaler/mean(diff(cab))*range([xmin xmax]),'r');
                bar(cpb,cpa,widthscaler/mean(diff(cpb))*range([xmin xmax]),'y');
                bar(rwb,rwa,widthscaler/mean(diff(rwb))*range([xmin xmax]),'g')
               
                title(['channel ' num2str(chanmat(y,x,z))]);
               set(gca,'xlim',[xmin-0.5 xmax+0.5],'xtick',[ceil(xmin-0.5) floor(xmax+0.5)],'fontsize', 8);

            end
        end
    end
end
min([min(find(RWaccum)/4) min(find(RTaccum)/4) min(find(CPaccum)/4) min(find(CAaccum)/4])))
