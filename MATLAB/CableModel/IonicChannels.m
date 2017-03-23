% classdef IonicChannels < handle
%  input unit should be used in the mA and mV scale. Ca is in uM. output of
%  current should be in mA.

Vm=NP.Vm;% mV
ENa=50;% mV
EK=-90;% mV
%% ---------------Somato-dendritic Na+ channel (Na_7)----------------- %%
function sdNa
gNa=500/100^2;% S/cm2
INa = gNa.*m.^3.*h.*(Vm-ENa);% 
minf = 1./(1+exp((25+Vm)/-5));
taum = .020+.22/(exp((Vm+55)/13)+exp((Vm+55)/-80));% ms
dm=dt./taum.*(minf-m);
hinf = 1./(1+exp((50+Vm)/4));
tauh = 0.6+8*exp((Vm+45)/13)./(1+exp((Vm+45)/5.5));
dh=dt./tauh.*(hinf-h);
% Density: 500 S/m2 in soma and 500 S/m2 all over the apical and basal tree
end


%% ---------------------Axonic Na+ channel (NaA_2)--------------------- %%
function aNa
gNa=((NP.Level==1)*666+(NP.Level>1)*1000)/100^2;% S/cm2
INa = gNa.*m.^3.*h.*(Vm-ENa);
minf = 1/(1+exp((32+Vm)/-4.2));
taum = .020+.220./(exp((Vm+62)/13)+exp((Vm+62)/-80));
dm=dt./taum.*(minf-m);
hinf = 1./(1+exp((50+Vm)/4));
tauh = .2+8*exp((Vm+45)/13)/(1+exp((Vm+45)/5.5));
dh=dt./tauh.*(hinf-h);
% Density: 666 S/m2 in the nearest compartment to soma and 1000 S/m2 in the unmielinized compartments thereof
end


%% ----------------High thereshold Ca++ channel (Ca_W)----------------- %%
function wCa
gCa=(NP.ds<=100).*30/100^2;% S/cm2
ICa = gCa.*s.^2.*r.*(Vm-ECa);
alphas = -160*(Vm+26)./(exp((Vm+26)/-4.5)-1);
betas = 40*(Vm+12)./(exp((Vm+12)/10)-1);
ds=alphas.*(1-s)+betas.*s;
alphar = 2./exp((Vm+94)/10);
betar = 8./(exp((Vm-68)/-27)+1);
dr=alphar.*(1-r)+betar.*r;
% Density (ds = distance to soma in µm):
% Soma and basal tree: 30 S/m2
% Apical tree:
%     If ds < 100, Dens = 30 S/m2
%     If ds > 100, Dens = 0.0 S/m2
end


%% ----------------Low thereshold Ca++ channel (CaT_3)----------------- %%
function tCa(varargin)
gCa=min((NP.ds>100).*(30 + 25*(NP.ds/100-1)),100)/100^2;% S/cm2
ICa = gCa.*s.^2.*r.*(Vm-ECa);
sinf = 1./(1+exp((54+Vm)/-5));
                taus = .204+.333/(exp((Vm+15.8)/18.2)+exp((Vm+131)/-16.7));
% taus = 204e-6+333e-6/(exp((Vm+0.0158)/0.0182)+exp((Vm+0.131)/-0.0167));
ds=dt./taus.*(sinf-s);
rinf = 1/(1+exp((80+Vm)/4));
if(Vm<= -81)
  taur = .333*exp((Vm+466)/66.6);
else
  taur = 9.32 + .333*exp((Vm+21)/-10.5);
end
dr=dt./taur.*(rinf-r);
end
% Density (ds = distance to soma in µm):
% Apical tree:
%     If ds < 100, Dens = 0.0 S/m2
%     If ds > 100, Dens = 30 + 25(ds-100)/100 S/m2
%     If Dens > 100, Dens = 100 S/m2




%% ----------------A type K+ channel, proximal (K_A_11)----------------- %%
function aKp
gKA=(NP.ds<100).*((NP.Z>0).*(20+2*NP.ds)+(NP.Z<0).*(20+1.7*NP.ds))/100^2;
IKA = gKA.*n.*l.*(Vm-EK);
ninf = 1./(1+exp((12+Vm)/-8.5));
taun = .080;
dn=dt./taun.*(ninf-n);
linf = 1./(1+exp((56+Vm)/7));
taul = max(.26*(Vm+50),2);
dl=dt./taul.*(linf-l);
end
% Density (ds = distance to soma in µm):
% Soma: 20 S/m2
% Apical tree:
%     If ds < 100, Dens = 20 + 200(ds/100) S/m2
%     If ds > 100, Dens = 0.0 S/m2
% Basal tree:
%     If ds < 100, Dens = 20 + 170(ds/100) S/m2
%     If ds > 100, Dens = 0.0 S/m2
    
    
    

%% ---------------- A type K+ channel, distal (K_A_18)----------------- %%
function aKd
gKA=min((NP.ds>100).*((NP.Z>0).*(20+2*NP.ds)+(NP.Z<0).*(20+1.7*NP.ds)),600)/100^2;
IKA = gKA.*n.*l.*(Vm-EK);
ninf = 10.^(Vm<= -65)./(1+exp((24+Vm)/-7));
taun = .080;
dn=dt./taun.*(ninf-n);
linf = 1./(1+exp((56+Vm)/7));
taul = max(0.26*(Vm+50),2);
dl=dt./taul.*(linf-l);
end
% Density (ds = distance to soma in µm):
% Apical tree:
%     If ds > 100, Dens = 20 + 200(ds/100) S/m2
%     If ds < 100, Dens = 0.0 S/m2
%     If Dens > 600, Dens = 600 S/m2
% Basal tree:
%     If ds > 100, Dens = 20 + 170(ds/100) S/m2
%     If ds < 100, Dens = 0.0 S/m2
%     If Dens > 600, Dens = 600 S/m2




%% ---------------------DR type K+ channel (K_DR_2)--------------------- %%
function drK
gKDR=40/100^2;% S/cm2
IKDR = gKDR.*n.*(Vm-EK);
ninf = 1./(1+exp((5-Vm)/11));
taun = 1.2;
dn=dt./taun.*(ninf-n);
end
% Density: 40 S/m2 in soma and all over the apical and basal tree


%% ----------------DR type K+ channel, axonic (K_DRA_4)----------------- %%
function drKa
gKDR=((NP.Level==1)*200+(NP.Level>1)*300)/100^2;% S/cm2
IKDR = gKDR.*n.*(Vm-EK);
ninf = 1./(1+exp((2+Vm)/-12));
taun = 1.6./(exp((Vm+65)/80)+exp((Vm+65)/-14));
dn=dt./taun.*(ninf-n);
end
% Density: 200 S/m2 in the nearest compartment to soma and 300 S/m2 in the unmielinized compartments thereof





%% --------------------- C type K+ channel (K_C_1)---------------------- %%
function cK
gKC=((NP.Z>0 & NP.ds<225).*(720+3.2*NP.ds)+(NP.Z==0)*720+(NP.Z<0 & NP.ds<100).*(720+7*NP.ds))/100^2;
IKC = gKC.*c.^2.*d.*(Vm-EK);
Vshift = 40.*log(Cai)-0.105;
alphac = -7.7*(Vm+Vshift+103)/1000./(exp((Vm+Vshift+103)/-12)-1);
betac = 1.7./exp((Vm+Vshift+237)/30);
dc=alphac.*(1-c)+betac.*c;
tauc = 1.1;%?
alphad = 1./exp((Vm+79)/10);
betad = 4./(exp((Vm-82)/-27)+1);
dd=alphad.*(1-d)+betad.*d;
end
% Density (ds = distance to soma in µm):
% Soma: 720 S/m2
% Apical tree:
%     If ds < 225, Dens = 720 - 320(ds/100) S/m2
%     If ds > 225, Dens = 0.0 S/m2
% Basal tree:
%     If ds < 100, Dens = 720 - 700(ds/100) S/m2
%     If ds > 100, Dens = 0.0 S/m2



%% --------------------- M type K+ channel (K_M_4)---------------------- %%
function mK
gKM=((NP.Z>0).*5+(NP.Z==0)*10+(NP.Z<0).*4.5)/100^2;
IKM = gKM.*u.*(Vm-EK);
uinf = 1./(1+exp((40+Vm)/-8.5));
tauu = 0.9+20*exp((Vm+38)/25)./(1+exp((Vm+38)/7));
du=dt./tauu.*(uinf-u);
end
% Density: 5 S/m2 in apical tree, 10 S/m2 in soma and 4.5 S/m2 in basal tree



%% -------------------AHP type K+ channel (K_AHP_Wtn)------------------ %%
function AHPK
gKAHP=max((NP.Z>0).*(6 -.05*NP.ds)+(NP.Z<0).*(6 -.08*NP.ds),1)/100^2;
IKAHP = gKAHP.*q.*(Vm-EK);
alphaq = 4.8*10^6./exp(-5*log(Cai(:,2)-.035));
betaq = 12*10^6./exp(2*log(Cai(:,2)+.1));
tauq = 0.048;%? what's this?
dq=alphaq.*(1-q)+betaq.*q;
end
% Density (ds = distance to soma in µm):
% Soma: 6 S/m2
% Apical tree:
%     Dens = 6 - 5(ds/100) S/m2
% Basal tree:
%     Dens = 6 - 8(ds/100) S/m2
% If Dens < 1.0 S/m2, Dens = 1.0 S/m2



%% ------------------------h type channel (Ih_3)----------------------- %%
function Ih
gh=(NP.z>0).*(4 + 116/(1.0 + exp((250 - NP.z)/100)));
Ih = gh.*u.*(Vm-EK);
uinf = 1./(1+exp((90+Vm)/4));
tauu = 0.6+40.*exp((Vm+65)/35)./(1+exp((Vm+65)/3.5));
du=dt./tauu.*(uinf-u);
end
% Density (ds = distance to soma in µm):
% Soma: 4 S/m2
% Apical tree:
%     Dens = 4 + 116/(1.0 + exp((250 - ds)/100) S/m2
% Basal tree:
%     Dens = 4 + 96/(1.0 + exp((250 - ds)/100) S/m2


%% Intracellular Ca++ dynamics 

% As described by Warman et al. (1994) and Borg-Graham (1998), the [Ca]i
% was simulated as two different Ca pools with different time constants,
% tau1 = 0.9 ms for the calculation of ECa and modulating the C-type K+
% current, and tau2 = 1 s for the AHP-type K+ current, as follows:   
tau=[.9; 10^3] ;% ms,  time constant

f=[0.7; 0.024];%  Ca influx affecting the i-th pool
% FA=96.48533;% mC/ uM
% z=2;
w= 10^-3 *((NP.diam>2)+((NP.diam<2).*NP.diam)); % cm, thickness of the diffusion shell
A=NP.area;% [ncomp, 2] cm2
dCai =bsxfun(@rdivide,f',w*2*96.48533.*A)*ICa - bsxfun(@rdivide,Cai,tau');%  um

% where taui is the removal time constant in the i-th calcium pool, fi the
% fraction of Ca influx affecting the i-th pool (f1=0.7, f2=0.024), w is
% the thickness of the diffusion shell (1 µm in compartments with diameter
% > 2 µm, or its diameter on thinner dendrites), A is the compartment area,
% z is the valence of the calcium ion and F is the Faraday's constant.    

% The extracellular concentration ([Ca]o) is considered constant and equal
% to 1.2 mM. The initial (rest) intracellular concentration [Cabase] is 50
% nM.  

Cabase=.05;% uM
Ca1 = Cai(:,1) + Cabase;
ECa=-13.275*log(Ca1/1200);%  [Ca]o was 1.2 mM; mV
