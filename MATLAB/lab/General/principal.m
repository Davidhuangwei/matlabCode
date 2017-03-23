function PD=principal(N)
% This function returns a matrix with ones if the 
% element is in the principal domain of the bispectrum
% and zeros elsewhere.
%
% Yngve@Birkelund

M=N/2+1;
PD=ones(M,M);
for k=1:M,
  for l=1:M,
    if k>l, PD(k,l)=0;end
    if (k-1)/2+l>M, PD(k,l)=0;end
  end
end

  
