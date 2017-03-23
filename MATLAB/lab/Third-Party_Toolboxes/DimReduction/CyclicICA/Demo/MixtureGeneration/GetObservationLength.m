function [LObs] = GetObservationLength(Source,Te)

for (iSource = 1:length(Source)) 
    NSignal(iSource) = floor(Source(iSource).NbSymbole*Source(iSource).Debit/Te);
end 

LObs = min(NSignal);

