% function chanLoc = ChanLoc(chanLocVersion, fileExt, varargin)
% baseDir = DefaultArgs(varargin,{[SC(pwd) 'ChanInfo/']});
% chanLoc = LoadVar([SC(baseDir) 'ChanLoc_' chanLocVersion fileExt '.mat']);
% end


function chanLoc = ChanLoc(chanLocVersion, fileExt, varargin)
baseDir = DefaultArgs(varargin,{[SC(pwd) 'ChanInfo/']});
chanLoc = LoadVar([SC(baseDir) 'ChanLoc_' chanLocVersion fileExt '.mat']);
end
