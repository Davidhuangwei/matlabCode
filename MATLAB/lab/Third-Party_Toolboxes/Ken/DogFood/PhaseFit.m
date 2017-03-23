% Investigate whether a flat, unimodal, or bimodal distribution fits best
% through cross-validation

function Out = PhaseFit(SpkPh)

if 0
AllSpkPh = load('/u15/xaj/Awake/l23-01/n4.spkph');
Clu = LoadClu('/u15/xaj/Awake/l23-01/n4.clu');

SpkPh = AllSpkPh(find(isfinite(AllSpkPh) & Clu==5));
end

SpkPh = mod(SpkPh(find(isfinite(SpkPh))), 2*pi);

n = length(SpkPh);

if n<5
    Out.L0=NaN; Out.L1=NaN; Out.L2=NaN; Out.n = n;
    return;
end
    

% fit flat distribution
Out.L0 = -n*log(2*pi);

% fit unimodal distribution
TrainFn = 'VonMisesFit';
TestFn = inline('log(VonMisesPdf(x,P1,P2))',2);
Out.L1 = CrossValGen(SpkPh, TrainFn, TestFn, 10, 2);

% fit bimodal distribution
TrainFn = 'BiVonMisesFit';
TestFn = inline('log(frac.*VonMisesPdf(th,mu,k) + (1-frac).*VonMisesPdf(th,mu+pi,k))', ...
    'th', 'frac', 'mu', 'k');

Out.L2 = CrossValGen(SpkPh, TrainFn, TestFn, 10, 3);
Out.n = n;

return

[CellIDs CellNames] = FindCells('extra', 20, 'p', 'Run');
Out = ForCells(CellIDs, 'PhaseFit(SpkPh)');

Out2 = StructArray(Out);
Out2.d01 = Out2.L1-Out2.L0;
Out2.d02 = Out2.L2-Out2.L0;
Out2.d12 = Out2.L2-Out2.L1;

% [Out.MaxL Champ] = 

