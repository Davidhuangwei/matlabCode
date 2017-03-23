function elc = ElcRegion(FileBase,varargin)
[overwrite] = DefaultArgs(varargin,{0});
%% 
%% 
%% adds to the structure elc:
%% elc.regionind: string array e.g.: {'1=CA1'  '2=CA3'  '3=EC'  '4=CX'  '5=other'}
%% elc.region: vector of identity for each electrode (tretrode) e.g.: [3 3 3 3 1 1 1 1]
%%

if ~FileExists([FileBase '.elc'])
  elc = InternElc(FileBase);
else
  load([FileBase '.elc'],'-MAT');
end

if ~isfield(elc,'region') | overwrite
  
  Par = LoadPar([FileBase '.par']);
  
  elc.regionind = {'1=CA1'  '2=CA3'  '3=EC'  '4=CX'  '5=other'};
  fprintf('1=CA1 2=CA3 3=EC 4=CX 5=other\n');
  
  for n=1:Par.nElecGps
    choose = input(['In which area is electrode ' num2str(n) ' ? ']);
    if isempty(choose)
      break
    end
    elc.region(n) = choose;
  end
  
  save([FileBase '.elc'],'elc');
end


return;