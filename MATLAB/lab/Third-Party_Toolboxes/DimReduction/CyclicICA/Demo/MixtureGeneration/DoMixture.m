function [Obs,Contribution] = DoMixture(Param)

% [Obs,Contribution] = DoMixture(Param)
%
% This function generate some instantaneous and convolutive
% mixture of cyclostationnary source signals.
%
% This function is driven with a structure. You may use :
%
% [Obs,Contribution] = DoMixture(InstantaneousMixture)
% [Obs,Contribution] = DoMixture(ConvolutiveMixture)
%
% To simulate mixture resulting from passive listening of 
% digital communication systems.
%
% Author : Pierre JALLON
% Date of creation : 04/23/2005
% Date of last modification : 04/23/20005
%

Source = ChooseSource(Param.NbSrc,Param.NbTrajet);

% Transmitted symbols generatoin

for (iSource=1:Param.NbSrc)
    GuessTailleY(iSource) = Source(iSource).NbSymbole; 
end

GuessTailleY = max(GuessTailleY);
y = zeros(Param.NbSrc,GuessTailleY);

for (iSource=1:Param.NbSrc)
    temp = SymbolesGenerator(Source(iSource));
    y(iSource,1:length(temp))=temp;
end


% Propagation channel :

if (Param.NbTrajet==1)
    NbTrajet = ones(Param.NbCpt,Param.NbSrc);
    Tau = zeros(Param.NbCpt,Param.NbSrc);
    Lambda = 2*randn(Param.NbCpt,Param.NbSrc)+2*i*randn(Param.NbCpt,Param.NbSrc);
else
    for (iCapteur = 1:Param.NbCpt)
        for (iSource = 1:Param.NbSrc)   

        NbTrajet(iCapteur,iSource) = floor(Param.NbTrajet*rand(1,1))+1;
        Lambda(iCapteur,iSource,1:NbTrajet(iCapteur,iSource)) = 2*randn(NbTrajet(iCapteur,iSource),1) + i *2* randn(NbTrajet(iCapteur,iSource),1);
        Tau(iCapteur,iSource,1:NbTrajet(iCapteur,iSource)) = 2*rand(NbTrajet(iCapteur,iSource),1);
        
		end % for iSource
	end % for iCapteur   
    
end

% To avoid unequilibrated mixture :
Puiss = (0.5)*rand(Param.NbCpt,Param.NbSrc)+ 0.25;
for (iCapteur=1:Param.NbCpt)
    Puiss(iCapteur,:) = Puiss(iCapteur,:)./sum(Puiss(iCapteur,:));
end        

% Sampling period
Te = FindNyquistRate(Source);
%Te = 0.1;

% Observations :
LObs = GetObservationLength(Source,Te);
r =  zeros(Param.NbCpt,LObs);

clear Contribution;
        
for (iCapteur = 1:Param.NbCpt)
    for (iSource = 1:Param.NbSrc) 

        Contribution(iSource,iCapteur,:) = permute(CreateObservation(LObs,Source(iSource),0,...
            y(iSource,:),NbTrajet(iCapteur,iSource),permute(Lambda(iCapteur,iSource,:),[3,2,1]),permute(Tau(iCapteur,iSource,:),[3,2,1]),...
            Te,1,Puiss(iCapteur,iSource)),[1 3 2]);

        r(iCapteur,:) = r(iCapteur,:) + permute(Contribution(iSource,iCapteur,:),[1 3 2]);
    end 
end

Obs = r;
