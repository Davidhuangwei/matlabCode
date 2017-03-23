function info=FileInfo(FileBase,varargin)
[overwrite] = DefaultArgs(varargin,{0});


if ~FileExists([FileBase '.info']) | overwrite
  
  if FileExists([FileBase '.info']) 
    load([FileBase '.info'],'-MAT');
  else
    
    %% recording rates
    Par = LoadPar(FileBase);
    
    %% fill in
    info.FileBase = Par.FileName;
    try 
      info.SampleRate = Par.SampleRate;
      info.EegRate = Par.lfpSampleRate;
    catch ME
      info.SampleRate = [];
      info.EegRate = [];
    end
      
    info.WhlRate = [];
    info.BehInd = {'1=sleep' '2=run-track' '3=run-openfield' '4=other'};
    info.BehNum = NaN;
    info.Wheel = NaN;
    info.comment = [];
  end
  
  info
  
  %keyboard
  
  %% sampling rates
  info.SampleRate = input(['What is the spike sample rate? [' num2str(info.SampleRate) ']? ']);
  info.EegRate = input(['What is the eeg sample rate? [' num2str(info.EegRate) ']? ']);
  info.WhlRate = input(['What is the sampling rate of the whl-file [' num2str(info.WhlRate) ']? ']);
  
  %% behavior
  for n=1:length(info.BehInd); fprintf([info.BehInd{n} ' ']); end; fprintf('\n');
  info.BehNum = input(['Which behavior is present in this file [' num2str(info.BehNum) ']? ']);
  
  info.BehInd = {'1=sleep' '2=run-track' '3=run-openfield' '4=other'};
  
  info.Wheel = input(['Is there any Wheel running [0/1]? ']);
  
  %% comment
  info.comment = input(['Do you want to leave a comment [' info.comment ']? ']);

  save([FileBase '.info'],'info')
else
  load([FileBase '.info'],'-MAT');
end

return;
