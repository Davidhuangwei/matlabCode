function states=GetStates(FileBase,varargin)
[list,overwrite] = DefaultArgs(varargin,{[],0});
% states=GetStates(FileBase);
% 
% select behavioral states [1=sleep; 2=run-track; 3=run-openfield]
% 
% option 1: from existing eeg-segments, corresponding to individual recording sessions
% option 2: "put it in by hand" - not well done yet....
%
% output: states.itv
%         states.ind
%


if ~FileExists([FileBase '.states']) | overwrite

  if ~isempty(list)
  
    Par = LoadPar([FileBase '.par']);
    List = LoadStringArray(list);
    
    for i=1:length(List)
      
      %% states: from Eeg segments
      nfilebase = [List{i} '/' List{i}]
      LL = FileLength([nfilebase '.eeg'])/2/Par.nChannels;
      
      st(i) = LL;
      states.ind(i) = input('what state is this [1=sleep; 2=run-track; 3=run-openfield]? ')
      
    end
    sst = cumsum(st);
    
    states.itv(1:i,1) = [1; sst(1:i-1)'+1];
    states.itv(1:i,2) = sst';
    
    states.info = {'1=sleep'; '2=run-track'; '3=run-openfield'};
    states.rate = input('States are in which sampling rate? ');
    
    save([FileBase '.states'], 'states')
  
  else
    
    fprintf('list is empty....\n');
    
    ask = input('Are there more than one states [0/1]? ');
    
    if ask
        
      ask = input('Do you want to use Eeg to select states [1]? or only whl-file [0]? ');
      
      if ask
	Eeg = GetEEG(FileBase);
	whl = GetWhl(FileBase);
	
	load([FileBase '.elc'],'-MAT');
	
	fprintf(['mark an even number of bounderies. If there are even' ...
		 ' number of states, the program will fill in the first']);
	
	CheckEegStates(FileBase,'tmp',{[1:size(whl.itv,1)]/whl.rate,[],whl.itv(:,1)','plot'},[1 100],elc.theta,1);
	
	go = input('press any key to continue: ');
	
	st1 = load([FileBase '.sts.tmp']);
	st1(:,2) = st1(:,2)+1; 
	st2 = reshape(st1',1,2*size(st1,1));
	
	if st1(1,1) < 12500 | (length(Eeg)-st1(end,2)) < 12500
	  
	  if st1(1,1) < 12500 & (length(Eeg)-st1(end,2)) > 12500
	    st2(1) = 1;
	    st3(:,1) = st2';
	    st3(:,2) = [st2(2:end)-1 length(Eeg)]';
	    
	  elseif  (length(Eeg)-st1(end,2)) < 12500 & st1(1,1) > 12500
	    st3(:,1) = [1 st2(1:end-1)]';
	    st3(:,2) = st2'-1;
	    st3(end,2) = length(Eeg);
	    
	  elseif st1(1,1) < 12500 & (length(Eeg)-st1(end,2)) < 12500
	    st3(:,1) = st2(1:end-1)';
	    st3(:,2) = st2(2:end)'-1;
	    st3(1,1) = 1;
	    st3(end,2) = length(Eeg);
	  end
	
	else
	  st3(:,1) = [0 st2]';
	  st3(:,2) = [st2-1 length(Eeg)]';
	end
      
      
      else
	
	%% mark states using only whl file.
	
	whl = GetWhl(FileBase);
	figure(37686)
	nn = size(whl.itv,2);
	title('mark beginning and end of states (BOF and EOF are edges)');
	for n=1:nn
	  subplot(nn,1,n)
	  plot(whl.itv(1:1:end,n),'.')
	  axis tight
	end
	
	%% select state changes
	segs = 0;
	while 1
	  fprintf('\n lb: mark point; mb: break; rb: delete last line \n');
	  [dumx dumy button]=PointInput(1);
	  
	  switch button(1)
	   case 1 % left button
	    
	    Xzoom
	    
	    segs = segs+1;
	    [st(segs) y] = ginput(1);
	    
	    for n=1:nn
	      subplot(nn,1,n)
	      h(segs,n)=Lines(st(segs),[],'r','-',2);
	    end
	    
	   case 2 % middle button
	    break;
	   
	   case 3 %right button
	    delete(h(segs,:));
	    st(segs) = [];
	    segs = segs-1;
	    
	  end
	end
	
	st3 = reshape(sort([1 st st+1 size(whl.itv,1)]),2,length(st)+1)';
	
      end
      
	
      for i=1:size(st3,1)
	states.ind(i) = input('what state is this [1=sleep; 2=run-track; 3=run-openfield; 4=other]? ');
      end
    
      states.itv = st3;
      states.info = {'1=sleep'; '2=run-track'; '3=run-openfield'; '4=other'};
      states.rate = input('States are in which sampling rate? ');
      
    else
      Eeg = GetEEG(FileBase);
      states.itv = [1 length(Eeg)];
      states.rate = input('States are in which sampling rate? ');
      states.info = {'1=sleep'; '2=run-track'; '3=run-openfield'; '4=other'};
      states.ind = input('what state is this [1=sleep; 2=run-track; 3=run-openfield; 4=other]? ');
    end
    
    save([FileBase '.states'], 'states')
    
  end
  
else
  
  load([FileBase '.states'],'-MAT')
  
end
   
return;