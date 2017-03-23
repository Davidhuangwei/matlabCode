% Plots a rainbow sine wave

nCyc =  7;
Width = 7;
Step = 0.2;

cm = hsv(360);
clf; hold on
h=[];
for i=91:Step:360*nCyc+90
    plot([i-1 i], cos([i-1 i]*pi/180), 'color', cm(1+floor(mod(i+180,360)),:), ...
        'linewidth', Width);
%   h= [h patch([i-1 i i i-1], [0 0 cos([i i-1]*pi/180)], cm(i,:))];
end
ylim([-1.5 1.5])
xlim([85 360*nCyc+95])
axis off

%print -depsc2 /u5/b/ken/bitz/Rainbow.eps
print -djpeg90 -r300 /home/ken/bitz/7cyc.jpg

%set(h, 'edgealpha', 0);