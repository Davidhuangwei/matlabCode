function outData = SmoothSkipNaN(inData, smoothPixelRadius, initNaNsBool)
if ~exist('smoothPixelRadius','var') | isempty(smoothPixelRadius)
    smoothPixelRadius = 2;
end
if ~exist('initNaNsBool','var') | isempty(initNaNsBool)
    initNaNsBool = 0;
end

if size(smoothPixelRadius,2)==1
    smoothPixelRadius = [smoothPixelRadius(1) smoothPixelRadius(1)];
end
[m,n] = size(inData);
outData = NaN*zeros(m,n);
for i=1:m
    for j=1:n
        %keyboard
        %if ~isempty(find(~isnan(inData(max([1,i-smoothPixelRadius(1)]):min([m,i+smoothPixelRadius(1)]),...
        %        max([1,j-smoothPixelRadius(2)]):min([n,j+smoothPixelRadius(2)])))))
        if initNaNsBool | ~isnan(inData(i,j))
            try
                tempBuffer = inData(max(1,i-smoothPixelRadius(1)):min(m,i+smoothPixelRadius(1)),max(1,j-smoothPixelRadius(2)):min(n,j+smoothPixelRadius(2)));
            catch
                fprintf('SmoothSkipNaN has a problem. entering debug mode');
                keyboard
            end
            %keyboard
            
            %if ~isempty(find(~isnan(tempBuffer)))
                outData(i,j) = mean(tempBuffer(~isnan(tempBuffer)));
            %end
        end
    end
end
return