function Cells=BasicMophology(varargin)
% function Cells=BasicMophology(varargin)
% define the single cell mophology 
% and the later network is just a matrix with all the blocks in the
% diagonal 
% the dendritic tre don't need to span too much in the y dimention. ( just add a little bit ~10 /180)
% 

NeuronParams.V_t = -50;
NeuronParams.delta_t = 2;
NeuronParams.a = 2.6;
NeuronParams.tau_w = 65;
NeuronParams.b = 220;
NeuronParams.v_reset = -69;
NeuronParams.v_cutoff = -45;

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
NeuronParams.numCompartments =sum(lengths(2,:));
olengths=lengths;
lengths=lengths(1,:)./lengths(2,:);
%%
NeuronParams.compartmentDiameterArr = ...
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


compStruc=zeros(5,NeuronParams.numCompartments);
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
NeuronParams.compartmentParentArr = compStruc(2,:);
% [0, ...comp1 soma
%     1, 2, 3, 4, 5, ...comp 2:6      rad P
%     6, 6, ...comp 7:8               lm P
%     2, 3, 4, 5, 7, 7, 8, 8, ...comp 9:16   rad+lm D1
%     9, 9, 10, 10, 11,11,12,12,...comp 17:24 rad D2
%     13, 13, 14, 15, 16, 16, ... comp 25:30  lm D2
%     ones(1,4),... comp 31:34  orien p
%     31,31,32,33,34,34];  % comp 35:40 orien D
NeuronParams.compartmentLengthArr = compStruc(3,:);
% [20,...soma
%     110/5*ones(1,5),...rad P
%     200, 200,...lm P
%     3900/12*ones(1,4),2300/12*ones(1,2),...rad+lm D1
%     3900/12*ones(1,8),...rad D2
%     2300/12*ones(1,6),...lm D2
%     5500/10*ones(1,10)];% comp orien p+D

NeuronParams.compartmentXPositionMat = zeros(NeuronParams.numCompartments,2);
NeuronParams.compartmentYPositionMat = zeros(NeuronParams.numCompartments,2);
NeuronParams.compartmentZPositionMat = zeros(NeuronParams.numCompartments,2);
NeuronParams.compartmentZPositionMat(1,:)=[-20 0];
for k=2:NeuronParams.numCompartments
    pp=compStruc(2,k);
    if compStruc(1,k)==11
        endp=1;
    else
        endp=2;
    end
    NeuronParams.compartmentXPositionMat(k,:)=NeuronParams.compartmentXPositionMat(pp,endp)+...
        [0, compStruc(3,k)*sin(pi/180*compStruc(4,k))*cos(pi/180*compStruc(5,k))];
    NeuronParams.compartmentYPositionMat(k,:)=NeuronParams.compartmentYPositionMat(pp,endp)+...
        [0, compStruc(3,k)*sin(pi/180*compStruc(4,k))*sin(pi/180*compStruc(5,k))];
    NeuronParams.compartmentZPositionMat(k,:)=NeuronParams.compartmentZPositionMat(pp,endp)+...
        [0, compStruc(3,k)*cos(pi/180*compStruc(4,k))];
end
NeuronParams.rad = find((NeuronParams.compartmentZPositionMat(:,2)>0)&(NeuronParams.compartmentZPositionMat(:,2)<110));
NeuronParams.lmi = find((NeuronParams.compartmentZPositionMat(:,2)>=110)&(NeuronParams.compartmentZPositionMat(:,2)<=260));
NeuronParams.lmo=find(NeuronParams.compartmentZPositionMat(:,2)>=250);



% connection matrix should have all 1/tau+or - 2*1/Ra entrys in hte diag
% while the connected ones have - or + 1/Ra in rows.
% then we also have the connection in by synapsis. 
% 1. synapses have their own activity recorded.
% 2. the connection matrix is ncomp*nsyn
% 3. the injected currents and the activity of the synapses should be
% recorded. activity of the synapses is recorded as connection matrix *syn
% 4. synaptic activity only use exp or say, 1st order 
% 5. active channels can be added directly to the voltage at every time
% point
% 6. the time step be 0.05 ms.
% 7. LFP recording step: 0.8 ms.
% 8. the synaptic activity is recorded the same time as LFP
% 9. the noise. 
% 1) how to record the noise? if the kernel is designed as
% causal filter, then the noise effect before should be recorded. however,
% the noise during the recording interval is not tracable. 
% 2) say that the noise is somehow iid, then probably is everaged out
% during the integration in the interval. 
% 3) so, let's try start with recording the instantineous noise first. 
% 10. because the Ra is not consistant along the cell, so it's not possible
% to only use converlution. <-- well i can test it. 
% the input could directly merged into the activity of syn input. not
% necessare to have another neuron network. 

