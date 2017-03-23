function loc = ElecLoc(FileBase,varargin)
overwrite = DefaultArgs(varargin,{0});
% determining the location of electrodes by the shape of the
% everaged shape of the ripple envelope. 
%
if ~FileExists([FileBase '.spw.elc']) | ~FileExists([FileBase '.spw.ave'])
  error('.spw.elc and .spw.ave dont exist \n')
end

if FileExists([FileBase '.elc.loc']) & overwrite==0
  loc = load([FileBase '.elc.loc']);
  return;
end

spw = load([FileBase '.spw.elc']);
AvSegs = load([FileBase '.spw.ave']);

figure
subplot(121)
PlotTraces(AvSegs(:,:))
%plot(AvSegs)

%keyboard

subplot(222)
scatter(spw(:,2),spw(:,3),50,spw(:,4))
xlabel('Amplitude');ylabel('Power');
colorbar;

subplot(6,2,8)
bar(spw(:,2));
ylabel('Amplitude');
subplot(6,2,10)
bar(spw(:,3))
ylabel('Power');
subplot(6,2,12)
bar(spw(:,4));
ylabel('Phase');

fprintf('Location of electrodes:\n 0=cortex \n 1=above pyr. layer \n 2=in pyr. layer \n 3=below pyr. layer \n 100=somewhere else \n');

for elc=1:size(spw,1)
  loc(elc) = input(['\n Location of electode ' num2str(elc) ': ']);
end

%msave([FileBase '.elc.loc'],AvSegs);








return;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('electode location...\n');
if ~FileExists([FileBase '.loc']) 
  Par = LoadPar([FileBase '.par']);
  system(['neuroscope ' FileBase '.eeg']);
  locaton = [];
  while ~(length(location)-Par.nElecGps);
    location = input(['location of ' num2str(Par.nElecGps) ' electrodes (p=0, above=1, below=-1, cortex=2): ']);
  end
  msave([FileBase '.loc'],location');
else
  load([FileBase '.loc']);
  if overwrite
    ask = input('really overwrite [0/1]? ');
    if ask
      Par = LoadPar([FileBase '.par']);
      system(['neuroscope ' FileBase '.eeg'])
      locaton = [];
      while ~(length(location)-Par.nElecGps);
	location = input(['location of ' num2str(Par.nElecGps) ' electrodes (p=0, above=1, below=-1, cortex=2): ']);
      end
      msave([FileBase '.loc'],location');
    end
  end
end

return;

