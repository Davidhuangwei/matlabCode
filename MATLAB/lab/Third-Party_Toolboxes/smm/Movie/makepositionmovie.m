function makepositionmovie(filebase,framejump)

aviobj = avifile('junkmovie.avi')
whldata = load([filebase '.whl']);
[whlm,n]=size(whldata);
figure(1)
hold on
i=framejump

while (i<whlm)
    cla;
    hold on
    
    for j=i-framejump+1:i   
        plot(whldata(j,1), whldata(j,2),'.','color',[1 1 0],'markersize',25,'linestyle','none');
    end
    set(gca,'xlim',[0 368],'ylim',[0 240]);
    plot(whldata(i,1), whldata(i,2),'.','color',[1 0 0],'markersize',25,'linestyle','none');
    
    uin = input('how far to step (in video frames)?');
    if (uin~=[]),
        step = uin;
    end
    i=i+step;
    
    frame = getframe(gca);
    aviobj = addframe(aviobj,frame);
end


aviobj = close(aviobj);
