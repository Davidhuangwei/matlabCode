function states=GetStatesSRS(FileBase,varargin)
[overwrite,mode,dummy] = DefaultArgs(varargin,{0,[],[]});
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

  switch mode
    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   case 'Sebi'
    
    %% load segmant names, length and maze types
    C = LoadStringArray([FileBase '.srs']);
    L = load([FileBase '.srslen']);
    M = LoadStringArray([FileBase '.mazetype']);
    
    %% plot mazetype 
    for n=1:size(M,1) 
      fprintf([M{n,1} ' ' M{n,2} '\n'])
    end
    
    %% state intervals
    states.itv = [[1;cumsum(L(1:end-1))+1] cumsum(L)];
    
    %% plot sessions
    fprintf('\n')
    for n=1:length(C)
      fprintf([C{n} '   %d  %d\n'],states.itv(n,:))
    end
    
    %% identify states
    fprintf('\n')
    fprintf('lable states: [1=sleep 2=run-track 3=run-wheel 4=run-openfield 5=other] \n')
    fprintf('any combination of states gibe as ONE number! etc. run and wheel in one session is 23. \n')
    fprintf('\n')
    for n=1:length(C)
      states.ind(n) = input([C{n} ': ']);
    end
     
    %% states sampling rate
    states.rate = 1252;

    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
   case 'Kenji'
    
    EegRate = 1250;
    
    %% load session times
    A = load([FileBase '.time_new']);
        
    %% state intervals
    states.itv = [[1; round(A(1:end-1,2)*EegRate)+1] round(A(:,2)*EegRate)];
    
    %% load behavior
    load('DataKenjiBeh/Beh_time_ind.mat','-MAT') 
    b = find(strcmp(Beh(:,2),dummy));
    B = Beh(b,5)
    
    %% identify states
    fprintf('\n')
    fprintf('lable states: [1=sleep 2=run-track 3=run-wheel 4=run-openfield 5=other] \n')
    fprintf('any combination of states gibe as ONE number! e.g. run and wheel in one session is 23. \n')
    fprintf('\n')
    for n=1:size(A,1)
      states.ind(n) = input([B{n} ': ']);
    end
    
    %% states sampling rate
    states.rate = EegRate;
    
    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   case 'Eva'
    
    %% no concatinated sessions one recording file==on session
        
    %% state intervals
    Par = LoadPar([FileBase '.par']);
    states.itv = [1 FileLength([FileBase '.eeg'])/2/Par.nChannels];
    
    
    %% identify states
    fprintf('\n')
    fprintf('lable states: [1=sleep 2=run-track 3=run-wheel 4=run-openfield 5=other] \n')
    fprintf('any combination of states gibe as ONE number! etc. run and wheel in one session is 23. \n')
    fprintf('\n')
    
    states.ind = input([FileBase ': ']);
    
    %% states sampling rate
    states.rate = 1250;
   
    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   case 'Kamran'

    %% load bounderies
    Par = LoadPar([FileBase '.par']);
    b = FileLength([FileBase '.eeg'])/2/Par.nChannels;
    
    %find where track shortance using .whl file
    whl = GetWhl(FileBase);
    figure(37686);clf
    nn = size(whl.itv,2);
    title('mark beginning/end of states (BOF and EOF are edges)');
    for n=1:nn
      subplot(nn,1,n)
      plot(whl.itv(1:1:end,n),'.')
      axis tight
    end
	
    %% select state changes
    segs = 0;
    st = [];
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
	
    st = st/whl.rate*1252;
    states.itv = (reshape(sort([1 st st+1 b]),2,length(st)+1)');
       
    %% identify states
    fprintf('\n')
    fprintf('lable states: [1=sleep 2=run-track 3=run-wheel 4=run-openfield 5=other] \n')
    fprintf('any combination of states gibe as ONE number! etc. run and wheel in one session is 23. \n')
    fprintf('\n')
    
    for n=1:size(states.itv,1)
      states.ind(n) = input([FileBase ': ']);
    end
      
    %% states sampling rate
    states.rate = 1252;
  end
  
    
  %states.rate = input('States are in which sampling rate? ');
  states.info = {'1=sleep'; '2=run-track'; '3=run-wheel'; '4=run-openfield'; '5=other'};
  save([FileBase '.states'], 'states')
    
else
  load([FileBase '.states'],'-MAT')
end
   
return;

