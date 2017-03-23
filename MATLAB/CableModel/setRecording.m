function RP=setRecording(NeuronParams,Rcenter)
% RP=setRecording(NeuronParams,Rcenter)
% if length(Rcenter)<3
mindist=1;
zlims=[max(NeuronParams.compartmentZPositionMat(:));min(NeuronParams.compartmentZPositionMat(:))];
RP.RLocZ=round(zlims(1)):(-25):round(zlims(2));
RP.RLocX=Rcenter(1);RP.RLocY=Rcenter(2);
RP.idist=1./max(sqrt(bsxfun(@plus,bsxfun(@minus,NeuronParams.LocZ(:),RP.RLocZ).^2,...
    (NeuronParams.LocX(:)-RP.RLocX).^2+(NeuronParams.LocY(:)-RP.RLocY).^2)),mindist)/4/pi/.3;
RP.RecordLength=10;% min
RP.SamplingRate=.02;% ms
RP.WriteLength=5*10^3;% samples.
RP.nch=length(RP.RLocZ);