% function chanMat = ChanMat(fileExt, varargin)
% baseDir = DefaultArgs(varargin,{[SC(pwd) ChanInfo/]});
% chanMat = LoadVar([SC(baseDir) 'ChanMat' fileExt '.mat']);
% end

function chanMat = ChanMat(fileExt, varargin)
baseDir = DefaultArgs(varargin,{[SC(pwd) 'ChanInfo/']});
chanMat = LoadVar([SC(baseDir) 'ChanMat' fileExt '.mat']);
end