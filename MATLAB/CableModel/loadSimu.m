function Data=loadSimu(FileBase,nch,varargin)
% function Data=loadSimu(FileBase,nch,Period,Channels)

m = memmapfile(FileBase,'Format','int16');
lD=length(m.Data);
if (lD<1)||~mod(lD,nch)
    Data=[];
    return
end
nt=lD/nch;
if nargin>2
    Period=varargin{1};
else
    Period=1:nt;
end
tt=false(1,lD);
for k=1:size(Period,1)
tt(((Period(k,1)-1)*nch+1):(Period(k,2)*nch))=true;
end
Data=cast(reshape(cast(m.Data(tt),'double'),nch,[])','double');%m.Data()
if nargin>3
    HP=varargin{4};
    Data=Data(:,HP);
end