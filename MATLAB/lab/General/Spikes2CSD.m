%function SpikesCSD(filename,Electrode,CSDstep, ChOrder)
function SpikesCSD(filename,Electrode, varargin)

Clu=load([filename '.clu.' num2str(Electrode)]); 
NumClu = Clu(1);
Par = LoadPar1([filename '.par.' num2str(Electrode)]);
[CSDstep, ChOrder] = DefaultArgs(varargin,{[2:NumClu], [1:Par.nSelectedChannels]});

Spk = LoadSpk([filename '.spk.' num2str(Electrode)],Par.nSelectedChannels);
SamplesInSpk = 32; 
Clu=Clu(2:end);
MySpikes ={};
for c=Clusters
    MySpkId = find(Clu==c);
    MySpikes{c} = Spk(:,:,MySpkId);
end
%save([filename '.spk.' num2str(Electrode) '.old']);
MeanMySpk={};
figure
global CSDSTEP
CSDSTEP=1;
cnt=0;

for c=Clusters
    cnt=cnt+1;
    MeanMySpk{c} = squeeze(mean(MySpikes{c},3)); %depth x samples
    MeanMySpk{c} = MeanMySpk{c}(ChOrder,:);
    subplot(1,length(Clusters),cnt);
    ax = get(gca,'Position');
    set(gca,'Position',[ax(1) (CSDSTEP+1)/length(ChOrder) ax(3) (length(ChOrder)-2*CSDSTEP-1)/length(ChOrder)]);
    CurSrcDns(MeanMySpk{c}',[],'c',[],[],20000);
    hold on
    
    PlotManyCh(MeanMySpk{c},[1:32]/20,20000,1,'k',0,2*CSDSTEP/(length(ChOrder)-2*CSDSTEP));
%     PlotManyChOld(MeanMySpk{c}(2:end-1,:)');
end

