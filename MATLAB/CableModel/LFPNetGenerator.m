% function LFPNetGenerator
% function LFPNetGenerator generates a HP neuron network. 
%% parameters
% here I assume a network with n parallial HP pyrs, the electrod is right
% in the middle of all the neurons.
FileBase='';
Ncell=6;
% the position center of the cell body is given here. 
%% distribute pyr neuron cell body in a plane.
rxy=200;% um [lx, ly] or rxy
lz=40;% um
Dens=.05;%(cells)/um2 64000*10^-9;% cells/um3 40^3
if length(rxy)>1
    nx=round(rxy(1)*Dens);%*lz
    ny=round(rxy(2)*Dens);%*lz
    celln=nx*ny;
    oD=[reshape(repmat(linspace(0,1,nx),ny,1)',[],1),...
        reshape(repmat(linspace(0,1,ny),nx,1),[],1),...
        zeros(celln,1)];
    pct=bsxfun(@times, [rxy, lz],oD+bsxfun(@times,[2/3*2/nx*[1,1],1],rand(celln,3)-.5) );%linspace(0,2*pi,1+Ncell);uniform:[-1/3, 1/3]
    
else
    nx=round(2*rxy*Dens);% lows of cells
    ny=nx;% coloumns of cells
    oD=repmat(linspace(-1,1,nx),ny,1);
    oD=[reshape(oD',[],1), oD(:), zeros(nx*ny,1)];
    oD(sum(oD.^2,2)>1,:)=[];
    celln=size(oD,1);
    pct=bsxfun(@times, [rxy, rxy, lz], oD+bsxfun(@times,[2/3*4/nx*[1,1],1],rand(celln,3)-.5));%linspace(0,2*pi,1+Ncell);
end
figure(1);plot3(pct(:,1),pct(:,2),pct(:,3),'k.')
grid on
%%
stp=.01;
[NeuronParams,NA]=setMophology(celln,'sCable',stp);% NA is the pyr object to update.
% I still need to think of how to set the loop by interneurons. 
% indeed can probably just have 2 neuron classes.
%% set synaptic connections.
nxyz=[200,20];
Dens=[.05; .05];
CS.Dens=Dens;
CS.nxyz=nxyz;
SourceC=[-200; -400];
CS.SourceC=SourceC;
nSource=length(SourceC);
CS.nSource=nSource;
CS=[];
CS.Distr=cell(nSource,1);
colors={'b','r','g'};
for k=1:nSource
CS.Distr{k}=bsxfun(@plus,setInputs(nxyz,Dens(k)),[0 0 SourceC(k)]);% center z=0.  center of synaptic arbors.
figure(1);hold on; plot3(CS.Distr{k}(:,1),CS.Distr{k}(:,2),CS.Distr{k}(:,3),[colors{k},'.'])
end
% figure;plot3(CS(:,1),CS(:,2),CS(:,3),'.')
grid on
isrot=1;
NeuronParams=rotateCell(NeuronParams,pct,isrot);
figure(1)
plot3(NeuronParams.LocX',NeuronParams.LocY',NeuronParams.LocZ','k:')
%%
CS.r=1./Dens;
CS.weight=100*[1; 1];
CS.type=[1,1];
CS.boundry=[30, 30];
CS.nSource=2;
CN=setConnection(CS, NeuronParams);
NeuronParams=bentCell(NeuronParams,0,[]);
ncell=celln;
for k=1:CS.nSource
CS.celln(k)=size(CS.Distr{k},1);
end
%% set Recording parameter
Rcenter=[0 0];
RP=setRecording(NeuronParams,Rcenter);
%% Now assume that you have the input neuron activity, here compute synaptic activity. 
if exist([FileBase, '.input.mat'],'file')
    InC=loadSimu([FileBase, '.input.mat'],ncell);% Binary for each input neuron, or firing rate
else
    nt=5000/stp;
    InputFun=sin(2*pi/250*stp*bsxfun(@plus,1:nt,[0,30/stp]'));
    InC=cell(2,1);
    for k=1:2
    InC{k}=bsxfun(@le,rand(CS.celln(k),nt),InputFun(k,:));
    end
    save([FileBase, '.input.mat'],'InC')
end
% Inputs=SynapticActivity(InC,CN);
% Inputsig=(channelstype,NeuronParams,ncell,dt);
%% simulation 
nt=RP.RecordLength*10^3/RP.SamplingRate;% currently only record by chuncks. 
nch=32;
Periods=1:5000:(nt-5000);
nP=length(Periods);
for k=1:nP
    tt=Periods(k):min(Periods(k)+4999,nt);
    Inputs=SynapticActivity(InC,CN,CS,tt);
    Vm=zeros(length(tt),nch);
%     gm=zeros(nch,length(tt));
    INPUTS=zeros(nch,length(tt),3);
    for kk=1:3
        INPUTS(:,:,kk)=RP.idist'*sq(Inputs(:,:,kk));
    end
    for kk=1:length(tt)
        NA=updateNeuron(NA,sq(Inputs(:,kk,1)),sq(Inputs(:,kk,2)),sq(Inputs(:,kk,3)));
        Vm(:,kk)=NA.Vm*RP.idist;
        %IN.Gglu(:,k),IN.GgabaA(:,k), IN.GgabaB(:,k)
    end
    sname=sprintf('%s.Recording.%d.mat',FileBase,k);
    save(sname,'INPUTS','Vm')
end

%%  former drafts
Cells=BasicMophology; 
% say... I just model 2 inputs... let's move the place of inputs to se the
% performance... that would be what those paper gay do...

Regions=@(x)([exp(-(x-50).^2/10^2/2),exp(-(x-80).^2/10^2/2)]);% [centers, width] symatric in the x-y plane. 
[Syn, Cls]=GenerateConnectionM(Cells,Regions);
% indeed i can try to see how the sequence and the spatial location of
% synapses related to produce certain activity... can do later...


% the simulation use forward eular method.