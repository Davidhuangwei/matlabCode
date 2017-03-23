function [ContributionEst,Filter] = SubstractSource(Observations,Extracted,LFiltreSoustracteurAC,LFiltreSoustracteurC)
% SubstractSource identifie le filtre inverse permettant
% l'annulant des contributions de la source extraite
% des observations.

% On cherche un filtre de longueur 2L+1
% On utilise les moindres carrée:
% min ||AX-B||^2 : X=(A'A)^-1A'B

% A contient le signal extrait
% B contient les observations

NObs = size(Observations,1);
LObs = size(Observations,2);

u0 = 1;
% Longueur filtre anti-causal
LMax1 = LFiltreSoustracteurAC;
% Longueur filtre causal
LMax2 = LFiltreSoustracteurC;

% Génération de la matrice A:
for(ij=0:LObs-1) % Indice des lignes
    for (ii=LMax1:-1:-LMax2) % Indice de colonnes
        if (ij+u0+ii<1)
            A(ij+1,-ii+LMax1+1) = 0;
        elseif (ij+u0+ii>length(Extracted))
            A(ij+1,-ii+LMax1+1) = 0;
        else
            A(ij+1,-ii+LMax1+1) = Extracted(ij+u0+ii);
        end
    end
end

% La matrice B contient les observations
for (ii=1:NObs) % Indice de colonnes
    for(ij=0:LObs-1) % Indice des lignes
        B(ij+1,ii) = Observations(ii,u0+ij);
    end
end

Filter = inv(A'*A)*A'*B;

% On met le signal extrait dans une matrice pour le filtrage:
% for(ij=1:length(Extracted)) % Indice des lignes
%     for (ii=LMax1:-1:-LMax2) % Indice de colonnes
%         u0 = ij;
%         if (u0+ii<1)
%             Ext(ij,-ii+LMax1+1) = 0;       
%         elseif (u0+ii>length(Extracted))
%             Ext(ij,-ii+LMax1+1) = 0;
%         else
%             Ext(ij,-ii+LMax1+1) = Extracted(u0+ii);
%         end
%     end
% end

for (ii = 1:NObs)
    ContributionEst(ii,:) = conv(Filter(:,ii),Extracted);
end
ContributionEst = ContributionEst(:,LFiltreSoustracteurAC+1:size(ContributionEst,2)-LFiltreSoustracteurC);

