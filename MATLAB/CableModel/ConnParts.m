function [conn, ram]=ConnParts(NeuronParams)
connMatrix=zeros(NeuronParams.numCompartments);
for k=1:NeuronParams.numCompartments
connMatrix(NeuronParams.compartmentParentArr(k),k)=1;
end
connMatrix=connMatrix+connMatrix';
connMatrix(1)=0;
conn=connMatrix;
if size(NeuronParams.Ra,2)~=NeuronParams.numCompartments
    NeuronParams.Ra=NeuronParams.Ra';
end
    ram=1./((1./NeuronParams.Ra)*conn)./NeuronParams.Ra;
end
% more reasonable to write in inf and tau