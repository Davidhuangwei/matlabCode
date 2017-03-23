function [Step] = ComputeOptimalStep(r1,r2,FreqCycl)
%
% [Step] = ComputeOptimalStep(g,y)
%
% This function compute the optimal step. 
%
%
% Author : Pierre JALLON
% Date of creation : 04/23/2005
% Date of last modification : 04/23/20005
%

Longueurr = length(r1);
module_carre_r2 = abs(r2).^2;
module_carre_r1 = abs(r1).^2;
reel_r1_r2 = real(conj(r1).*r2);

carre_r2 = r2.^2;
carre_r1 = r1.^2;
r1_r2 = r1.*r2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Le numérateur               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%P1 correspond à E|x|^4

P1 = mean([abs(r2).^4;...
	   4*module_carre_r2.*reel_r1_r2;...
	   2*module_carre_r2.* module_carre_r1 + 4*reel_r1_r2.^2;...
	   4*reel_r1_r2.*module_carre_r1;...
	   abs(r1).^4].');


P3 = [mean(carre_r2);2*mean(r1_r2);mean(carre_r1)].';
P3 = abs(conv(P3,P3));

N = P1-P3;

if (length(FreqCycl)>0)
    for (iC=1:length(FreqCycl));
        Exp(iC,:) = exp(-2*i*pi*FreqCycl(iC)*(1:length(module_carre_r2)));
    end
    PC = [1/length(module_carre_r2)*module_carre_r2*(Exp.');2*1/length(reel_r1_r2)*reel_r1_r2*(Exp.');1/length(module_carre_r1)*module_carre_r1*(Exp.')].';
    for (iC=1:length(FreqCycl));
        PC_temp(iC,:) = abs(conv(PC(iC,:),PC(iC,:)));
    end
    PC = 4*sum(PC_temp,1);
    
    PNC = [1/length(carre_r2)*carre_r2*(Exp.');2*1/length(r1_r2)*r1_r2*(Exp.');1/length(carre_r1)*carre_r1*(Exp.')].';
    for (iC=1:length(FreqCycl));
        PNC_temp(iC,:) = abs(conv(PNC(iC,:),PNC(iC,:)));
    end
    PNC = 2*sum(PNC_temp,1);

else
    PC = 0;
    PNC = 0;
end

N = N - PC - PNC;

dN = [4*N(1),3*N(2),2*N(3),N(4)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Le dénominateur             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

D = [mean(module_carre_r2).^2;...
     4*mean(reel_r1_r2)*mean(module_carre_r2);...
     2*mean(module_carre_r2)*mean(module_carre_r1)+ 4*mean(reel_r1_r2)^2;...
     4*mean(reel_r1_r2)*mean(module_carre_r1);...
     mean(module_carre_r1).^2].';

dD = [4*D(1),3*D(2),2*D(3),D(4)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcul des racines et du    %
% meilleur pas                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

racine = roots(conv(N,conv(dN,D)-conv(dD,N)));
%racine = racine(find(imag(racine)==0));

for (j=1:length(racine))
	J(j) = (ComputeCritere(r1+racine(j)*r2,FreqCycl)).^2;
end

I = find(J==max(J));
Step = racine(I(1));
