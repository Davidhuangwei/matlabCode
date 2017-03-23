function [spw, AvSegs]= AveSWP(FileBase,varargin)
[RipsLength,overwrite] = DefaultArgs(varargin,{100,0});
% 
if ~FileExists([FileBase '.spw'])
  error('Ripples are not detected!');
end

if FileExists([FileBase '.spw.elc']) & FileExists([FileBase '.spw.ave']) & overwrite==0
  spw=load([FileBase '.spw.elc']);
  AvSegs =load([FileBase '.spw.elc']);
  return;
end

Rips = load([FileBase '.spw']);

RipsBeg = round(Rips(:,1)-RipsLength*1.25);

SegLen = 2*round(RipsLength*1.25)+1;
Channels = RepresentChan(FileBase);
Par = LoadPar([FileBase '.xml']);
[Segs, Complete] = LoadSegs([FileBase '.eeg'], RipsBeg , SegLen, Par.nChannels, Channels, 1250,1,0,[]);

%keyboard;

if length(find(isnan(Segs(:))))
  error('there are NaN elements in the Eeg Segments!')
end
%keyboard

AvSegs = sq(mean(Segs(:,:,:),3));

for elc=1:Par.nElecGps
  AvSegs(:,elc) = AvSegs(:,elc) - mean(AvSegs(1:10,elc),1);
end

nRips = size(Segs,3);
nCh = length(Channels);

Amp = AvSegs((SegLen-1)/2+1,:);

for i=1:nRips
  [y(:,:,:,i),f]= mtcsd(sq(Segs(:,:,i)),2^11,1250,2^6,[],2,'linear',[],[100 250]);
end

AvCsd = sq(mean(y,4));
  
for Ch1 = 1:nCh
  for Ch2 = 1:nCh
    
    if (Ch1 == Ch2)
      AvCoh(:,Ch1, Ch2) = y(:,Ch1, Ch2);
    else
      norm = (y(:,Ch1,Ch1) .* y(:,Ch2,Ch2));
      
      AvCoh(:,Ch1, Ch2) = (abs(y(:,Ch1, Ch2))).^2 ./ norm;
      Phase(:,Ch1,Ch2) = angle(y(:,Ch1, Ch2) ./sqrt(norm) );
    end
  end
end


for i=1:nCh  
  Pow(i) = sq(log(mean(abs(AvCoh(:,i,i).^2))));
end  

[maxpow maxch] = max(Pow);
Ph = sq(mean(Phase(:,maxch,:)));

spw(:,1) = [1:Par.nElecGps]';
spw(:,2) = Amp';
spw(:,3) = Pow';
spw(:,4) = Ph';

figure
subplot(122)
PlotTraces(AvSegs(:,:))

subplot(222)
scatter(Amp,Pow,50,Ph)
colorbar;

subplot(6,2,8)
bar(spw(:,2));
subplot(6,2,10)
bar(Pow);
subplot(6,2,12)
bar(Ph);

%msave([FileBase '.spw.elc'],spw);
%msave([FileBase '.spw.ave'],AvSegs);

