function [NeuronParams,NA]=setMophology2(ncell,stp)
% GenM=str2func(ModelFun);% BLTmorphomodel or like sCable model.
load('~/data/NeuronModel/Model2.mat');
NeuronParams=Neuron2;%GenM();
NeuronParams.compartmentDiameterArr=NeuronParams.compartmentDiameterArr*10^-4;
NeuronParams.compartmentLengthArr=NeuronParams.compartmentLengthArr*10^-4;
NeuronParams.A=pi*NeuronParams.compartmentDiameterArr.*NeuronParams.compartmentLengthArr;% cm^2
NeuronParams.A(1)=pi*NeuronParams.compartmentDiameterArr(1).^2;% cm^2
NeuronParams.ds=abs(NeuronParams.compartmentZPositionMat(:,1));
NeuronParams.ds=repmat(NeuronParams.ds(:)',ncell,1);
NeuronParams.A=repmat(NeuronParams.A(:)',ncell,1);
NeuronParams.Rm = 50000*(0.15 + 0.85./(1.0 + exp((NeuronParams.ds-300)/50)))./NeuronParams.A/10^9 ;%  Ω cm2
NeuronParams.Ra = 150.*repmat(NeuronParams.compartmentLengthArr(:)',ncell,1)./(repmat(NeuronParams.compartmentDiameterArr(:)',ncell,1).^2/4*pi)/10^9 ;%  Ω cm 
% NeuronParams.Ra(:,1)=150*repmat(NeuronParams.compartmentDiameterArr(1),ncell,1)./(repmat(NeuronParams.compartmentDiameterArr(1),ncell,1).^2/4*pi)/1000;%  Ω cm 
NeuronParams.Cm =NeuronParams.A* 10^6;% 10^-3.*  µF/cm2
% NeuronParams.Cm(:,1)=18*ones(ncell,1);%10^-3.*
NeuronParams.dt=stp;% ms
NeuronParams.E_leak = -70;% mV
%% Add channels on compartments.
channelstype=[1,10];%[1];%:3[1:3];%21:3,10,10];
NeuronParams.compartmentDiameterArr=NeuronParams.compartmentDiameterArr/10^-4;
NeuronParams.compartmentLengthArr=NeuronParams.compartmentLengthArr/10^-4;
NA=NeuronAct(channelstype,NeuronParams,ncell,NeuronParams.dt);
% ---------------------- available channels ---------------------- %
%  channames={'sdNa';...% Somato-dendritic Na+ channel (Na_7)       1
%                 %'aNa';...% Axonic Na+ channel (NaA_2)
%                 'wCa';...% High thereshold Ca++ channel (Ca_W)    2
%                 'tCa';...% Low thereshold Ca++ channel (CaT_3)    3
%                 'aKp';...% A type K+ channel, proximal (K_A_11)   4
%                 'aKd';...% A type K+ channel, distal (K_A_18)     5
%                 'drK';...% DR type K+ channel (K_DR_2)            6
%                 %'drKa';...% DR type K+ channel, axonic (K_DRA_4)
%                 'cK';...% C type K+ channel (K_C_1)               7
%                 'mK';...% M type K+ channel (K_M_4)               8
%                 'AHPK';...% AHP type K+ channel (K_AHP_Wtn)       9
%                 'Ih';...%  h type channel (Ih_3)                  10
%                 };
