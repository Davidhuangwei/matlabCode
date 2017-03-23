function [r] = CreateObservation(LObs,Source,ResiduValue,Symboles,NbTrajet,Lambda,Tau,Te,ControlPuissance,Puiss)

% Calcul de la contribution de chaque source
for (iN=0:LObs-1)
    Contribution(iN+1) = exp(2*i*pi*ResiduValue*iN)*MakeImpulse(Source,Symboles,NbTrajet,Lambda,Tau,Te,iN);
end
            
% Normalisation de la contribution
if (ControlPuissance==1)
    Contribution = sqrt(Puiss)*Contribution/sqrt(sum(abs(Contribution).^2));
end
            
r = Contribution;