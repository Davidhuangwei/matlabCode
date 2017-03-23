% function vertex_multi_main single CA1 model. receive 3 independent
% inputs. 
clear all
close all
for conum=1:10
FileBase=sprintf('PoissionInputMEC_CA3CO%d',conum);% 'PoissionInputMEC_CA3'-> RANDOM
if exist(['/home/weiwei/data/', FileBase],'dir')
    cd(['/home/weiwei/data/', FileBase])
else
    cd /home/weiwei/data/
    mkdir(FileBase)
    cd(FileBase)
end
SimulationSettings.simulationTime = 50000;
TissueParams.X = 400;% for X=25*2.^[-1 :]

TissueParams.Y = 400;
TissueParams.Z = 650;% ~700 um nori's 25 um electrod.
TissueParams.neuronDensity = 3*64000;
TissueParams.numStrips = 50;
TissueParams.tissueConductivity = 0.3;
TissueParams.maxZOverlap = [20 , 0];% up down

TissueParams.numLayers = 5;% 
TissueParams.layerBoundaryArr = [650, 450, 290, 183, 143, 0];
% [lm-o, lm-i, rad, pyr, orien]
NeuronParams(1).somaLayer = 4; % CA1 Pyramidal cells
NeuronParams(1).modelProportion = .30;
NeuronParams(1).neuronModel = 'adex';%'passive';   to see the pure input effect.
% electrical parameter for firing neurons.
NeuronParams(1).V_t = -50;
NeuronParams(1).delta_t = 2;
NeuronParams(1).a = 2.6;
NeuronParams(1).tau_w = 65;
NeuronParams(1).b = 220;
NeuronParams(1).v_reset = -69;
NeuronParams(1).v_cutoff = -45;
% % electrical parameter for passive neurons: 
% NeuronParams(1).C = 1.0 * 2.96;
% NeuronParams(1).R_M = 20000 / 2.96;
% NeuronParams(1).R_A = 150;
% NeuronParams(1).E_leak = -70;
% morphology 
complexmophology=0;
if complexmophology
complayers{1}=1;% soma
complayers{2}=7;% rad P
complayers{3}=2;% lm P
complayers{4}=6;% rad D1
complayers{5}=4;% lm D1
complayers{6}=12;% rad D2
complayers{7}=8;% lm D2
complayers{8}=24;% rad D3
complayers{9}=16;% lm D3
complayers{10}=12;% rad D4
complayers{11}=4;% orien p
complayers{12}=8;% orien D1
complayers{13}=16;% orien D2
complayers{14}=32;% orien D3
lengths=[20, 110, 4100-110, 2300, 5500;...
    complayers{1},complayers{2},complayers{4}+complayers{6}+complayers{8}+complayers{10},...
    complayers{3}+complayers{5}+complayers{7}+complayers{9},...
    complayers{11}+complayers{12}+complayers{13}+complayers{14}];
NeuronParams(1).numCompartments =sum(lengths(2,:));
olengths=lengths;
lengths=lengths(1,:)./lengths(2,:);
%%
NeuronParams(1).compartmentDiameterArr = ...
  [18*complayers{1}, ...% soma                        1
  3.75, 2.5, 2.5, 2, 2, 2,2,...% rad P      5
  1.5, 1.5,... % lm P                   2
  ones(1,complayers{4}+complayers{5}),...% rad+lm D1              6
  ones(1,complayers{6}),...% rad D2                 8
  ones(1,complayers{7}),...% lm D2                  6
  ones(1,complayers{8}),...% rad D3                  6
  ones(1,complayers{9}),...% lm D3                  6
  ones(1,complayers{10}),...% rad D4
  ones(1,complayers{11}),...% orien p                4
  ones(1,complayers{12}+complayers{13}+complayers{14})];% orien D                  6
% 40 compartments...


compStruc=zeros(5,NeuronParams(1).numCompartments);
% 1. dendry layer
% 2. parents
% 3. length
% 4. theta (to Z ->0 )
% 5. phi x-y plane
compStruc(3,1)=20;
compStruc(4,1)=0;
compStruc(5,1)=0;
n=0;
for k=1:length(complayers)
    compStruc(1,n+[1:complayers{k}])=k;
    if (k==2)%(k>1)&&(k<4)% rad P
    compStruc(2,n+[1:complayers{k}])=1:complayers{2};% parents
    compStruc(3,n+[1:complayers{k}])=lengths(2);
    compStruc(4,n+[1:complayers{k}])=0;
    compStruc(5,n+[1:complayers{k}])=0;
    elseif (k==3)%(k>1)&&(k<4) lm P
    compStruc(2,n+[1:complayers{k}])=n;% parents
    compStruc(3,n+[1:complayers{k}])=lengths(4);
     compStruc(4,n+[1:complayers{k}])=30;
    compStruc(5,n+[1:complayers{k}])=[0 180];
    elseif (k==4)%(k>1)&&(k<4)rad D1
    compStruc(2,n+[1:complayers{k}])=[1:(complayers{2}-1)]+1;% parents
    compStruc(3,n+[1:complayers{k}])=lengths(3);
     compStruc(4,n+[1:complayers{k}])=85;
    compStruc(5,n+[1:complayers{k}])=[0 180 240 120 60 300];
    elseif (k>4)&&(k<10)%(k>1)&&(k<4)lm D1-D3 rad D2-D3
        pp=repmat(find(compStruc(1,:)==(k-2)),2,1);
    compStruc(2,n+[1:complayers{k}])=pp(:)';% parents
    compStruc(3,n+[1:complayers{k}])=lengths(3+mod(k,2));
    if k==5 % lm D1
        compStruc(4,n+[1:complayers{k}])=[87, 10, 10, 87];
    compStruc(5,n+[1:complayers{k}])=[0 90 270 180];
    elseif k==7 % lm D2
        compStruc(4,n+[1:complayers{k}])=[100 30 65 25 65 25  50 100];
    compStruc(5,n+[1:complayers{k}])=[100 250 0 180 0 180 70 280];
    elseif k==9 % lm D3
        compStruc(4,n+[1:complayers{k}])=[107 60 37 60 40 60 67*ones(1,4) 60 40 87 60 87 60 ];
    compStruc(5,n+[1:complayers{k}])=[100+[-90 90] 250+[-90 90] 90 270 90 270 90 270 90 270 70+[-90 90] 280+[-90 90]];
    elseif k==6 % rad D2
         compStruc(4,n+[1:complayers{k}])=reshape(repmat([60;120],1,6),1,[]);
    compStruc(5,n+[1:complayers{k}])=reshape(bsxfun(@plus,[0 180 240 120 60 300],[-60;60]),1,[]);
    elseif k==8 % rad D3
         compStruc(4,n+[1:complayers{k}])=reshape(repmat([120;60],1,12),1,[]);
    compStruc(5,n+[1:complayers{k}])=reshape(bsxfun(@plus,compStruc(5,pp(1:2:end)'),[-60;60]),1,[]);
    end
    
    elseif (k==10)%(k>1)&&(k<4) rad D4
        pp=find(compStruc(1,:)==(k-2));
        pp=repmat(pp([1:(complayers{k}/2)]*3),2,1);
    compStruc(2,n+[1:complayers{k}])=pp(:)';% parents
    compStruc(3,n+[1:complayers{k}])=lengths(3);
     compStruc(4,n+[1:complayers{k}])=80*ones(1,12);
    compStruc(5,n+[1:complayers{k}])=reshape(bsxfun(@plus,compStruc(5,pp(1:2:end)'),[-80;80]),1,[]);
    elseif k==11 % orien p
        
    compStruc(2,n+[1:complayers{k}])=1;% parents
    compStruc(3,n+[1:complayers{k}])=lengths(5);
    compStruc(4,n+[1:complayers{k}])=105*ones(1,4);
    compStruc(5,n+[1:complayers{k}])=90*[1:4];
    elseif k>11 % orien D1-D3
        pp=repmat(find(compStruc(1,:)==(k-1)),2,1);
    compStruc(2,n+[1:complayers{k}])=pp(:)';% parents
    compStruc(3,n+[1:complayers{k}])=lengths(5);
    compStruc(4,n+[1:complayers{k}])=reshape(repmat([80;110],1,complayers{k}/2),1,[]);
    compStruc(5,n+[1:complayers{k}])=reshape(bsxfun(@plus,compStruc(5,pp(1:2:end)'),[-60;60]),1,[]);
    end
    n=n+complayers{k};
end % my surface is too large, s.t. I have very negtive membrane potential.
%%
NeuronParams(1).compartmentParentArr = compStruc(2,:);
% [0, ...comp1 soma
%     1, 2, 3, 4, 5, ...comp 2:6      rad P
%     6, 6, ...comp 7:8               lm P
%     2, 3, 4, 5, 7, 7, 8, 8, ...comp 9:16   rad+lm D1
%     9, 9, 10, 10, 11,11,12,12,...comp 17:24 rad D2
%     13, 13, 14, 15, 16, 16, ... comp 25:30  lm D2
%     ones(1,4),... comp 31:34  orien p
%     31,31,32,33,34,34];  % comp 35:40 orien D
NeuronParams(1).compartmentLengthArr = compStruc(3,:);
% [20,...soma
%     110/5*ones(1,5),...rad P
%     200, 200,...lm P
%     3900/12*ones(1,4),2300/12*ones(1,2),...rad+lm D1
%     3900/12*ones(1,8),...rad D2
%     2300/12*ones(1,6),...lm D2
%     5500/10*ones(1,10)];% comp orien p+D

NeuronParams(1).compartmentXPositionMat = zeros(NeuronParams(1).numCompartments,2);
NeuronParams(1).compartmentYPositionMat = zeros(NeuronParams(1).numCompartments,2);
NeuronParams(1).compartmentZPositionMat = zeros(NeuronParams(1).numCompartments,2);
NeuronParams(1).compartmentZPositionMat(1,:)=[-20 0];
for k=2:NeuronParams(1).numCompartments
    pp=compStruc(2,k);
    if compStruc(1,k)==11
        endp=1;
    else
        endp=2;
    end
    NeuronParams(1).compartmentXPositionMat(k,:)=NeuronParams(1).compartmentXPositionMat(pp,endp)+...
        [0, compStruc(3,k)*sin(pi/180*compStruc(4,k))*cos(pi/180*compStruc(5,k))];
    NeuronParams(1).compartmentYPositionMat(k,:)=NeuronParams(1).compartmentYPositionMat(pp,endp)+...
        [0, compStruc(3,k)*sin(pi/180*compStruc(4,k))*sin(pi/180*compStruc(5,k))];
    NeuronParams(1).compartmentZPositionMat(k,:)=NeuronParams(1).compartmentZPositionMat(pp,endp)+...
        [0, compStruc(3,k)*cos(pi/180*compStruc(4,k))];
end
NeuronParams(1).rad = find((NeuronParams(1).compartmentZPositionMat(:,2)>0)&(NeuronParams(1).compartmentZPositionMat(:,2)<110));
NeuronParams(1).lmi = find((NeuronParams(1).compartmentZPositionMat(:,2)>=110)&(NeuronParams(1).compartmentZPositionMat(:,2)<=260));
NeuronParams(1).lmo=find(NeuronParams(1).compartmentZPositionMat(:,2)>=250);

else
  

complayers{1}=1;% soma
complayers{2}=7;% rad P
complayers{3}=2;% lm P
complayers{4}=6;% rad D1
complayers{5}=4;% lm D1
complayers{6}=4;% lm D2
complayers{7}=2;% orien p
complayers{8}=4;% orien D1
lengths=[20, 110, (4100-110)/5, 2300/3, 5500/5;...
    complayers{1},complayers{2},complayers{4},...
    complayers{3}+complayers{5}+complayers{6},...
    complayers{7}+complayers{8}];
NeuronParams(1).numCompartments =sum(lengths(2,:));
olengths=lengths;
lengths=lengths(1,:)./lengths(2,:);
%%
NeuronParams(1).compartmentDiameterArr = ...
  [15*complayers{1}, ...% soma                        1
 2,1.5, 1.5,1.5, 1.5,1.5, 1.5,...% rad P 3.75, 2.5, 2.5, 2, 2, 2,2      5
  1.5, 1.5,... % lm P                   2
  0.3536*ones(1,complayers{4}+complayers{5}),...% rad+lm D1              6
 0.3536*ones(1,complayers{6}),...% lm D2                  6
  1*ones(1,complayers{7}),...% orien p                4
  0.3536*ones(1,complayers{8})];% orien D                  6
% 40 compartments...


compStruc=zeros(5,NeuronParams(1).numCompartments);
% 1. dendry layer
% 2. parents
% 3. length
% 4. theta (to Z ->0 )
% 5. phi x-y plane
compStruc(3,1)=20;
compStruc(4,1)=0;
compStruc(5,1)=0;
n=0;
for k=1:length(complayers)
    compStruc(1,n+[1:complayers{k}])=k;
    if (k==2)%(k>1)&&(k<4)% rad P
    compStruc(2,n+[1:complayers{k}])=1:complayers{2};% parents
    compStruc(3,n+[1:complayers{k}])=lengths(2);
    compStruc(4,n+[1:complayers{k}])=0;
    compStruc(5,n+[1:complayers{k}])=0;
    elseif (k==3)%(k>1)&&(k<4) lm P
    compStruc(2,n+[1:complayers{k}])=n;% parents
    compStruc(3,n+[1:complayers{k}])=lengths(4);
     compStruc(4,n+[1:complayers{k}])=30;
    compStruc(5,n+[1:complayers{k}])=[0 180];
    elseif (k==4)%(k>1)&&(k<4)rad D1
    compStruc(2,n+[1:complayers{k}])=[1:(complayers{2}-1)]+1;% parents
    compStruc(3,n+[1:complayers{k}])=lengths(3);
     compStruc(4,n+[1:complayers{k}])=85;
    compStruc(5,n+[1:complayers{k}])=[0 180 0 180 0 180];
    elseif (k==5)%(k>1)&&(k<4)lm D1
        pp=repmat(find(compStruc(1,:)==(k-2)),2,1);
    compStruc(2,n+[1:complayers{k}])=pp(:)';% parents
    compStruc(3,n+[1:complayers{k}])=lengths(4);
        compStruc(4,n+[1:complayers{k}])=[87, 10, 10, 87];
    compStruc(5,n+[1:complayers{k}])=[0 0 180 180];
    elseif k==6 % lm D2
        pp=find(compStruc(1,:)==(k-2));
        pp=repmat(pp(2:3),2,1);
        compStruc(2,n+[1:complayers{k}])=pp(:)';% parents
        compStruc(3,n+[1:complayers{k}])=lengths(4);
        compStruc(4,n+[1:complayers{k}])=60*ones(1,4);
        compStruc(5,n+[1:complayers{k}])=[0 180 0 180];
   
     elseif k==7 % orien p
        
    compStruc(2,n+[1:complayers{k}])=1;% parents
    compStruc(3,n+[1:complayers{k}])=lengths(5);
    compStruc(4,n+[1:complayers{k}])=105*ones(1,2);
    compStruc(5,n+[1:complayers{k}])=[0 180];
    elseif k==8 % orien D1-D3
        pp=repmat(find(compStruc(1,:)==(k-1)),2,1);
    compStruc(2,n+[1:complayers{k}])=pp(:)';% parents
    compStruc(3,n+[1:complayers{k}])=lengths(5);
    compStruc(4,n+[1:complayers{k}])=[120 120 120 120];
    compStruc(5,n+[1:complayers{k}])=[0 180 0 180];
    end
    n=n+complayers{k};
end
%%
NeuronParams(1).compartmentParentArr = compStruc(2,:);
% [0, ...comp1 soma
%     1, 2, 3, 4, 5, ...comp 2:6      rad P
%     6, 6, ...comp 7:8               lm P
%     2, 3, 4, 5, 7, 7, 8, 8, ...comp 9:16   rad+lm D1
%     9, 9, 10, 10, 11,11,12,12,...comp 17:24 rad D2
%     13, 13, 14, 15, 16, 16, ... comp 25:30  lm D2
%     ones(1,4),... comp 31:34  orien p
%     31,31,32,33,34,34];  % comp 35:40 orien D
NeuronParams(1).compartmentLengthArr = compStruc(3,:);
% [20,...soma
%     110/5*ones(1,5),...rad P
%     200, 200,...lm P
%     3900/12*ones(1,4),2300/12*ones(1,2),...rad+lm D1
%     3900/12*ones(1,8),...rad D2
%     2300/12*ones(1,6),...lm D2
%     5500/10*ones(1,10)];% comp orien p+D

NeuronParams(1).compartmentXPositionMat = zeros(NeuronParams(1).numCompartments,2);
NeuronParams(1).compartmentYPositionMat = zeros(NeuronParams(1).numCompartments,2);
NeuronParams(1).compartmentZPositionMat = zeros(NeuronParams(1).numCompartments,2);
NeuronParams(1).compartmentZPositionMat(1,:)=[-20 0];
for k=2:NeuronParams(1).numCompartments
    pp=compStruc(2,k);
    if compStruc(1,k)==11
        endp=1;
    else
        endp=2;
    end
    NeuronParams(1).compartmentXPositionMat(k,:)=NeuronParams(1).compartmentXPositionMat(pp,endp)+...
        [0, compStruc(3,k)*sin(pi/180*compStruc(4,k))*cos(pi/180*compStruc(5,k))];
    NeuronParams(1).compartmentYPositionMat(k,:)=NeuronParams(1).compartmentYPositionMat(pp,endp)+...
        [0, compStruc(3,k)*sin(pi/180*compStruc(4,k))*sin(pi/180*compStruc(5,k))];
    NeuronParams(1).compartmentZPositionMat(k,:)=NeuronParams(1).compartmentZPositionMat(pp,endp)+...
        [0, compStruc(3,k)*cos(pi/180*compStruc(4,k))];
end
NeuronParams(1).rad = find((NeuronParams(1).compartmentZPositionMat(:,2)>0)&(NeuronParams(1).compartmentZPositionMat(:,2)<110));
NeuronParams(1).lmi = find((NeuronParams(1).compartmentZPositionMat(:,2)>=110)&(NeuronParams(1).compartmentZPositionMat(:,2)<=260));
NeuronParams(1).lmo=find(NeuronParams(1).compartmentZPositionMat(:,2)>=250);

end



%%

% % NeuronParams(1).numCompartments = 8;
% % NeuronParams(1).compartmentParentArr = [0, 1, 2, 2, 4, 1, 6, 6];
% % NeuronParams(1).compartmentLengthArr = [13 48 124 145 137 40 143 143];
% % NeuronParams(1).compartmentDiameterArr = ...
% %   [29.8, 3.75, 1.91, 2.81, 2.69, 2.62, 1.69, 1.69];
% NeuronParams(1).compartmentXPositionMat = ...
% [   0,    0;
%     0,    0;
%     0,  124;
%     0,    0;
%     0,    0;
%     0,    0;
%     0, -139;
%     0,  139];
% NeuronParams(1).compartmentYPositionMat = ...
% [   0,    0;
%     0,    0;
%     0,    0;
%     0,    0;
%     0,    0;
%     0,    0;
%     0,    0;
%     0,    0];
% NeuronParams(1).compartmentZPositionMat = ...
% [ -13,    0;
%     0,   48;
%    48,   48;
%    48,  193;
%   193,  330;
%   -13,  -53;
%   -53, -139;
%   -53, -139];

NeuronParams(1).axisAligned = 'z';
NeuronParams(1).C = 1.0;
dist=sqrt(mean(NeuronParams(1).compartmentXPositionMat,2).^2+...
    mean(NeuronParams(1).compartmentYPositionMat,2).^2+...
    mean(NeuronParams(1).compartmentZPositionMat,2).^2)';
NeuronParams(1).R_M = 50000*(0.15 + 0.85 ./ (1.0 + exp((dist-300)/50)));%Rm(d) = 50000(0.15 + 0.85 / (1.0 + exp((d-300)/50)))
NeuronParams(1).R_A = 5000;
NeuronParams(1).E_leak = -70;
NeuronParams(1).somaID = 1;
% NeuronParams(1).basalID 
NeuronParams(1).randomRate=0.01;


NeuronParams(2).somaLayer = 2; % input from LECIII random input 
% I need to learn how to use given firing sequence.
NeuronParams(2).modelProportion = 0.2;
NeuronParams(2).neuronModel = 'poisson';% 'adex';
NeuronParams(2).firingRate = 1000;
% NeuronParams(2).V_t = -50;
% NeuronParams(2).delta_t = 2;
% NeuronParams(2).a = 0.04;
% NeuronParams(2).tau_w = 10;
% NeuronParams(2).b = 40;
% NeuronParams(2).v_reset = -65;
% NeuronParams(2).v_cutoff = -45;
NeuronParams(2).numCompartments = 1;

% NeuronParams(2).C = 1.0*2.93;
% NeuronParams(2).R_M = 15000/2.93;
% NeuronParams(2).R_A = 150;
% NeuronParams(2).E_leak = -70;


NeuronParams(3).somaLayer = 1;     % input from MEC3
NeuronParams(3).modelProportion = 0.2;
PoissonN=0;
if PoissonN
    NeuronParams(3) = NeuronParams(2); % spiny stellates same morphology as basket
    NeuronParams(3).firingRate = 1000;
else
    NeuronParams(3).neuronModel = 'loadspiketimes';% generized spikechains.
    group1Size = NeuronParams(3).modelProportion * (TissueParams.neuronDensity * ...
        TissueParams.X * TissueParams.Y * TissueParams.Z) / 1000^3;
    spikeTimes = cell(ceil(group1Size), 1);
    tt=1:80;% [1:SimulationSettings.simulationTime]
    Inputshape=filter(sin(70*pi/625*tt).*exp(-(tt-30).^2/2/400),1,...rand(1,SimulationSettings.simulationTime)<.1);
    [zeros(1,ceil(SimulationSettings.simulationTime/2)), rand(1,floor(SimulationSettings.simulationTime/2))<.05]);
    
%     Inputshape=sin(pi/625*[1:SimulationSettings.simulationTime]);
    for k=1:group1Size
        spikeTimes{k} = find(rand(1,SimulationSettings.simulationTime)<(Inputshape/group1Size));
    end
    NeuronParams(3).numCompartments=1;
    save(['/home/weiwei/data/', FileBase, '/spikeTimesGroup1.mat'], 'spikeTimes');
    NeuronParams(3).spikeTimeFile = ['/home/weiwei/data/', FileBase, '/spikeTimesGroup1.mat'];
    
end
% NeuronParams(3).V_t = -50;         % and different AdEx parameters
% NeuronParams(3).delta_t = 2.2;
% NeuronParams(3).a = 0.35;
% NeuronParams(3).tau_w = 150;
% NeuronParams(3).b = 40;
% NeuronParams(3).v_reset = -70;
% NeuronParams(3).v_cutoff = -45;

NeuronParams(4) = NeuronParams(2); % input from CA3
NeuronParams(4).somaLayer = 3;     
NeuronParams(4).modelProportion = 0.3;
PoissonN=0;
if PoissonN
    NeuronParams(4) = NeuronParams(2); % spiny stellates same morphology as basket
    NeuronParams(4).firingRate = 1000;
else
    NeuronParams(4).neuronModel = 'loadspiketimes';% generized spikechains.
    group1Size = NeuronParams(4).modelProportion * (TissueParams.neuronDensity * ...
        TissueParams.X * TissueParams.Y * TissueParams.Z) / 1000^3;
    spikeTimes = cell(fix(group1Size), 1);
     tt=1:100;% [1:SimulationSettings.simulationTime]
    Inputshape=filter(sin(40*pi/625*tt).*exp(-(tt-30).^2/2/400),1,...
        [rand(1,floor(SimulationSettings.simulationTime/2))<.05, zeros(1,ceil(SimulationSettings.simulationTime/2))]);
    
%     Inputshape=sin(6*pi/625*[1:SimulationSettings.simulationTime]);
    for k=1:group1Size
        spikeTimes{k} = find(rand(1,SimulationSettings.simulationTime)<(Inputshape/group1Size));
    end
    NeuronParams(4).numCompartments=1;
    save(['/home/weiwei/data/', FileBase, '/spikeTimesGroup2.mat'], 'spikeTimes');
    NeuronParams(4).spikeTimeFile = ['/home/weiwei/data/', FileBase, '/spikeTimesGroup2.mat'];
    
end
%% interneuron...
IN=0;
if IN
NeuronParams(2).somaLayer = 1; % Basket cells in layer 3
NeuronParams(2).modelProportion = 0.08;
NeuronParams(2).axisAligned = '';
NeuronParams(2).neuronModel = 'adex';
NeuronParams(2).V_t = -50;
NeuronParams(2).delta_t = 2;
NeuronParams(2).a = 0.04;
NeuronParams(2).tau_w = 10;
NeuronParams(2).b = 40;
NeuronParams(2).v_reset = -65;
NeuronParams(2).v_cutoff = -45;
NeuronParams(2).numCompartments = 7;
NeuronParams(2).compartmentParentArr = [0 1 2 2 1 5 5];
NeuronParams(2).compartmentLengthArr = [10 56 151 151 56 151 151];
NeuronParams(2).compartmentDiameterArr = ...
  [24 1.93 1.95 1.95 1.93 1.95 1.95];
NeuronParams(2).compartmentXPositionMat = ...
[   0,    0;
    0,    0;
    0,  107;
    0, -107;
    0,    0;
    0, -107;
    0,  107];
NeuronParams(2).compartmentYPositionMat = ...
[   0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0];
NeuronParams(2).compartmentZPositionMat = ...
[ -10,    0;
    0,   56;
   56,  163;
   56,  163;
  -10,  -66;
  -66, -173;
  -66, -173];
NeuronParams(2).C = 1.0*2.93;
NeuronParams(2).R_M = 15000/2.93;
NeuronParams(2).R_A = 150;
NeuronParams(2).E_leak = -70;
NeuronParams(2).dendritesID = [2 3 4 5 6 7];
end
%% % [lm-o, lm-i, rad, pyr, orien]
% ConnectionParams(1).numConnectionsToAllFromOne{1}=0;
ConnectionParams(2).numConnectionsToAllFromOne=cell(1,4);
ConnectionParams(2).numConnectionsToAllFromOne{1} =zeros(5,1);% zeros(5,1);
ConnectionParams(2).numConnectionsToAllFromOne{2} = zeros(5,1);
ConnectionParams(2).numConnectionsToAllFromOne{3} = zeros(5,1);
ConnectionParams(2).numConnectionsToAllFromOne{4} = zeros(5,1);

ConnectionParams(2).synapseType{1} = 'i_exp';
ConnectionParams(2).synapseType{2} = 'i_exp';
ConnectionParams(2).synapseType{3} = 'i_exp';
ConnectionParams(2).synapseType{4} = 'i_exp';

ConnectionParams(2).tau{1} = 2;
ConnectionParams(2).tau{2} = 2;
ConnectionParams(2).tau{3} = 2;
ConnectionParams(2).tau{4} = 2;

ConnectionParams(2).targetCompartments{1} = ...
  [NeuronParams(1).lmi;NeuronParams(1).lmo;NeuronParams(1).rad];
ConnectionParams(2).targetCompartments{2} = ...
  [];
ConnectionParams(2).targetCompartments{3} = ...
  [];
ConnectionParams(2).targetCompartments{4} = ...
  [];

ConnectionParams(2).weights{1} = 200;
ConnectionParams(2).weights{2} = 10;
ConnectionParams(2).weights{3} = 10;
ConnectionParams(2).weights{4} = 10;


ConnectionParams(2).axonArborSpatialModel = 'gaussian';
ConnectionParams(2).sliceSynapses = true;
ConnectionParams(2).axonArborRadius = 250*ones(1,5);
ConnectionParams(2).axonArborLimit = 500;
ConnectionParams(2).axonConductionSpeed = 0.3;
ConnectionParams(2).synapseReleaseDelay = 0.5;
ConnectionParams(1)=ConnectionParams(2);
ConnectionParams(1).numConnectionsToAllFromOne{3} =zeros(5,1);% 
ConnectionParams(1).targetCompartments{1}=[];
% ConnectionParams(1).numConnectionsToAllFromOne{2} =[0;0;0;0;200];
ConnectionParams(3)=ConnectionParams(2);
ConnectionParams(3).numConnectionsToAllFromOne{1} =[0;2000;0;0;0];% [2000;0;0;0;0];
ConnectionParams(4)=ConnectionParams(2);
ConnectionParams(4).numConnectionsToAllFromOne{1} =[0;0;2000;0;0];% zeros(5,1);


RecordingSettings.saveDir = ['/home/weiwei/data/', FileBase];
RecordingSettings.LFP = true;
[meaX, meaY, meaZ] = meshgrid([100 200], 200, 650:(-25):0);
% I can adjust here to have a slope electrode.
RecordingSettings.meaXpositions = meaX;
RecordingSettings.meaYpositions = meaY;
RecordingSettings.meaZpositions = meaZ;
RecordingSettings.minDistToElectrodeTip = 20;
RecordingSettings.maxRecTime = 1000;
RecordingSettings.sampleRate = 1250;
%%
RecordingSettings.v_m=50:50:5000;
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim = true;%false;
[params, connections, electrodes] = ...
    initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
    RecordingSettings, SimulationSettings);
runSimulation(params, connections, electrodes);
end
Results = loadResults(RecordingSettings.saveDir)
%%
ncomp=4;
lfp=Results.LFP(1:(end/2),:);
[icasig3, gdA3, gdW3, ~]=wKDICA(diff(lfp,1,2),ncomp,0,0,0); 
[~, gdA4, gdW4, ~]=wKDICA(lfp,ncomp,0,0,0);
lambda=.01;theta=[2,1,2];csdgdA4=mkCSD(gdA4',2,[1:27]',[1:27]',lambda,theta)';
figure;plot(bsxfun(@plus,bsxfun(@rdivide,gdA4,sqrt(sum(gdA4.^2,1))),1:ncomp));
hold on;plot(bsxfun(@plus,bsxfun(@rdivide,csdgdA4,sqrt(sum(csdgdA4.^2,1))),1:ncomp),'--');
hold on;plot(bsxfun(@plus,bsxfun(@rdivide,gdA3,sqrt(sum(gdA3.^2,1))),1:ncomp),':');axis tight;grid on;
set(gca,'Xtick',[27-27*[ 450, 290, 183, 143, 0]/650],'Xticklabel',{'lmo','lmi','rad','pyr','orin'});
figure;plot(bsxfun(@plus,Zscore([gdW4;gdW3]*lfp,2),3*[1:8]')');grid on;axis tight
[Sep,malpha,n]=ReliabilityICtest(gdW4,lfp');
figure;subplot(121);imagesc(Sep);subplot(122);imagesc(malpha,[-pi/4 pi/4]);

for k=1:64;
    figure(164);subplot(211);
    imagesc(Results.LFP(1:27,((k-1)*1000+1):(k*1000)),max(abs(Results.LFP(:)))*[-1 1]);
    set(gca,'Ytick',[27-27*[ 450, 290, 183, 143, 0]/650],'Yticklabel',{'lmo','lmi','rad','pyr','orin'});
    subplot(212);
    imagesc(Results.tmLFP(1:27,((k-1)*1000+1):(k*1000)),max(abs(Results.tmLFP(:)))*[-1 1]);
    set(gca,'Ytick',[27-27*[ 450, 290, 183, 143, 0]/650],'Yticklabel',{'lmo','lmi','rad','pyr','orin'});
    pause(.5);
end