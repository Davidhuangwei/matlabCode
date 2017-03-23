function groupanalpst (tag,finalfile)
%groupanalpst('*','test')

files=dir(['Analyze ' tag '.mat']);

for lp=1:size(files,1);
    load ([files(lp).name],'file','dataout')
    templength(lp,1)=dataout.mobility.totalmobility+dataout.mobility.totalimmobility;
    clear file dataout
end

cumulativedist=ones(max(templength),size(files,1));
for lp=1:size(files,1)
    disp ([files(lp).name ' is being processed please wait '])
    load ([files(lp).name],'file','dataout')

    latency3sec(lp,1)=dataout.immobility.latency.sec3;
    latency4sec(lp,1)=dataout.immobility.latency.sec4;
    latency5sec(lp,1)=dataout.immobility.latency.sec5;
    latency6sec(lp,1)=dataout.immobility.latency.sec6;
    latency7sec(lp,1)=dataout.immobility.latency.sec7;
    
    mobility(lp,1) =dataout.mobility.totalmobility;
    immobility(lp,1) =dataout.mobility.totalimmobility;
    percentmobility (lp,1)=dataout.mobility.percentmobility;
    
    meanmobilityduration(lp,1)=mean(dataout.mobility.rawlengths);
    meanimmobilityduration(lp,1)=mean(dataout.immobility.rawlengths);
    
    distancetravelled(lp,1)=dataout.distance.all;
    cumulativedist([1:length(dataout.distance.cumulative_normalized)],lp)=dataout.distance.cumulative_normalized;
    clear file dataout 
end

save (['GROUP_PST ' finalfile])