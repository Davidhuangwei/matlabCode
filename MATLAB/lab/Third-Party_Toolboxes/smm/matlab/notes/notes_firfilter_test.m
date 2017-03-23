wavelengths = 1000./[4:16];
sampl = 1250;
signals = zeros(length(wavelengths), sampl*60*5);
for i=1:length(wavelengths)
    sinwave = 0:sampl*60-1;
    sinwave = sinwave/sampl*1000/wavelengths(i)*360;
    sinwave = mod(sinwave,360);
    sinwave = sinwave/360*2*pi;
    sinwave = sin(sinwave);
    signals(i,sampl*60+1:sampl*60*2) = sinwave;
    signals(i,sampl*60*2+1:sampl*60*3) = sinwave/2;
    signals(i,sampl*60*3+1:sampl*60*4) = sinwave;
end

lowband = 6;
highband = 14;
forders = 100.*[3:10];
[m,n] = size(signals);
filtsigs = zeros(m, n,length(forders));
for i=1:length(forders)
    firfiltb = fir1(forders(i),[lowband/sampl*2,highband/sampl*2]);
    filtsigs(:,:,i) = [Filter0(firfiltb,signals')]'; % filtering
end


figure;
timepoint = 2;
xdist = 1*sampl;
for i = 1:length(wavelengths)
    for j = 1:length(forders)
        subplot(length(wavelengths),length(forders),(i-1)*length(forders)+j)
        filtsigsChunk = abs(filtsigs(i,(sampl*60*timepoint+1-xdist):(sampl*60*timepoint+1+xdist),j));
        localmaxes = LocalMaxima(filtsigsChunk);
        signalsChunk = abs(signals(i,(sampl*60*timepoint+1-xdist):(sampl*60*timepoint+1+xdist)));
        proportion = filtsigsChunk(localmaxes)./signalsChunk(localmaxes);
        plot(1000/sampl.*(localmaxes-xdist),proportion-proportion(end));
        %set(gca, 'ylim',[-0.5 1.5], 'ytick',[0 1]);
        set(gca, 'xlim',1000/sampl.*[-xdist xdist], 'xtick', 1000/sampl.*[-xdist -xdist/2 0 xdist/2 xdist]);
        if j==1
            ylabel([num2str(1000/wavelengths(i)) 'Hz'])
        end
        if i==length(wavelengths)
            xlabel(['forder=' num2str(forders(j))]);
        end
        if i==1 & j==floor(length(forders)/2)
            title(['0 to 1 transition: lowcut=' num2str(lowband) ', highcut=' num2str(highband)]);
        end
        grid on;
    end
end

figure;
timepoint = 1;
xdist = 1*sampl;
for i = 1:length(wavelengths)
    for j = 1:length(forders)
        subplot(length(wavelengths),length(forders),(i-1)*length(forders)+j)
        plot(1000/1250.*[-xdist:xdist],abs(filtsigs(i,(sampl*60*timepoint+1-xdist):(sampl*60*timepoint+1+xdist),j))./abs(signals(i,(sampl*60*timepoint+1-xdist):(sampl*60*timepoint+1+xdist))))
        set(gca, 'ylim',[0 1.5]);
        set(gca, 'xlim',1000/1250.*[-xdist xdist]);
        if j==1
            ylabel([num2str(1000/wavelengths(i)) 'Hz'])
        end
        if i==length(wavelengths)
            xlabel(['forder=' num2str(forders(j))]);
        end
        if i==1 & j==floor(length(forders)/2)
            title(['zero to 1 transition: lowcut=' num2str(lowband) ', highcut=' num2str(highband)]);
        end
    end
end


for wavelength = 1:length(wavelengths)
    figure(wavelength);
    clf;
    hold on;
    xdist = 1*sampl;
    yoffset = 1;
    for i=1:length(forders)
        plot(1000/1250.*[-xdist:xdist],filtsigs(wavelength,(sampl*60+1-xdist):(sampl*60+1+xdist),i)+i*yoffset,'color',[mod(i,2) 0 0]);
    end
    plot(1000/1250.*[-xdist:xdist],signals(wavelength,(sampl*60+1-xdist):(sampl*60+1+xdist)),'color',[mod(i,2) 0 0]);
    title(['freq=' num2str(1000/wavelengths(wavelength)) 'Hz, lowcut=' num2str(lowband) ', highcut=' num2str(highband)]);
    set(gca, 'yticklabel', [0 0 forders(1:length(forders))]);
    ylabel('forder');
    grid on;
end

for wavelength = 1:length(wavelengths)
    figure(wavelength);
    clf;
    hold on;
    xdist = 1*sampl;
    yoffset = 1;
    for i=1:length(forders)
        plot(1000/1250.*[-xdist:xdist],filtsigs(wavelength,(sampl*60*2+1-xdist):(sampl*60*2+1+xdist),i)+i*yoffset,'color',[mod(i,2) 0 0]);
    end
    plot(1000/1250.*[-xdist:xdist],signals(wavelength,(sampl*60*2+1-xdist):(sampl*60*2+1+xdist)),'color',[mod(i,2) 0 0]);
    title(['freq=' num2str(1000/wavelengths(wavelength)) 'Hz, lowcut=' num2str(lowband) ', highcut=' num2str(highband)]);
    set(gca, 'yticklabel', [0 0 forders(1:length(forders))]);
    ylabel('forder');
    grid on;
end

for wavelength = 1:length(wavelengths)
    figure(wavelength);
    clf;
    hold on;
    xdist = 1*sampl;
    yoffset = 1;
    for i=1:length(forders)
        plot(1000/1250.*[-xdist:xdist],filtsigs(wavelength,(sampl*60*3+1-xdist):(sampl*60*3+1+xdist),i)+i*yoffset,'color',[mod(i,2) 0 0]);
    end
    plot(1000/1250.*[-xdist:xdist],signals(wavelength,(sampl*60*3+1-xdist):(sampl*60*3+1+xdist)),'color',[mod(i,2) 0 0]);
    title(['freq=' num2str(1000/wavelengths(wavelength)) 'Hz, lowcut=' num2str(lowband) ', highcut=' num2str(highband)]);
    set(gca, 'yticklabel', [0 0 forders(1:length(forders))]);
    ylabel('forder');
    grid on;
end

for wavelength = 1:length(wavelengths)
    figure(wavelength);
    clf;
    hold on;
    xdist = 1*sampl;
    yoffset = 1;
    for i=1:length(forders)
        plot(1000/1250.*[-xdist:xdist],filtsigs(wavelength,(sampl*60*4+1-xdist):(sampl*60*4+1+xdist),i)+i*yoffset,'color',[mod(i,2) 0 0]);
    end
    plot(1000/1250.*[-xdist:xdist],signals(wavelength,(sampl*60*4+1-xdist):(sampl*60*4+1+xdist)),'color',[mod(i,2) 0 0]);
    title(['freq=' num2str(1000/wavelengths(wavelength)) 'Hz, lowcut=' num2str(lowband) ', highcut=' num2str(highband)]);
    set(gca, 'yticklabel', [0 0 forders(1:length(forders))]);
    ylabel('forder');
    grid on;
end
