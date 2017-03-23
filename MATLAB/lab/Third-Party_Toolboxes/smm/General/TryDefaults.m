% function varargout = TryDefaults(inCell)
% e.g. [chanMat] = TryDefaults({@LoadVar,{'ChanInfo/ChanMat.eeg.mat'}});
function varargout = TryDefaults(inCell)

for j=1:size(inCell,1)
    try
        varargout{j} = inCell{j,1}(inCell{j,2}{:});
    catch
        varargout{j} = [];
    end
end