function [Resu] = ChooseSource(NbSrc,NbTrajet)

%
% [Resu] = ChooseSource(NbSrc,NbTrajet)
%
% Author : Pierre JALLON
% Date of creation : 04/23/2005
% Date of last modification : 04/23/20005
%

% Source signal properties :
% Linearly modulated signal and CPM

SourceStruct = struct(...
    'Modulation'            ,'',...
    'Constellation'         ,'',...
    'NbSymbole'             ,0,...
    'Debit'                 ,1,...
    'FiltreMiseEnForme'     ,'',...         // CPM
    'LongueurFiltre'        ,1,...          // CPM
    'IndiceModulation'      ,0.7,...        // CPM
    'RollOff'               ,0.5);

Source(1) = struct(SourceStruct);
Source(1).Modulation = 'Lineaire';
Source(1).Constellation = 'QPSK';
if (NbTrajet==1)
    Source(1).NbSymbole = 400;
else
    Source(1).NbSymbole = 2000;
end
Source(1).Debit = 3;
Source(1).FiltreMiseEnForme = 'Nyquist';
Source(1).RollOff = 0.2;

Source(2) = struct(SourceStruct);
Source(2).Modulation = 'Lineaire';
Source(2).Constellation = '8-PSK';
if (NbTrajet==1)
    Source(2).NbSymbole = 300;
else
    Source(2).NbSymbole = 1500;
end
Source(2).Debit = 4;
Source(2).FiltreMiseEnForme = 'Nyquist';
Source(2).RollOff = 0.5;

Source(3) = struct(SourceStruct);
Source(3).Modulation = 'CPM';
Source(3).Constellation = 'BPSK';
if (NbTrajet==1)
    Source(3).NbSymbole = 300;
else
    Source(3).NbSymbole = 1500;
end
Source(3).Debit = 4;
Source(3).FiltreMiseEnForme = 'REC';
Source(3).LongueurFiltre = 1;
Source(3).IndiceModulation = 0.5;

I = floor(length(Source)*rand(1,NbSrc));
SelectedSource = (I+1);

for (iNbSrc=1:NbSrc)
    Resu(iNbSrc) = Source(SelectedSource(iNbSrc));
end

