function array=disp_patchesY(A,cscale,isplot)
%
%
%  Usage:
%   A = basis function matrix
%   m = number of rows

[sr,sc,lr,lc]=size(A);
array=zeros(sr*lr,sc*lc);
for k=1:lr
    for n=1:lc
        array(((k-1)*sr+1):(k*sr),((n-1)*sc+1):(n*sc))=squeeze(A(:,:,k,n));
    end
end
if isplot
if isempty(cscale)
    imagesc(array)
else
imagesc(array,cscale)%,'EraseMode','none',[-1 1]);
end
axis image off

drawnow
end
