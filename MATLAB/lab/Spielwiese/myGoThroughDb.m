%function Total = GoThroughDb(FunName,DbName, IfPause, IfSave, IfAccumulate, FunctionArgs)
% goes through Database DbName , and executes function FunName for each entry,
% saves result if IfSave, and 
function Total = myGoThroughDb(FunName,DbName, IfPause, IfSave, IfAccumulate, varargin)

  %IfSave = 0;
  %IfPause=0;
  %FunName = 'nternElc';
  %DbName = 'list.txt';
  %varargin = 1;


if (nargin<4 | isempty(IfSave) )
  IfSave = 0;
end
if (nargin<3 | isempty(IfPause))
  IfPause=0;
end


if iscell(DbName)
  db = DbName;
  DbName = num2str(length(db{1}));
else
  db = LoadStringArray(DbName);
end
nmydb = length(db);

RootDir = pwd;
AccCnt=1;
for ii=1:nmydb
  
  dn = db{ii};
  fprintf('%s \n', dn);
  if isempty(findstr(dn,'/')) 
    try
      cd(dn);
    catch
      continue;
    end
  else
    ind = findstr(dn,'/');
    cd(dn);
    dn(1:ind(end)-1);
    dn = dn(ind(end)+1:end);
  end
  
  if nargout>1 | IfSave | IfAccumulate
    if isempty(varargin)
      try
	tic;OutArgs = feval(FunName,dn);toc;
      catch
	lasterr
	fprintf('error\n');
      end
    else
      try
	tic;OutArgs = feval(FunName,dn,varargin(:));toc;
      catch
	lasterr
	%warning('error');
	fprintf('error');
      end
      
    end
    try
      if IfSave
	save([dn '.' FunName '.mat'],'OutArgs');
      end
    catch
      
      lasterr
      %warning('error');
      fprintf('error');
    end
    if IfAccumulate & exist('OutArgs','var')
      
      if isstruct(OutArgs)
	if ~exist('Total')
	  Total = struct([]);
	end
	Total=CopyStruct(OutArgs,Total,1);
	AccCnt=AccCnt+1;
      else
	if ~exist('Total')
	  Total = {};
	end
	Total{end+1}=OutArgs;
      end
      
    end
    clear OutArgs;
  else
    if 1
      try
	feval(FunName,dn,varargin);
      catch
	lasterr
	fprintf('did not work\n');
      end
    else
      feval(FunName,dn,varargin);
    end
  end
  
  
  if IfPause==1
    pause
  end
  if IfPause ==2
    waitforbuttonpress;
  end
  cd(RootDir);
  %     end
end
if IfAccumulate % & IfSave
  if nargout>1 | IfSave
    fn =[FunName '.' DbName '.gdb'];
    
    if FileExists([fn '.mat'])
      cnt=0;
      while FileExists([fn '.mat'])
	cnt=cnt+1;
	fn =[fn '.' num2str(cnt)];
      end
    end 
    fn=[fn '.mat'];
    save(fn,'Total');
    
  end
end
