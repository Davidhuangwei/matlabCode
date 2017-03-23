classdef NeuronAct < handle
    properties (SetAccess = protected)
        Vm;
        Ia;
        a;
        Im;
        fchan;
        gm;
        g;
        A;
        dt;
        Level;
        ds;
        Ca1;
        Ca2;
        ICa;
        nch;
        nf;
        ECa;
        conn;
        iRam;
        Cm;
        gs;
        Is;
        ram;
        ReshapeFun;
        Ic;
        Ra;
        Z;
        ncomp;
        spk;
%         channelstype;
    end
    methods
        function NA=NeuronAct(channelstype,NeuronParams,ncell,dt)
            % save for every 10^4 sample time. 
            % I 
%             NA.channelstype=channelstype;
            NA.nch=length(channelstype);
            NA.ncomp=NeuronParams.numCompartments;
            nall=ncell*NA.ncomp;
            if exist('restingV.mat','file')
                load('restingV.mat')
                NA.Vm=V;
            else
                NA.Vm=NeuronParams.E_leak*ones(nall,1)+rand(nall,1);
            end
            
            NA.ReshapeFun=@(x)(reshape(x,ncell,NA.ncomp));
            NA.a=cell(NA.nch,2);
            NA.Ia=zeros(nall,1);
            NA.Im=zeros(nall,NA.nch);
            NA.A=NeuronParams.A(:);
            NA.dt=dt;
            NA.Cm=NeuronParams.Cm(:);
            NA.Level=2*ones(1,NeuronParams.numCompartments);
            NA.Level(NeuronParams.compartmentParentArr==1)=1;
            NA.Level(1)=0;
            NA.Level=reshape(repmat(NA.Level,ncell,1),[],1);
            [NA.conn, NA.ram]=ConnParts(NeuronParams);% the function of computing mean of V of nearby channels. 
            NA.Ra= 2./NeuronParams.Ra(:);
            NA.iRam= 2./NeuronParams.Ra(:)+1./NeuronParams.Rm(:);
            NA.Ic=NeuronParams.E_leak./NeuronParams.Rm(:);
            channames={'sdNa';...% Somato-dendritic Na+ channel (Na_7)
%                 'aNa';...% Axonic Na+ channel (NaA_2)
                'wCa';...% High thereshold Ca++ channel (Ca_W)
                'tCa';...% Low thereshold Ca++ channel (CaT_3)
                'aKp';...% A type K+ channel, proximal (K_A_11)
                'aKd';...% A type K+ channel, distal (K_A_18)
                'drK';...% DR type K+ channel (K_DR_2)
%                 'drKa';...% DR type K+ channel, axonic (K_DRA_4)
                'cK';...% C type K+ channel (K_C_1) ca
                'mK';...% M type K+ channel (K_M_4)
                'AHPK';...% AHP type K+ channel (K_AHP_Wtn)ca
                'Ih';...%  h type channel (Ih_3)
                };
            NA.gm=[];%zeros(nall,NA.nch);
            NA.g=zeros(nall,NA.nch);%cell(NA.nch,1);
            NA.ds=NeuronParams.ds(:);
            NA.gs=0;
            NA.Is=0;
NA.Z=reshape(repmat(mean(NeuronParams.compartmentZPositionMat,2)',ncell,1),[],1);

            for k=1:NA.nch
                channame=channames{channelstype(k)};
                NA.fchan{k}=str2func(channame);
                NA=NA.fchan{k}(NA,k);
            end
w= 10^-11 *((NeuronParams.compartmentDiameterArr>2)+((NeuronParams.compartmentDiameterArr<=2).*NeuronParams.compartmentDiameterArr)); % cm, thickness of the diffusion shell
NA.nf=1/2/96.48533./bsxfun(@times,NeuronParams.A,w');%  Ca influx affecting the i-th pool
NA.nf=NA.nf(:);
NA=updateCalsium(NA,0);
NA.spk=false(ncell,1);
        end
        %% update channels.
        function NA=updateNeuron(NA,Gglu,GgabaA,GgabaB)
            %  NA=updateNeuron(NA,Gglu,GgabaA,GgabaB)
            NA.Is=-reshape(NA.ram.*(NA.ReshapeFun(NA.Vm.*NA.Ra)*NA.conn),[],1)-NA.Ic;
            NA.gs=NA.iRam;
            for k=1:NA.nch
                
                NA=NA.fchan{k}(NA,k);
                if sum(isnan(NA.gs)|isinf(NA.gs))>0
                    fprintf('wrong at %d',k)
                   break
                end
            end
            NA=updateCalsium(NA,1);
            
            % --- input current --- %
            NA.Is=NA.Is+GgabaA*10.71+GgabaB*3;%75/7 90/30
            NA.gs=NA.gs+GgabaA/7+GgabaB/30+Gglu/2;
%             IgabaA=Inputs.GgabaA.*(NA.Vm+75);
%             IgabaB=Inputs.GgabaB.*(NA.Vm+90);
%             Iglu=Inputs.Gglu.*NA.Vm;
            % -- cable conductance --% 
            % [ga,gI]=NA.conn(NA.Vm,NA.Ra);
            % NA.Is=NA.Is+NA.ram.*(NA.Vm*Na.conn);
            % NA.gs=NA.gs-NA.iRa; % constant!
             NA.Vm=NA.Vm-NA.dt*(NA.Is+NA.gs.*NA.Vm)./NA.Cm;
             tm=NA.Vm(1:NA.ncomp:end);
%              NA.spk=(tm>-40);
%              tm(NA.spk)=-70;
             NA.Vm(1:NA.ncomp:end)=tm;
            
                 
%             NA.Vm=(NA.Vm+(NA.Is./NA.gs)).*exp(-NA.dt*NA.gs./NA.Cm)-(NA.Is./NA.gs);
        end
        %% Intracellular Ca++ dynamics 
        function NA=updateCalsium(NA,k)  
            if k==0
                NA.Ca1=0.05;%0;%
                NA.Ca2=0.05;%0;%
                NA.ICa=0;
                NA.ECa=-13.275*log((max(NA.Ca1,10^-9))/1200);%  +.05[C
            else
% FA=96.48533;% mC/ uM
% z=2;
% tau=[.9; 10^3] ;% ms,  time constant
% w= 10^-3 *((NP.diam>2)+((NP.diam<2).*NP.diam)); % cm, thickness of the diffusion shell
ab=(.05/.9-0.7*NA.nf.*NA.ICa )*.9;%/1000mean() 
NA.Ca1=(NA.Ca1-ab).*exp(-NA.dt/.9)+ab;
% ab=(.05/.9-NA.nf.*NA.ICa )*.9;%/1000mean() 
% NA.Cai=(NA.Cai-ab).*exp(-NA.dt/.9)+ab;
ab=(.05/10^3 -0.024*NA.nf.*NA.ICa)*10^3;%mean()
NA.Ca2=(NA.Ca2-ab).*exp(-NA.dt/10^3)+ab;
% Cabase=.05;% uM
            end
NA.ECa=-13.275*log((max(NA.Ca1,10^-9)+.05)/1200);% +.05 [Ca]o w
NA.ICa=NA.ICa*0;
% where taui is the removal time constant in the i-th calcium pool, fi the
% fractio
        end
        %% ---------------Somato-dendritic Na+ channel (Na_7)-------
        function NA=sdNa(NA,k)
            if size(NA.gm,2)<k
                NA.gm(:,k)=NA.A.*500/100^2;  
                NA.a{k,1}=0;
                NA.a{k,2}=0;
%             gNa=500/100^2;% S/cm2
            else
                minf = 1./(1+exp((25+NA.Vm)/-5));
                taum = .020+.22./(exp((NA.Vm+55)/13)+exp((NA.Vm+55)/-80));% ms
                % dm=dt./taum.*(minf-m);
                NA.a{k,1}=(NA.a{k,1}-minf).*exp(-NA.dt./taum)+minf;
                
                hinf = 1./(1+exp((50+NA.Vm)/4));
                tauh = .6+8*exp((NA.Vm+45)/13)./(1+exp((NA.Vm+45)/5.5));
                %  dh=dt./tauh.*(hinf-h);
                 NA.a{k,2}=(NA.a{k,2}-hinf).*exp(-NA.dt./tauh)+hinf;
                NA.g(:,k)=NA.gm(:,k).*NA.a{k,1}.^3.*NA.a{k,2};
                NA.Im(:,k)= NA.g(:,k).*(NA.Vm-50);% record if you like. Recording
                
            NA.gs=NA.gs+NA.g(:,k);
            NA.Is=NA.Is-50*NA.g(:,k);
            end
            % Density: 500 S/m2 in soma and 500 S/m2 all over the apical and basal tree
        end
        %% ---------------------Axonic Na+ channel (NaA_2)-------
         function NA=aNa(NA,k)
            if size(NA.gm,2)<k
                 NA.gm(:,k)=NA.A.*((NA.Level==1)*666+(NA.Level>1)*1000)/100^2;% S/cm2
                NA.a{k,1}=0;
                NA.a{k,2}=0;
            else
                minf = 1./(1+exp((32+NA.Vm)/-4.2));
                taum = .020+.220./(exp((NA.Vm+62)/13)+exp((NA.Vm+62)/-80));
                % dm=dt./taum.*(minf-m);
                NA.a{k,1}=(NA.a{k,1}-minf).*exp(-NA.dt./taum)+minf;
                
                
                hinf = 1./(1+exp((50+NA.Vm)/4));
                tauh = .0200+8*exp((NA.Vm+45)/13)./(1+exp((NA.Vm+45)/5.5));
                %  dh=dt./tauh.*(hinf-h);
                NA.a{k,2}=(NA.a{k,2}-hinf).*exp(-NA.dt/tauh)+hinf;
                NA.g(:,k)=NA.gm(:,k).*NA.a{k,1}.^3.*NA.a{k,2};
                NA.Im(:,k)= NA.g(:,k).*(NA.Vm-50);% record if you like. Recording
                
            NA.gs=NA.gs+NA.g(:,k);
            NA.Is=NA.Is-50*NA.g(:,k);
            end
            % Density: 666 S/m2 in the nearest compartment to soma and 1000 S/m2 in the unmielinized compartments thereof
         end
        
         %% ----------------High thereshold Ca++ channel (Ca_W)--------------
         function NA=wCa(NA,k)
            if size(NA.gm,2)<k
                 NA.gm(:,k)=NA.A.*((NA.ds<=100)|NA.Z>0).*30/100^2;% S/cm2
                NA.a{k,1}=0;
                NA.a{k,2}=0;
            else               
                NA.Vm(abs(NA.Vm-26)<10^-4 |abs(NA.Vm-12)<10^-4 )=NA.Vm(abs(NA.Vm-26)<10^-4 |abs(NA.Vm-12)<10^-4 )+10^-3;
                alpha = .160*(NA.Vm+26)./(-exp((NA.Vm+26)/-4.5)+1);
                beta = .040*(NA.Vm+12)./(exp((NA.Vm+12)/10)-1);
                % ds=alphas.*(1-s)+betas.*s;
                minf=alpha./(alpha-beta);
                NA.a{k,1}=(NA.a{k,1}-minf).*exp(-NA.dt.*(alpha-beta))+minf;
                
                
                alpha = 2./exp((NA.Vm+94)/10);
                beta = 8./(exp((NA.Vm-68)/-27)+1);
                % dr=alpha.*(1-r)+beta.*r;
                hinf=alpha./(alpha-beta);
                NA.a{k,2}=(NA.a{k,2}-hinf).*exp(-NA.dt.*(alpha-beta))+hinf;
                NA.g(:,k)=NA.gm(:,k).*NA.a{k,1}.^2.*NA.a{k,2};
                 ii=NA.g(:,k).*(NA.Vm-NA.ECa);% r
                NA.Im(:,k)= ii;%NA.g(:,k).*(NA.Vm-NA.ECa);% record if you like. Recording
                
                NA.ICa=NA.ICa+ii;
            NA.gs=NA.gs+NA.g(:,k);
            NA.Is=NA.Is-NA.ECa.*NA.g(:,k);
            end
            % Density: 666 S/m2 in the nearest compartment to soma and 1000 S/m2 in the unmielinized compartments thereof
         end
         %% --------------------------Low thereshold Ca++ channel (CaT_3)----
         function NA=tCa(NA,k)
            if size(NA.gm,2)<k
                 NA.gm(:,k)=NA.A.*min((NA.Z<0).*(NA.ds>100).*(30 + 25*(NA.ds/100-1)),100)/100^2;%S/cm2
                NA.a{k,1}=0;
                NA.a{k,2}=0;
            else          
                sinf = 1./(1+exp((54+NA.Vm)/-5));
                taus = .204+.333./(exp((NA.Vm+15.8)/18.2)+exp((NA.Vm+131)/-16.7));
                NA.a{k,1}=(NA.a{k,1}-sinf).*exp(-NA.dt./taus)+sinf;
                
                rinf = 1./(1+exp((80+NA.Vm)/4));
                taur=rinf;
                taur(NA.Vm<= -81)=.333*exp((NA.Vm(NA.Vm<= -81)+466)/66.6);
                taur(NA.Vm>-81)=9.32 + .333*exp((NA.Vm(NA.Vm> -81)+21)/-10.5);

                NA.a{k,2}=(NA.a{k,2}-rinf).*exp(-NA.dt./taur)+rinf;
                NA.g(:,k)=NA.gm(:,k).*NA.a{k,1}.^2.*NA.a{k,2};
                ii=NA.g(:,k).*(NA.Vm-NA.ECa);% record if you like. Recording
                NA.Im(:,k)= ii;
                NA.ICa=NA.ICa+ii;
                
            NA.gs=NA.gs+NA.g(:,k);
            NA.Is=NA.Is-NA.ECa.*NA.g(:,k);
            end
            % Density: 666 S/m2 in the nearest compartment to soma and 1000 S/m2 in the unmielinized compartments thereof
         end
         %% -------------------A type K+ channel, proximal (K_A_11)-------------
         function NA=aKp(NA,k)
             if size(NA.gm,2)<k
                 NA.gm(:,k)=NA.A.*(NA.ds<100).*((NA.Z>0).*(20+2*NA.ds)+(NA.Z<0).*(20+1.7*NA.ds))/100^2;%S/cm2
                NA.a{k,1}=0;
                NA.a{k,2}=0;
             else
                 ninf = 1./(1+exp((12+NA.Vm)/-8.5));
                 taun = .080;
                 NA.a{k,1}=(NA.a{k,1}-ninf).*exp(-NA.dt./taun)+ninf;
                 
                 
                 linf = 1./(1+exp((56+NA.Vm)/7));
                 taul = max(.26*(NA.Vm+50),2);
                 NA.a{k,2}=(NA.a{k,2}-linf).*exp(-NA.dt./taul)+linf;
                 NA.g(:,k)=NA.gm(:,k).*NA.a{k,1}.*NA.a{k,2};
                 NA.Im(:,k)= NA.g(:,k).*(NA.Vm+90);% record if you like. Recording
            NA.gs=NA.gs+NA.g(:,k);
            NA.Is=NA.Is+90*NA.g(:,k);
             end
             % Density: 666 S/m2 in the nearest compartment to soma and 1000 S/m2 in the unmielinized compartments thereof
         end
         
         %% ------------------ A type K+ channel, distal (K_A_18)---------------
         function NA=aKd(NA,k)
             if size(NA.gm,2)<k
                 NA.gm(:,k)=NA.A.*min((NA.ds>100).*((NA.Z>0).*(20+2*NA.ds)+(NA.Z<0).*(20+1.7*NA.ds)),600)/100^2;%S/cm2
                NA.a{k,1}=0;
                NA.a{k,2}=0;
             else
                 ninf = 10.^(NA.Vm<= -65)./(1+exp((24+NA.Vm)/-7));
                 taun = .080;
                 NA.a{k,1}=(NA.a{k,1}-ninf).*exp(-NA.dt./taun)+ninf;
                 
                 linf = 1./(1+exp((56+NA.Vm)/7));
                 taul = max(0.26*(NA.Vm+50),2);
                 NA.a{k,2}=(NA.a{k,2}-linf).*exp(-NA.dt./taul)+linf;
                 NA.g(:,k)=NA.gm(:,k).*NA.a{k,1}.*NA.a{k,2};
                 NA.Im(:,k)= NA.g(:,k).*(NA.Vm+90);% record if you like. Recording
            NA.gs=NA.gs+NA.g(:,k);
            NA.Is=NA.Is+90*NA.g(:,k);
             end
             % Density: 666 S/m2 in the nearest compartment to soma and 1000 S/m2 in the unmielinized compartments thereof
         end
         
          %% ---------------DR type K+ channel (K_DR_2)-------------------
         function NA=drK(NA,k)
             if size(NA.gm,2)<k
                 NA.gm(:,k)=NA.A.*40/100^2;%S/cm2
                NA.a{k,1}=0;
                NA.a{k,2}=0;
             else
                 ninf = 1./(1+exp((5-NA.Vm)/11));
                 taun = 1.2;
                 NA.a{k,1}=(NA.a{k,1}-ninf).*exp(-NA.dt./taun)+ninf;
                 
                 NA.g(:,k)=NA.gm(:,k).*NA.a{k,1};
                 NA.Im(:,k)= NA.g(:,k).*(NA.Vm+90);% record if you like. Recording
            NA.gs=NA.gs+NA.g(:,k);
            NA.Is=NA.Is+90*NA.g(:,k);
             end
             % Density: 666 S/m2 in the nearest compartment to soma and 1000 S/m2 in the unmielinized compartments thereof
         end
         
         %% ----------------C type K+ channel (K_C_1)----------------
         function NA=cK(NA,k)
            if size(NA.gm,2)<k
                 NA.gm(:,k)=NA.A.*((NA.Z>0 & NA.ds<225).*(720+3.2*NA.ds)+(NA.Z==0)*720+(NA.Z<0 & NA.ds<100).*(720+7*NA.ds))/100^2;% S/cm2
                NA.a{k,1}=0;
                NA.a{k,2}=0;
            else   
                Vshift = 40.*log(max((NA.Ca1+.05)*1000,10^-7))-105;
                alpha = -7.7*(NA.Vm+Vshift+103)/1000./(exp((NA.Vm+Vshift+103)/-12)-1);
                beta = 1.7./exp((NA.Vm+Vshift+237)/30);
                % dc=alphac.*(1-c)+betac.*c;
                minf=alpha./(alpha-beta);
                NA.a{k,1}=(NA.a{k,1}-minf).*exp(-NA.dt.*(alpha-beta))+minf;
                
                
                alpha = 1./exp((NA.Vm+79)/10);
                beta =4./(exp((NA.Vm-82)/-27)+1); 
                % dd=alphad.*(1-d)+betad.*d;
                hinf=alpha./(alpha-beta);
                NA.a{k,2}=(NA.a{k,2}-hinf).*exp(-NA.dt.*(alpha-beta))+hinf;
                NA.g(:,k)=NA.gm(:,k).*NA.a{k,1}.^2.*NA.a{k,2};
                NA.Im(:,k)= NA.g(:,k).*(NA.Vm+90);% record if you like. Recording
            NA.gs=NA.gs+NA.g(:,k);
            NA.Is=NA.Is+90*NA.g(:,k);
            end
            % Density (ds = distance to soma in µm):
            % Soma: 720 S/m2
            % Apical tree:
            %     If ds < 225, Dens = 720 - 320(ds/100) S/m2
            %     If ds > 225, Dens = 0.0 S/m2
            % Basal tree:
            %     If ds < 100, Dens = 720 - 700(ds/100) S/m2
            %     If ds > 100, Dens = 0.0 S/m2
            
            
         end
         
          %% --------------- M type K+ channel (K_M_4)--------------------
         function NA=mK(NA,k)
             if size(NA.gm,2)<k
                 NA.gm(:,k)=NA.A.*((NA.Z>0).*5+(NA.Z==0)*10+(NA.Z<0).*4.5)/100^2;%S/cm2
                NA.a{k,1}=0;
                NA.a{k,2}=0;
             else
                 ninf = 1./(1+exp((40+NA.Vm)/-8.5));
                 taun =0.9+20*exp((NA.Vm+38)/25)./(1+exp((NA.Vm+38)/7)); 
                 NA.a{k,1}=(NA.a{k,1}-ninf).*exp(-NA.dt./taun)+ninf;
                 NA.g(:,k)=NA.gm(:,k).*NA.a{k,1};
                 NA.Im(:,k)= NA.g(:,k).*(NA.Vm+90);% record if you like. Recording
            NA.gs=NA.gs+NA.g(:,k);
            NA.Is=NA.Is+90*NA.g(:,k);
             end
             % Density: 666 S/m2 in the nearest compartment to soma and 1000 S/m2 in the unmielinized compartments thereof
         end
          %% ----------------AHP type K+ channel (K_AHP_Wtn)----------------
         function NA=AHPK(NA,k)
            if size(NA.gm,2)<k
                 NA.gm(:,k)=NA.A.*max((NA.Z>0).*(6 -.05*NA.ds)+(NA.Z<0).*(6 -.08*NA.ds),1)/100^2;% S/cm2
                NA.a{k,1}=0;
                NA.a{k,2}=0;
            else
                alpha = 4.8*10^6./exp(-5*log(max((NA.Ca2+.05)*1000-35,10^-6)));
                beta = 12*10^6./exp(2*log(max((NA.Ca2+.05)*1000+100,10^-6)));
                %dq=alphaq.*(1-q)+betaq.*q;
                minf=alpha./(alpha-beta);
                NA.a{k,1}=(NA.a{k,1}-minf).*exp(-NA.dt.*(alpha-beta))+minf;
                
                NA.g(:,k)=NA.gm(:,k).*NA.a{k,1};
                NA.Im(:,k)= NA.g(:,k).*(NA.Vm+90);% record if you like. Recording
            NA.gs=NA.gs+NA.g(:,k);
            NA.Is=NA.Is+90*NA.g(:,k);
            end
            % Density (ds = distance to soma in µm):
            % Soma: 6 S/m2
            % Apical tree:
            %     Dens = 6 - 5(ds/100) S/m2
            % Basal tree:
            %     Dens = 6 - 8(ds/100) S/m2
            % If Dens < 1.0 S/m2, Dens = 1.0 S/m2
         end
          %% ---------------------h type channel (Ih_3)---------------------
         function NA=Ih(NA,k)
             if size(NA.gm,2)<k
                 NA.gm(:,k)=(NA.A.*(NA.Z>0).*(4 + 116./(1.0 + exp((250 - NA.Z)/100)))+...
                     NA.A.*(NA.Z<0).*(4 + 96./(1.0 + exp((250 - NA.Z)/100)))+...
                 NA.A.*(NA.Z==0).*4)/100^2;%S/cm2
                 
                NA.a{k,1}=0;
                NA.a{k,2}=0;
             else
                 ninf = 1./(1+exp((90+NA.Vm)/4));
                 taun =0.6+40.*exp((NA.Vm+65)/35)./(1+exp((NA.Vm+65)/3.5));
                 NA.a{k,1}=(NA.a{k,1}-ninf).*exp(-NA.dt./taun)+ninf;
                 NA.g(:,k)=NA.gm(:,k).*NA.a{k,1};
                 NA.Im(:,k)= NA.g(:,k).*(NA.Vm+90);% record if you like. Recording
            NA.gs=NA.gs+NA.g(:,k);
            NA.Is=NA.Is+90*NA.g(:,k);
             end
             % Density: 666 S/m2 in the nearest compartment to soma and 1000 S/m2 in the unmielinized compartments thereof
         end
         
    end
end