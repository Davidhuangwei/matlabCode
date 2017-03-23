function mua = SVMUmuMore(FileBase,mua)

PLOT = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MAX SP

%% EEG/COH
%[mua.mxeeg mua.mxeegF idx] = MaxPeak(mua.spF,sq(mua.coh(:,:,1,1))',[5 10],4);
[mua.mxeeg mua.mxeegF idx] = MaxPeak(mua.spF,mua.spectgreeg',[5 10],4);

xi = reshape(idx,size(idx,1)*size(idx,2),1);
yi = reshape(repmat([1:size(idx,2)],size(idx,1),1),size(idx,1)*size(idx,2),1);
cohe = mua.spectgrcoh';
ph = mua.phase';

mua.mxeegcoh = mean(reshape(cohe(sub2ind(size(cohe),xi,yi)),size(idx,1),size(idx,2)));
mua.mxeegph = circmean(reshape(ph(sub2ind(size(cohe),xi,yi)),size(idx,1),size(idx,2)));


%% UNIT
%[mua.mxunit mua.mxunitF idx] = MaxPeak(mua.spF,sq(mua.coh(:,:,2,2))',[5 10],4);
[mua.mxunit mua.mxunitF idx] = MaxPeak(mua.spF,mua.spectgrunit',[5 11],4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MEANS
%MSP = sq(mean(mua.coh,1));
%mua.avspunit = MSP(:,2,2);
%mua.avspeeg = MSP(:,1,1);
%mua.avscoh = MSP(:,2,1);
%[emaxt emaxx] = MaxPeak(mua.spF,MSP(:,1,1),[5 10],4);
%[umaxt umaxx] = MaxPeak(mua.spF,MSP(:,2,2),[5 10],4);
%[cmaxt cmaxx] = MaxPeak(mua.spF,MSP(:,2,1),[5 10],4);

mua.avspunit = mua.spectgrunit;
mua.avspeeg = mua.spectgreeg;
mua.avscoh = mua.spectgrcoh;
[emaxt emaxx] = MaxPeak(mua.spF,mua.avspeeg,[5 11],4);
[umaxt umaxx] = MaxPeak(mua.spF,mua.avspunit,[5 11],4);
[cmaxt cmaxx] = MaxPeak(mua.spF,mua.avscoh,[5 11],4);



mua.avmxunit = umaxt;
mua.avmxeeg = emaxt;
mua.avmxcoh = cmaxt;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% X * Y
%% 
%% mua.unitrate:    [4511x74]
%% mua.activecells: [4511x1]
%% mua.mxeeg:       [1x4511]
%% mua.mxeegF:      [1x4511]
%% mua.mxeegcoh:    [1x4511]
%% mua.mxunit:      [1x4511]
%% mua.mxunitF:     [1x4511]
%% mua.mxeegph:     [1x4511]

%% 
X = mua.mxeeg;
a = round(mua.mxeegcoh*100)'; a(a==0)=1;
b = round(X/max(X)*100)'; b(b==0)=1;
[AccMxeeg] = Accumulate([a b],1);
%% 
X = mua.mxeegF;
a = round(mua.mxeegcoh*100)'; a(a==0)=1;
b = round(X/max(X)*100)'; b(b==0)=1;
[AccMxeegF] = Accumulate([a b],1);
%% 
X = mua.mxeegF;
Y = mua.mxunitF;
a = round(Y/max(Y)*50)'; a(a==0)=1;
b = round(X/max(X)*50)'; b(b==0)=1;
[AccMxuef] = Accumulate([a b],1);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT

if PLOT
  figure(1);clf
  subplot(311)
  plot(mua.spF,MSP(:,1,1),'k','LineWidth',2)
  axis tight
  Lines(emaxt,[],'r','--',2);
  ylabel('LFP','Fontsize',16)
  set(gca,'TickDir','out','FontSize',16)
  xlim([4 12])
  box off
  %
  subplot(312)
  plot(mua.spF,MSP(:,2,2),'k','LineWidth',2)
  axis tight
  Lines(umaxt,[],'g','--',2);
  Lines(emaxt,[],'r','--',2);
  ylabel('MUA','Fontsize',16)
  set(gca,'TickDir','out','FontSize',16)
  xlim([4 12])
  box off
  %
  subplot(313)
  plot(mua.spF,MSP(:,2,1),'k','LineWidth',2)
  axis tight
  Lines(cmaxt,[],'g','--',2);
  Lines(emaxt,[],'r','--',2);
  ylabel('coherence','Fontsize',16)
  set(gca,'TickDir','out','FontSize',16)
  xlim([4 12])
  box off
end

return;

