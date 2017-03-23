function elc = RecordingSite(FileBase,varargin)
[overwrite] = DefaultArgs(varargin,{0}); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% specify recording sites
%%
%% will be added to the elc structure:
%%    elc.region :    specifies the recording site for each electrode
%%    elc.regionind : specifies which number corresponds to which region
%%    
fprintf('  specify recording sites... \n');
if ~FileExists([FileBase '.elc'])
  elc = InternElc(FileBase);
  %%error('no channel for theta phase detection is specified.');
else
  load([FileBase '.elc'],'-MAT');
end

if ~isfield(elc,'region') | overwrite
  Par = LoadPar([FileBase '.par']);
  system(['neuroscope ' FileBase '.eeg'])
  
  elc.regionind = {'1=CA1' '2=CA3' '3=EC' '4=CX' '5=other'};
  for n=1:Par.nElecGps
    elc.regionind
    ask = input(['electrode ' num2str(n) ' is in wich region? ']);
    if isempty(ask)
      break
    end
    elc.region(n) = ask;
     
  end
  save([FileBase '.elc'],'elc');
end


return;

