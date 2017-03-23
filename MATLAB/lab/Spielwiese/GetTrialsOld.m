function trial = GetTrialsOld(FileBase,whl,varargin);
[overwrite,UseEvt,UseItv] = DefaultArgs(varargin,{0,0,[1 size(whl.itv,1)]});
%% in: 
%%     whl - nx2 
%% 
%% out:
%%     trial.itv - [beginning end] of intervals in samples
%%     trial.??? - direction - input.
%%
if ~FileExists([FileBase '.trials']) | overwrite

  if UseEvt
    trial = FindTrials(FileBase,varargin);
  else
    figure


    for segs = 1:size(UseItv,1)
    
      %%keyboard
      if ~FileExists([FileBase '.trial.info']) | overwrite
	fprintf('(1) Cut area (in x). \n');
	fprintf('(2) Mark left and right bounderies (both in x and y). \n');
	fprintf('(3) Mark EXCLUDED area. \n');
	fprintf('(4) Mark square around cut. \n');
	fprintf('(5) Open field. No trials will be selected. \n');
	fprintf('(6) Mark INCLUDED area. \n');
	CutPoints = input('How to select trials: ');
	save([FileBase '.trial.info'],'CutPoints');
      end
    
      if CutPoints == 5
	trial = [];
	return;
      end
    
      goodwhl = whl.ctr(UseItv(segs,1):UseItv(segs,2),:);
      ggouttr = FindTrialsNoEvt(FileBase,goodwhl,CutPoints);
      
      if CutPoints == 4
	trial(segs).itv = ggouttr;
      else
	trinx = CheckTrials(whl.ctr,ggouttr);
	trial(segs).itv = ggouttr(trinx,:);
      end
      trial(segs).dir = ones(size(trial(segs).itv,1),1);
      
      ask = input('Trial-sortin by hand [1/0]? ');
      trdir = 1;
      if ~ask 
	getdir = input('trial type (e.g. right, left,...): ','s');
	while ~isempty(getdir)
	  trdir = trdir +1;
	  fprintf(['Trial direction number: ' num2str(trdir)]);
	  foo = [];
	  [foo fooix] = FindDir(whl.ctr,trial(segs).itv);
	  bah = CheckTrials(whl.ctr,foo);
	  
	  trial = setfield(trial,getdir,foo(bah,:));
	  
	  foonum = find(fooix);
	  trial(segs).dir(foonum(bah)) = trdir;
	  getdir = input('trial type (e.g. right, left,...): ','s');
	end
      else
	%keyboard
	getdir = input('trial type (e.g. right, left,...): ','s');
	chosen = ones(length(trial(segs).itv),1);
	while ~isempty(getdir)
	  trdir = trdir +1;
	  
	  idx = find(chosen);
	  bah = CheckTrials(whl.ctr,trial(segs).itv(idx,:));
	  
	  chosen(idx(bah)) = 0; 
	  
	  trial = setfield(trial,getdir,trial(segs).itv(bah,:));
	  trial(segs).dir(idx(bah)) = trdir;
	  
	  getdir = input('trial type (e.g. right, left,...): ','s');
	end
      end
    end
    
    %% Get Mean Trial
    trial = GetMeanTrial(FileBase,trial,whl,overwrite);
    if ~trial(segs).OneMeanTrial
      trial = SyncMeanTrials(FileBase,trial,whl,overwrite);
    else
      for n=unique(trial(segs).dir)'
	if n>1
	  trial(segs).mean(n).sclin(:,:) = trial(segs).mean(n).lin(:,:);
	else
	  continue;
	end
      end
    end
    
  end
  
  save([FileBase '.trials'],'trial');
else
  load([FileBase '.trials'],'-MAT');
end

return;
