function plotregionpow2(returnarmPowMat,centerarmPowMat,choicepointPowMat,choicearmPowMatchanmat,badchan,samescale)

meanReturn = mean(returnarmPowMat,1);
meanCenter = mean(centerarmPowMat,1);
meanCP = mean(choicepointPowMat,1);
meanChoice = mean(choicearmPowMat,1);

steReturn = std(returnarmPowMat)./sqrt(ntrials);
steCenter = std(centerarmPowMat)./sqrt(ntrials);
steCP = std(choicepointPowMat)./sqrt(ntrials);
steChoice = std(choicearmPowMat)./sqrt(ntrials);

%if dbscale,
%    meanReturn = 10*log10(meanReturn);
%    meanCenter = 10*log10(meanCenter);
%    meanCP = 10*log10(meanCP);
%    meanChoice = 10*log10(meanChoice);
%    
%    steReturn = 10*log10(steReturn);
%    steCenter = 10*log10(steCenter);
%    steCP = 10*log10(steCP);
%    steChoice = 10*log10(steChoice);
%end



if ~exist('samescale','var')
    samescale = 0;
end
if ~exist('badchan','var')
    badchan = 0;
end
if ~exist('dbscale','var')
    dbscale = 0;
end


[chan_y chan_x chan_z] = size(chanmat);

ymin = [];
ymax = [];
    
for z=1:chan_z
    figure(z)
    for y=1:chan_y
        for x=1:chan_x
            if isempty(find(badchan==chanmat(y,x,z))), % if the channel isn't bad
               
                % now plot
                subplot(chan_y,chan_x,(y-1)*chan_x+x);
                hold on;
                bar(1,meanReturn(chanmat(y,x,z)));
                plot([1 1],[meanReturn(chanmat(y,x,z))-3*steReturn(chanmat(y,x,z)) meanReturn(chanmat(y,x,z))+3*steReturn(chanmat(y,x,z))],'color',[1 0 0]);
                
                bar(2,meanCenter(chanmat(y,x,z)));
                plot([2 2],[meanCenter(chanmat(y,x,z))-3*steCenter(chanmat(y,x,z)) meanCenter(chanmat(y,x,z))+3*steCenter(chanmat(y,x,z))],'color',[1 0 0]);
                
                bar(3,meanCP(chanmat(y,x,z)));
                plot([3 3],[meanCP(chanmat(y,x,z))-3*steCP(chanmat(y,x,z)) meanCP(chanmat(y,x,z))+3*steCP(chanmat(y,x,z))],'color',[1 0 0]);
                
                bar(4,meanChoice(chanmat(y,x,z)));
                plot([4 4],[meanChoice(chanmat(y,x,z))-3*steChoice(chanmat(y,x,z)) meanChoice(chanmat(y,x,z))+3*steChoice(chanmat(y,x,z))],'color',[1 0 0]);
                if samescale,
                    ymin = min([ymin meanCP(chanmat(y,x,z))-3*steCP(chanmat(y,x,z)) meanReturn(chanmat(y,x,z))-3*steReturn(chanmat(y,x,z)) meanChoice(chanmat(y,x,z))-3*steChoice(chanmat(y,x,z)) meanCenter(chanmat(y,x,z))-3*steCenter(chanmat(y,x,z))]);
                    ymax = max([ymax meanCP(chanmat(y,x,z))+3*steCP(chanmat(y,x,z)) meanReturn(chanmat(y,x,z))+3*steReturn(chanmat(y,x,z)) meanChoice(chanmat(y,x,z))+3*steChoice(chanmat(y,x,z)) meanCenter(chanmat(y,x,z))+3*steCenter(chanmat(y,x,z))]);
                else
                    set(gca, 'ylim', [min([meanCP(chanmat(y,x,z))-3*steCP(chanmat(y,x,z)) meanReturn(chanmat(y,x,z))-3*steReturn(chanmat(y,x,z)) meanChoice(chanmat(y,x,z))-3*steChoice(chanmat(y,x,z)) meanCenter(chanmat(y,x,z))-3*steCenter(chanmat(y,x,z))])-1 max([meanCP(chanmat(y,x,z))+3*steCP(chanmat(y,x,z)) meanReturn(chanmat(y,x,z))+3*steReturn(chanmat(y,x,z)) meanChoice(chanmat(y,x,z))+3*steChoice(chanmat(y,x,z)) meanCenter(chanmat(y,x,z))+3*steCenter(chanmat(y,x,z))])+1]);
                end
                set(gca, 'xtick', [1 2 3 4], 'xticklabel', ['rt'; 'ca'; 'cp'; 'rw']);
            end
        end
    end
end
if samescale,
    for z=1:chan_z
        figure(z)
        for y=1:chan_y
            for x=1:chan_x
                if isempty(find(badchan==chanmat(y,x,z))), % if the channel isn't bad
                    % now plot
                    subplot(chan_y,chan_x,(y-1)*chan_x+x);
                    set(gca,'ylim',[ymin ymax]);
                end
            end
        end
    end
end
 
