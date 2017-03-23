% function outData = ExpSmooth(data,smoothKernel,smoothStep)
% Provides exponential smoothing of data. Useful for power spectral
% density of brain activity.
% 'smoothKernel' MUST HAVE ODD LENGTH
%
% CODE:
% for j=1:smoothStep:length(data)
%     data = ConvTrim(data,smoothKernel);
%     outData(j:min([j+smoothStep-1, length(data)])) = ...
%         data(j:min([j+smoothStep-1, length(data)]));
% end
%
%
% tag:smooth
% tag:conv
% tag:exponential

function outData = ExpSmooth(data,smoothKernel,smoothStep)

if ~mod(length(smoothKernel),2)
    error([mfilename ':smoothKernelMustHaveOddLength'],...
        'smoothKernel should have odd length for function to work properly')
end


for j=1:smoothStep:length(data)
    data = ConvTrim(data,smoothKernel);
    outData(j:min([j+smoothStep-1, length(data)])) = ...
        data(j:min([j+smoothStep-1, length(data)]));
end

return


    