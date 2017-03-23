%function out = WaveletPowRec(y,FrRanges,sr,w0,IsLogSc)
% wavelet reconstruction of signal with sampling rate sr
% reconstructs the signal in FrRanges (each row - range)
% w0 and IsLogScale controls the mother wavelet selection and 
% wether scaling will be done on equally spaces ort log scale
function [out, wrec] = WaveletPowRec(y,FrRanges,sr,w0,IsLogSc)
global memcont;
nRanges = size(FrRanges,1);
out = [];wrec=[];
%totFr = 
%totFrRange = reshape(FrRanges,;
memcont(end+1) =FreeMemory;
for i=1:nRanges
    [wave,t,f,s] = Wavelet(y,FrRanges(i,:),sr,6,IsLogSc);
    n=size(wave,1);
    x=abs(wave).^2./repmat(s',n,1);
    x= sum(x,2);
    x=x(:);
    if (nargout>1)
        x1=real(wave)./repmat(sqrt(s'),n,1);
        x1=sum(x1,2);
        x1=x1(:);
        wrec(:,i)=x1;
    end
    out(:,i) = x;
end
if (IsLogSc)
    dj =0.03;% check if not changed in the Wavelet function
    out = dj*out/0.76/sqrt(sr);
    wrec = dj*wrec/0.58/sqrt(sr);
end
clear x x1
memcont(end+1) =FreeMemory;
