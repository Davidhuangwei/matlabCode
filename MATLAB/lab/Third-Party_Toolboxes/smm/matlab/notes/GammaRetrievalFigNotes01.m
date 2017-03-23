numBins = 100;
numCells = 10;
spacer = 3;
numCycles = 8;
firingThresh = 0.5;
%lfpSmoother = gausswin(7)/sum(gausswin(7));
lfpSmoother = ones(4,1)/sum(ones(4,1));
CA3 = rand(numBins,numCells);
CA1 = rand(numBins,numCells);
CA3CA1phase = -1.5;
beforeGammaMod = 0.4;
afterGammaMod = 1;

CA3gammaOsc = cat(2,...
    (sin(numCycles*2*pi/(numBins/2):numCycles*2*pi/(numBins/2):numCycles*2*pi)*beforeGammaMod+1),...
    (sin(numCycles*2*pi/(numBins/2):numCycles*2*pi/(numBins/2):numCycles*2*pi)*afterGammaMod+1));

CA1gammaOsc = cat(2,...
    (sin(CA3CA1phase+(numCycles*2*pi/(numBins/2):numCycles*2*pi/(numBins/2):numCycles*2*pi+numCycles*2*pi/(numBins/2)))*beforeGammaMod+1),...
    (sin(CA3CA1phase+(numCycles*2*pi/(numBins/2)+numCycles*2*pi/(numBins/2):numCycles*2*pi/(numBins/2):numCycles*2*pi))*afterGammaMod+1));

CA3 = CA3.*repmat(CA3gammaOsc',1,numCells);
CA3spikes = CA3>firingThresh;
CA1 = CA1.*repmat(CA1gammaOsc',1,numCells);
CA1spikes = CA1>firingThresh;

figure(1)
clf
subplot(6,1,1)
plot(ConvTrim(-sum(CA1,2),lfpSmoother))
set(gca,'xlim',[1 numBins],'ylim',[-numCells 0],'xtick',[],'ytick',[])

subplot(6,1,2)
hist(mod(find(CA1spikes),numBins),numBins-1)
set(gca,'xlim',[1 numBins],'xtick',[],'ytick',[])

subplot(6,1,3)
hold on
for j=1:numCells
    for k=1:numBins
%         if CA3spikes(k,j)
%             plot([k k]+rand(1),[j j+1],'k')
%         end
        if CA1spikes(k,j)
            plot([k k]+rand(1)-0.5,[j j+1],'k')
        end
    end
end
set(gca,'xlim',[1 numBins],'ylim',[0 numCells+2],'xtick',[],'ytick',[]);

subplot(6,1,4)
hold on
for j=1:numCells
    for k=1:numBins
        if CA3spikes(k,j)
            plot([k k]+rand(1)-0.5,[j j+1],'k')
        end
%         if CA1spikes(k,j)
%             plot([k k]+rand(1),[j j+1]+numCells+spacer,'k')
%         end
    end
end
set(gca,'xlim',[1 numBins],'ylim',[0 numCells+2],'xtick',[],'ytick',[]);

subplot(6,1,5)
hist(mod(find(CA3spikes),numBins),numBins-1)
set(gca,'xlim',[1 numBins],'xtick',[],'ytick',[])

subplot(6,1,6)
plot(ConvTrim(-sum(CA3,2),lfpSmoother))
set(gca,'xlim',[1 numBins],'ylim',[-numCells 0],'xtick',[],'ytick',[])





figure(2)
clf
subplot(6,1,1)
plot(ConvTrim(-sum(CA1(:,1),2),lfpSmoother))
set(gca,'xlim',[1 numBins],'ylim',[-numCells 0],'xtick',[],'ytick',[])

subplot(6,1,2)
hist(mod(find(CA1spikes(:,1)),numBins),numBins+1)
set(gca,'xlim',[1 numBins],'xtick',[],'ytick',[])

subplot(6,1,3)
hold on
for j=1:1
    for k=1:numBins
%         if CA3spikes(k,j)
%             plot([k k]+rand(1),[j j+1],'k')
%         end
        if CA1spikes(k,j)
            plot([k k]+rand(1)-0.5,[j j+1],'k')
        end
    end
end
set(gca,'xlim',[1 numBins],'ylim',[0 numCells+2],'xtick',[],'ytick',[]);

subplot(6,1,4)
hold on
for j=1:1
    for k=1:numBins
        if CA3spikes(k,j)
            plot([k k]+rand(1)-0.5,[j j+1],'k')
        end
%         if CA1spikes(k,j)
%             plot([k k]+rand(1),[j j+1]+numCells+spacer,'k')
%         end
    end
end
set(gca,'xlim',[1 numBins],'ylim',[0 numCells+2],'xtick',[],'ytick',[]);

subplot(6,1,5)
hist(mod(find(CA3spikes(:,1)),numBins),numBins+1)
set(gca,'xlim',[1 numBins],'xtick',[],'ytick',[])

subplot(6,1,6)
plot(ConvTrim(-sum(CA3(:,1),2),lfpSmoother))
set(gca,'xlim',[1 numBins],'ylim',[-numCells 0],'xtick',[],'ytick',[])



% CA3before = rand(numBins/2,numCells);
% CA3after = rand(numBins/2,numCells);

%plot(sum(CA3spikes,2))

% gammaOsc = gammaOsc(1:end-1)';
% CA3before = CA3before.*repmat(gammaOsc,1,numCells);
% 
% gammaOsc = (sin(0:numCycles*2*pi/(numBins/2):numCycles*2*pi)+1);
% gammaOsc = gammaOsc(1:end-1)';
% CA3after = CA3after.*repmat(gammaOsc,1,numCells);
 
% CA3 = cat(1,CA3before,CA3after);
%         if CA3before(k,j)>firingThresh
%             plot([k k],[j j+1])
%         end
%         if CA3after(k,j)>firingThresh
%             plot([k+numBins k+numBins],[j j+1])
%         end
