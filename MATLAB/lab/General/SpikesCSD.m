%function SpikesCSD(filename,Electrode,Clusters, ChOrder, csdType, AutoArr, SpikeSamples,spkext)
function SpikesCSD(filename,Electrode,varargin)

Clu=load([filename '.clu.' num2str(Electrode)]); 
NumClu = Clu(1); Clu=Clu(2:end);
Par = LoadPar1([filename '.par.' num2str(Electrode)]);
[Clusters, ChOrder, csdType, AutoArr, SpikeSamples, spkext] = ...
    DefaultArgs(varargin,{[2:NumClu], [1:Par.nSelectedChannels], 'c', 0, 32, 'spk'});
csdstep =1;
%save([filename '.spk.' num2str(Electrode) '.old']);
figure
cnt=0;
MeanMySpk = AvSpk(filename);
MeanMySpk = MeanMySpk{Electrode};
if AutoArr==1
    spkcsd = -diff(MeanMySpk(ChOrder,:,Clusters),2,1);
    [maxsink sinkdepth] = min(min(spkcsd,[],2),[],1);
    [aa NewOrder] = sort(abs(squeeze(sinkdepth)));
    Clusters = Clusters(NewOrder);
end
for c=Clusters
    cnt=cnt+1;
    spk = squeeze(MeanMySpk(ChOrder,:,c));
    subplot(1,length(Clusters),cnt);
    title(num2str(c));
    hold on
    ax = get(gca,'Position');
    set(gca,'Position',[ax(1) (csdstep+1)/length(ChOrder) ax(3) (length(ChOrder)-2*csdstep-1)/length(ChOrder)]);
    if ~strcmp(csdType,'l')
        CurSrcDns(spk',[1:SpikeSamples]/20,csdType,[],[],20000,1);

        hold on
        PlotManyCh(spk,[1:SpikeSamples]/20,20000,1,'k',0,2*csdstep/(length(ChOrder)-2*csdstep));
    else
        [spkcsd, newt] = CurSrcDns(spk',[],csdType,[],[],20000,1);   
%        keyboard
        PlotManyCh(spkcsd,newt,20000,0.5,'k',0,0);
    end
%     PlotManyChOld(MeanMySpk{c}(2:end-1,:)');
end
ForAllSubplots('axis off');
