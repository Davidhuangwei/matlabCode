function ImOut = RecolorPicture(ImIn, BlackColor, WhiteColor, Gamma)
% ImOut = RecolorFigure(ImIn, BlackColor, WhiteColor, Gamma)
%
% takes a picture, assumes its black and white, and recolors it
% linearly so that black goes to BlackColor and white goes to
% WhiteColor
%
% defaults are BlackColor [1 1 0], WhiteColor [0 0 .4]
%
% after rescaling to 0..1, image is powered to Gamma.

if nargin<2 
    BlackColor = [1 1 .4];
end
if nargin<3
    WhiteColor = [0 0 .4];
end

ImBW = mean(ImIn,3);

Sz = size(ImBW);

ImRescale = (ImBW(:)-min(ImBW(:)))/(max(ImBW(:))-min(ImBW(:)));

ImColor = repmat(BlackColor, [prod(Sz) 1]) + ImRescale.^Gamma * [WhiteColor-BlackColor];

ImOut = reshape(ImColor,[Sz 3]);