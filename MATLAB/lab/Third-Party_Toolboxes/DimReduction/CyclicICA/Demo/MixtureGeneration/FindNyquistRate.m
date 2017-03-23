function [Te] = FindNyquistRate(Source)

for (iSource=1:length(Source))

    if (strcmp(Source(iSource).Modulation,'Lineaire')==1)
        Te(iSource) = Source(iSource).Debit/(1+Source(iSource).RollOff);
    elseif (strcmp(Source(iSource).Modulation,'CPM')==1)
        Te(iSource) = Source(iSource).Debit/2;        
    end

end

Te = min(Te);
