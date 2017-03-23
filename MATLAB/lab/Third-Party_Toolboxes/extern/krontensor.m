function ut=krontensor(varargin)
%
% C=krontensor(A_{ij},B_{kl}) constructs a new tensor C_{ijkl}
%
% Arbitrary number of arguments.

utsize=mysize(varargin{1});
ut=varargin{1};
for i=2:nargin
  utsize=[utsize,mysize(varargin{i})];
  ut=kron(ut,varargin{i});
end;

ut=reshape(ut,makesize(utsize));

function si=mysize(A)
%
si=size(A);
if (length(si)==2) & min(si)==1
  si=max(si);
end;

function si=makesize(siz)
%
si=siz;
if (length(si)<2) 
  si=[si,ones(1,2-length(si))];
end;

function A=kron(B,C)
%
A=repmat(B(:),[1 prod(size(C))]).*repmat(C(:)',[prod(size(B)) 1]);
