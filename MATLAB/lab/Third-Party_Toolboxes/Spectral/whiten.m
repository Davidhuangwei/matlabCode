function Y=whiten(X,coef)
%WHITEN Whitens a (vector) time series by subtracting a (V)AR(p) model from it.
%
%   Y=WHITEN(X,COEF) whitens the input time series, X, by 
%   subtracting a (V)AR(p) model specified by the input COEF parameters.

%   Author:  Bijan Pesaran, July 1999 Bell Labs
%

flag=0;
chk=prod(size(coef))./min(size(coef));
p=max(size(coef)); 
if chk > max(size(coef)) flag=1; end
if flag p=min(size(coef)); end

if ~flag
    sX = size(X);
    nch = sX(1);
    nt= sX(2);
    cf(1)=1.;
    cf(2:p+1)=-coef;
    for ch = 1:nch
        Y(ch,:)=conv(X(ch,:),cf);
    end
end

if flag
    nt=max(length(X));
    
    for i=p+1:1024
        tmp=zeros(1,4);
        for j=1:p
            tmp=tmp+squeeze(squeeze(coef(:,:,j))*X(:,i-j))';
        end
        Y(:,i)=-tmp';
    end
    
end


