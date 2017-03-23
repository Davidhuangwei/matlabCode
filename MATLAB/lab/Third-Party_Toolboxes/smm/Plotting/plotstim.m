function plotstim(dataseg, stims)
sampl = 20000;
firfiltb = fir1(600,[4/sampl*2,20/sampl*2]);
filtseg = Filter0(firfiltb,dataseg);
figure;
clf; 
j=1;
gomore=1;
while(gomore)
    keyboard
    for i=2:length(stims)
        clf;
        hold on; 
        plot(filtseg((stims(i)-100000):(stims(i)+100000),j)); 
    end
end