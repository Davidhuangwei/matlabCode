function [iSourceExtraite,MSE] = CalculCritere(Contribution,ContributionEst)

% Calcul de tous les critères
P = size(Contribution,2);
N = size(Contribution,1);
Lr = size(Contribution,3);


for (iCapteur=1:P)
    for (iSource=1:N)
        r = sum(permute(Contribution(iSource,iCapteur,:),[1,3,2]),1);
        PIN(iCapteur,iSource) = mean(abs(Contribution(iSource,iCapteur,:)).^2)/ mean(abs( r ).^ 2) * 100;

        Critere(iCapteur,iSource) = PIN(iCapteur,iSource)/100 * mean(abs(permute(Contribution(iSource,iCapteur,:),[1,3,2]) - ContributionEst(iCapteur,:)).^ 2) ...
            / mean(abs(permute(Contribution(iSource,iCapteur,:),[1,3,2])).^2);
    end
end

MSE = mean(Critere,1);

% Identification de la source extraite

I = find(MSE==min(MSE));
iSourceExtraite = I;
MSE = MSE(I);

