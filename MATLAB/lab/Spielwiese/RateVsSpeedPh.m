function RateVsSpeedPh(FileBase,PlaceCell,whl,spike)

RateFactor = 20000/whl.rate;
neurons = unique(PlaceCell.ind(:,1));
direct = unique(PlaceCell.ind(:,4));

rateAll = Accumulate([round(spike.t(find(spike.good))/RateFactor) spike.ind(find(spike.good))],1,[length(whl.lin) max(spike.ind(find(spike.good)))])*whl.rate;

spike.speed = whl.speed(round(spike.t/RateFactor),1);

for n=1:length(neurons)
  for dir=direct'
    if dir<2
      continue;
    end

    indx = spike.dir==dir & spike.lpos>-10 & spike.good & spike.ind==neurons(n);
    
    rate = smooth(rateAll(round(spike.t(indx)/RateFactor),neurons(n)),10,'lowess');
    
    %[mkrate std Bins] = MakeAvF([spike.lpos(indx) spike.speed(indx)],spike.ph(indx),[100 100]); 
    %[mkrate std Bins] = MakeAvF([spike.lpos(indx) spike.speed(indx)],spike.ph(indx),[50 50]); 
    %[mkrate std Bins] = MakeAvF([spike.lpos(indx) spike.speed(indx)],rate(round(spike.t(indx)/RateFactor),neurons(n)),[100 100]); 
    %[mkrate std Bins] = MakeAvF([spike.lpos(indx) spike.speed(indx)],rate,[100 100]); 
    
    [mkrate xbin ybin] = hist2([spike.speed(indx) rate]);
    
    for s1=1:size(mkrate,1)
      smkrate(s1,:) = smooth(mkrate(s1,:),10,'lowess');
    end
    for s2=1:size(mkrate,2)
      smkrate(:,s2) = smooth(smkrate(:,s2),10,'lowess');
    end
       
    figure(dir)
    subplotfit(n,length(neurons))
    %imagesc(Bins{1},Bins{2},smkrate');
    imagesc(xbin,ybin,smkrate');
    colorbar
    set(gca,'ydir','normal');
    title(['cell ' num2str(neurons(n)) ' direction ' num2str(dir)])

    %%keyboard
    %AA = round(spike.speed(indx))+1;
    %BB = round(rate(round(spike.t(indx)/RateFactor),neurons(n)));
    %mkrate = Accumulate([AA BB],1); 
    
    %figure(dir)
    %subplotfit(n,length(neurons))
    %imagesc(mkrate');

    
    
    %% integrated tuning curves
    %sumrate = cumsum(rate(indx,neurons(n)));
    %dsumrate(2:length(sumrate)) = smooth(diff(sumrate),10,'lowess');
    %%dx(2:length((sumrate)) = smooth(diff(sumrate),10,'lowess');
    %mksum = MakeAvF([whl.lin(indx) whl.speed(indx,1)],dsumrate,[100 100]);
    %for s1=1:size(mksum,1)
    %  smksum(s1,:) = smooth(mksum(s1,:),10,'lowess');
    %end
    %for s2=1:size(mkrate,2)
    %  smksum(:,s2) = smooth(smksum(:,s2),10,'lowess');
    %end
    %figure(dir)
    %subplotfit(n,length(neurons))
    %imagesc(Bins{1},Bins{2},smksum');
    %set(gca,'ydir','normal');
    %title(['cell ' num2str(neurons(n)) ' direction ' num2str(dir)])
    
    clear dsumrate
    
  end
end

return

