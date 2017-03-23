% function varargout = TryDefault(inCell)
% e.g. [chanMat] = TryDefaults({@LoadVar,'ChanInfo/ChanMat.eeg.mat'});
function varargout = TryDefaults(inCell)

try
    varargout = inCell{1}(inCell{2:end});
catch
    varargout = [];
end
