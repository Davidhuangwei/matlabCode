%
% eyeLike - calculate a permutation matrix P and a scaling (diagonal) maxtrix S
%           such that S*P*E is eyelike (so permutation acts on the rows of E).
%           E must be a square matrix.
% Usage:
%        >> [eyelike, S, P]= eyeLike(E);

% Contributed 3/2/00 by Benjamin Blankertz (blanker@first.gmd.de)

function [eyelike, S, P]= eyeLike(E)

[N, M]= size(E);
if N ~= M
  fprintf('eyeLike(): input matrix must be square.\n');
  return
end

R= E./repmat(sum(abs(E),2),1,N);
Rabs= abs(R);
P= zeros(N);
for n=1:N
  [so, si]= sort(-Rabs(:));
  [chosenV, chosenH]= ind2sub([N N], si(1));
  P(chosenH,chosenV)= 1;
  Rabs(chosenV,:)= repmat(-inf, 1, N);
  Rabs(:,chosenH)= repmat(-inf, N, 1);
end
S= diag(1./diag(P*E));

eyelike= S*P*E;
