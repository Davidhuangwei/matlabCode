function NeuronAct=initiatChannels(channelstype,NeuronParams,ncell)
% NeuronAct=initiatChannels(channelstype,NeuronParams)
% there is 12 type of channels.
% not used anymore... 
nch=length(channelstype);
ncomp=NeuronParams.numCompartments;
NeuronAct.vm=zeros(ncell,ncomp);
NeuronAct.Ia=zeros(ncell,ncomp);
NeuronAct.Im=zeros(ncell,ncomp);
channames={'sdNa';...% Somato-dendritic Na+ channel (Na_7)
    'aNa';...% Axonic Na+ channel (NaA_2)
    'wCa';...% High thereshold Ca++ channel (Ca_W)
    'tCa';...% Low thereshold Ca++ channel (CaT_3)
    'aKp';...% A type K+ channel, proximal (K_A_11)
    'aKd';...% A type K+ channel, distal (K_A_18)
    'drK';...% DR type K+ channel (K_DR_2)
    'drKa';...% DR type K+ channel, axonic (K_DRA_4)
    'cK';...% C type K+ channel (K_C_1)
    'mK';...% M type K+ channel (K_M_4)
    'AHPK';...% AHP type K+ channel (K_AHP_Wtn)
    'Ih';...%  h type channel (Ih_3)
    };
for k=1:nch
    channame=channames{k};
    NeuronParams.fchan{k}=str2func(channame);
    NeuronParams.g{k}(:,:)=NeuronParams.fchan{k}(0);
end