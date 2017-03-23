function outData = TrimBorderNaNs(inData,borderPad)
if ~exist('borderPad','var') | isempty(borderPad)
    borderPad = 1;
end

inData = [NaN*zeros(size(inData,1),borderPad), inData];
inData = [inData, NaN*zeros(size(inData,1),borderPad)];
inData = [NaN*zeros(borderPad,size(inData,2)); inData];
inData = [inData; NaN*zeros(borderPad,size(inData,2))];

[m,n] = size(inData);
temp = zeros(m,n);
temp(find(~isnan(inData))) = 1;
[a,b] = find(temp==1);
newM = [min(a)-borderPad max(a)+borderPad];
newN = [min(b)-borderPad max(b)+borderPad];
outData = NaN*zeros(newM(2)-newM(1)+1,newN(2)-newN(1)+1);
outData = inData(newM(1):newM(2),newN(1):newN(2));
return