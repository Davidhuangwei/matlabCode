% OK, so the task here is to generate brunch of simple cable models, with
% different compartments numbers and prunching types. aws the oblique
% brunches with different angles. 
% FOR THIS PURPOSE
% I can just generate different cables with different numbers, and record
% instead of LFP, the membrane potentials. 
% also need to varify with different synaptic time constants. use the exp
% with time constants here. 
% I can simulate with 10 sessions, where each contain 30 min. 
% well also need to resemble the normal input-output 
% as we don't need to compute the populations, we can decrease a bit the
% time steps. 
% 
% so params: 
% 1. distance between inputs 
% 2. cable numbers: 30 and 60 (should be more or less enough for a single
% cable, or 100 if you like) 
% 3. weights
% the active property
% *. shape 
%% exp for the distance between inputs
function cableEXP
cd /storage/weiwei/data/
mkdir cableEXP
% function CableModel
% here I define a single 16-compartment ball-stick model.  with some
% simplification from the work by Bedard 2009.
% so
% the parameters:
Cm = 1 ;% uF/cm2
gm = .45 ;%mS/cm2
Ra = 250 ;%o.cm
Vres = -80 ;%mV
soma = 500 ;%um2
dend_n = 15;%
dend_L = [0, 46.6*ones(1,dend_n)] ;%um
dend_d = [0, linspace(4 ,1,dend_n)] ;%um
g_exi = .73 ;%
g_inh = 3.67 ;%
conn=shift_eye(dend_n, 1)+eye(dend_n);
dt=.001;
MemC=CableModel_base(Cm, gm, Ra, Vres, soma, dend_L, dend_d, dend_n,conn, g_exi, g_inh);
MemC.dt=dt;
MemC.Eex=10;
MemC.Ein=-80;
MemC.Noise=0;
%% come to the experiment part.
% 1. distance between inputs
MemC.isARS=false;
for k=1:10
    Inputs=exp(-bsxfun(@minus, 1:(dend_n+1), [4, 16-3*k]').^2/2/4)';
    Inputs=bsxfun(@rdivide, Inputs, sum(Inputs,1));
    CableRun(MemC, Inputs, 20, 5, 30, 'RandIns');% 
end
% 
MemC.isARS=true;
MemC.tauS=[1,1];
for k=1:10
    Inputs=exp(-bsxfun(@minus, 1:(dend_n+1), [4, 16-3*k]').^2/2/4)';
    Inputs=bsxfun(@rdivide, Inputs, sum(Inputs,1));
    CableRun(MemC, Inputs, 20, 5, 30, 'RandExp');% 
end

MemC.Noise=1;
MemC.isARS=false;
for k=1:10
    Inputs=exp(-bsxfun(@minus, 1:(dend_n+1), [4, 16-3*k]').^2/2/4)';
    Inputs=bsxfun(@rdivide, Inputs, sum(Inputs,1));
    CableRun(MemC, Inputs, 20, 5, 30, 'RandInsNN');% 
end
% 
MemC.isARS=true;
MemC.tauS=[1,1];
for k=1:10
    Inputs=exp(-bsxfun(@minus, 1:(dend_n+1), [4, 16-3*k]').^2/2/4)';
    Inputs=bsxfun(@rdivide, Inputs, sum(Inputs,1));
    CableRun(MemC, Inputs, 20, 5, 30, 'RandExpNN');% 
end

end




function MemC=CableModel_base(Cm, gm, Ra, Vres, soma, dend_L, dend_d, dend_n,conn, g_exi, g_inh)
MemC.itau_m=gm/Cm; 
dend_d(1)=2*sqrt(soma/4*3);
dend_L(1)=2*sqrt(soma/4*3);
MemC.dend_d=dend_d;
dend_d=dend_d/2;% use r
% I need to know the connection matrix. 
MemC.itau_a=zeros(dend_n);
for k=2:dend_n
    for n=2:dend_n
        L= (dend_L(k) +dend_L(n))/2;
        dd=abs(dend_d(k)-dend_d(n));
        MemC.itau_a(k,n) = dend_d(k)*dend_d(n)/(sqrt(dd.^2 + L.^2)*L^2*dd);
        MemC.itau_a(n,k) = MemC.itau_a(k,n);
        MemC.itau_a(n,n) = MemC.itau_a(n,n) - MemC.itau_a(k,n); 
        MemC.itau_a(k,k) = MemC.itau_a(k,k) - MemC.itau_a(k,n); 
    end
end
MemC.itau_a=MemC.itau_a/Cm/Ra.*conn;
MemC.Vres=Vres;
MemC.itau_syne=MemC.itau_m*g_exi;
MemC.itau_syni=MemC.itau_m*g_inh;
end

function CableRun(MemC, Inputs, InputSeq, trailN, DurationM,expName)
% CableRun(MemC, Inputs, InputSeq, trailN, DurationM)
% MemC: parameter, 
% Inputs: Input location 
% InputSeq: Input sequences 
% trailN: trail number 
% DurationM: Duration in each trail (in min)
cd /storage/weiwei/data/cableEXP/
mkdir(expName)
cd(['/storage/weiwei/data/cableEXP/', expName])
dirname=pwd;
nt=DurationM*60/MemC.dt;
MemC.Eex=MemC.Eex*eye(2);
if length(InputSeq)<nt
    InputSeq = rand(2,nt)<InputSeq/1000*MemC.dt;
end
if MemC.isARS
    taus=MemC.tauS/MemC.dt;
    for k=1:2
        InputSeq(k,:)=conv(InputSeq(k,:), exp(-[1:fix(taus(k)*2)]/taus(k)),'same');
    end
end
for Ntr=1:trailN
    vm=zeros(MemC.dend_n+1, nt);
    for t=2:nt
        vm(:, t)=vm(:, t-1)+MemC.dt*(MemC.itau_m*(MemC.Vres-vm(:, t-1))  ...
                           +MemC.itau_a*vm(:, t-1) ...
                           -MemC.itau_syne*diag(vm(:, t-1))*Inputs*InputSeq(:,t)...
                           +MemC.itau_syne*Inputs*MemC.Eex*InputSeq(:,t))...
                           +randn(MemC.dend_n+1,1)*MemC.Noise;
    end
    fileName=sprintf('%s/%s.Ses%d.mat', dirname, expName, Ntr);
    fileID = fopen(fileName,'w');
    fwrite(fileID,vm,'int16');
    fclose(fileID);
end

end

