function Rips = InternRips(FileBase,varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Ripple detection
%% (needs: FileBase.elc, FileBase.evt)
%% (output: Rips >> FileBase.spw)
%% 
[overwrite,Events,CheckStates] = DefaultArgs(varargin,{0,0,0});

if ~FileExists([FileBase '.elc'])
  error('no channel for ripple detection is specified.\n');
else
  load([FileBase '.elc'],'-MAT');
end
  
if  ~FileExists([FileBase '.spw']) | overwrite
  fprintf('Ripple detection...\n');
  getRips=DetectRipples(FileBase,elc.rip,[100 250],7);
  
  if Events
    % take out the stimulating artefacts:
    if ~FileExists([FileBase '.evt'])
      Evt=load([FileBase '.events']);
    else      
      Evt=load([FileBase '.evt']);
    end
    stim = Evt(Evt(:,2)==88,:);
    markRips = ~WithinRanges(getRips.t/1250,[stim(:,1)/1250-0.5 stim(:,1)/1250+0.5]); 
  else
    markRips = ones(size(getRips.t));
  end
  
  Ripst = getRips.t(find(markRips)); 
  Ripslen = getRips.len(find(markRips)); 
  Ripspow = getRips.pow(find(markRips)); 

  if CheckStates
    Eeg = GetEEG(FileBase);
    figure
    n=0;
    while n<size(Ripst,1)
      n=n+1;
      clf;
      t1 = Ripst(n,1)-round(Ripslen(n,1)./2);
      t2 = Ripst(n,1)+round(Ripslen(n,1)./2);
      subplot(211)
      plot([t1:t2]'/1250,Eeg(t1:t2),'r');
      subplot(212)
      plot([t1-500:t2+500]'./1250,Eeg(t1-500:t2+500));
      hold on
      plot([t1:t2]'/1250,Eeg(t1:t2),'r');
      ForAllSubplots('axis tight');
      title(['n=' num2str(n) ' pow=' num2str(Ripspow(n))])
      waitforbuttonpress;
      whatbutton = get(gcf,'SelectionType');
      switch whatbutton
       case 'normal'   % left -- PC 
	goodRip(n) = 1
       case 'alt'      % right -- bad
	goodRip(n) = 0
       case 'extend'   % mid -- back
	n=n-2; 
       case 'open'     % double click -- nothing
	n=n-1;
      end
    end
  else
    goodRip = ones(size(Ripst));
  end
 
  Rips.t = Ripst(find(goodRip),:);
  Rips.len = Ripslen(find(goodRip),:);
  Rips.pow = Ripspow(find(goodRip),:);
  msave([FileBase '.spw'],[Rips.t Rips.len Rips.pow]);

else
  getRips=load([FileBase '.spw']);
  Rips.t = getRips(:,1);
  Rips.len = getRips(:,2);
  Rips.pow = getRips(:,3);
end

return;