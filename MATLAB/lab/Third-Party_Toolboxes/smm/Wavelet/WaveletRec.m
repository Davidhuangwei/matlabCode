%function out = WaveletRec(y,FrRanges,sr,w0,IsLogSc)
% reconstructs the signal in FrRanges (each row - range)
function out = WaveletRec(y,FrRanges,sr,w0,IsLogSc)

nRanges = size(FrRanges,1);
out = [];
%totFr = 
%totFrRange = reshape(FrRanges,;
for i=1:nRanges
    [wave,t,f,s,p] = Wavelet(y,FrRanges(i,:),sr,w0,IsLogSc);
    n=size(wave); 
    if (length(n)>2) 
        n=n(1,end); 
        x=real(wave)./repmat(sqrt(s'),n);
        x = sum(x,2);
        out(:,:,i) = x;
    else
        x=real(wave)./repmat(sqrt(s)',n(1),1);
        x = sum(x,2);
        out(:,i) = x; 
    end
    
end

    