% function varargout = TryFunc(varargin)
% e.g. [chanMat] = TryFunc(@LoadVar,'ChanInfo/ChanMat.eeg.mat');
function [varargout] = TryFunc(varargin)

try
    varargout = {varargin{1}(varargin{2:end})};
catch
    varargout = {[]};
end
