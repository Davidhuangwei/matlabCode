function [h] = MakeImpulse(Source,Symbole,NbTrajet,Lambda,Tau,Te,k)

if (strcmp(Source.Modulation,'Lineaire')==1)
    if (Source.Debit==Te)
        h = 0;
        for (iTrajet=1:NbTrajet)
            if (k+2-iTrajet>0)
                h = h+Lambda(iTrajet)*Symbole(k+2-iTrajet);
            end
        end
    else
        alpha = 10; % Nombre de période dans la racine de Nyquist.
        h = 0;
        iTsmin = max(-alpha+floor(k*Te/Source.Debit),0);
        iTsmax = min(length(Symbole)-1,alpha+floor(k*Te/Source.Debit));
      
        for (iTs=iTsmin:iTsmax)
            Temp = 0;
            for (iTrajet=1:NbTrajet)
                Temp =  Temp+Lambda(iTrajet)*GetNyquist(Source.RollOff,Source.Debit,k*Te-iTs*Source.Debit-Tau(iTrajet));   
            end
	    
                Temp = Temp * Symbole(1,iTs+1);
            h = h + Temp;
        end
    end
    
elseif (strcmp(Source.Modulation,'CPM')==1)

    h = 0;
    for (iTrajet=1:NbTrajet)
        n = floor((k*Te-Tau(iTrajet))/Source.Debit);
        if (n>=Source.LongueurFiltre)
            Termes_Precedents = sum(Symbole(1:n-Source.LongueurFiltre+1));
        else
            Termes_Precedents = 0;
        end
        Symb = Symbole(n+1:-1:max(1,n-Source.LongueurFiltre+2));
        t = k*Te-Tau(iTrajet)-(n-(0:length(Symb)-1))*Source.Debit;
        if (strcmp(Source.FiltreMiseEnForme,'LRC')==1)
            Fonc = (t)/(Source.LongueurFiltre*Source.Debit)-1/(2*pi)*sin(2*pi*t/(Source.LongueurFiltre*Source.Debit))/(Source.LongueurFiltre*Source.Debit);
        else
            Fonc = (t)/(Source.LongueurFiltre*Source.Debit);
        end
        Terme_Courants = sum(Symb.*Fonc);
        h = h + Lambda(iTrajet)*exp(i*pi*Source.IndiceModulation*(Termes_Precedents+Terme_Courants));
    end
end


    
