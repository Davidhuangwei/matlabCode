function NeuronParams=bentCell(NeuronParams,ifbent,bentfunc)
if ifbent
    fprintf('Tissue is bent with %s.',bentfunc)
    bentfunc=str2func(bentfunc);
    NeuronParams.Bent=true;
    NeuronParams=bentfunc(NeuronParams);
else
    
    NeuronParams.Bent=false;
    fprintf('Tissue not bent.')
end
% if bent, then have newfields of nLocX,  nLocY, nLocZ