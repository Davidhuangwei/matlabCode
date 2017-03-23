function EegFs = GetEegFs(FileBase)
%Par=  LoadPar([FileBase '.xml'],0);
Par = LoadXml([FileBase '.xml']);
EegFs = Par.lfpSampleRate;
%EegFs =1250;
return
%Par = LoadPar([FileBase '.par'],0);
Par = LoadXml([FileBase '.xml']);
if Par.SampleTime==50
    EegFs = 1250;
elseif Par.SampleTime==100
    EegFs = 1250; % for now
elseif Par.SampleTime==40 % Peter's crazy format
    EegFs = 500;
else
    EegFs = 1e6/Par.SampleTime/16;
end
