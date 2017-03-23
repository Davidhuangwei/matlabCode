%function Out = PhaseOfTrain(Ph,Clu,Res,Periods,InOut, Brief,nClu)
% Out. Clui, pval, th0, R, phconfint, mu k, phhist, phbin
% trains empty ones will not be filled up
% NB! all output is in radians, degrees suck!
% Clu - cluster number from the Clu vector given as an input. This is handy if you run it on 
% the data that has gaps in clusters e.g. unique(Clu) = [1 3 4 6] 
function Out = myPhaseOfTrain(Ph,Clu,varargin)
[Res,Periods,InOut,Brief,nClu] = DefaultArgs(varargin,{[],[],1,0,max(Clu)});

uClu = [1:nClu];%unique(Clu);
nClus = length(uClu);

if ~isempty(Res) & ~isempty(Periods)
  [Res ind] = SelectPeriods(Res,Periods,'d',InOut);
  Ph=Ph(ind);Clu=Clu(ind);
end


Out = struct;
for myi=1:nClu
  if sum(Clu==uClu(myi))<2
    
    Out.Clu(myi) = uClu(myi);
    Out.pval(myi) = 1;
    Out.R(myi) = 0;
    Out.th0(myi) = 0;
    Out.phconfint(myi,:) = [0 0];
    Out.mu(myi) = 0;
    Out.k(myi) = 0;
    Out.phhist(:,myi) = zeros(72,1);
    h2 = [-2*pi:pi/18:2*pi];
    Out.phbin = h2(1:end-1)+mean(diff(h2))/2;
    continue;
  end
  myph = Ph(Clu==uClu(myi));
  Out.Clu(myi) = uClu(myi);
  
  %% p-val mean phase and R
  [Out.pval(myi) th0 Out.R(myi)] = RayleighTest(myph);
  
  %% phase [0 2*pi]
  Out.th0(myi) = mod(th0,2*pi);
  
  %% more stats
  if ~Brief
    [cm, r] = CircConf(myph,0.01,200);
    Out.phconfint(myi,:) = mod(r,2*pi);
    [Out.mu(myi) Out.k(myi)] = VonMisesFit(myph);
  end
  
  %% histograms
  h2 = [-2*pi:pi/18:2*pi];
  h1 = histcI([myph-2*pi; myph],h2);
  
  %% make sure they are row vectors 
  if size(h1,1)>size(h1,2)
    h1 = h1';
  end
  
  %% output
  Out.phhist(:,myi) = h1;
  Out.phbin = h2(1:end-1)+mean(diff(h2))/2;  
  
end

return;