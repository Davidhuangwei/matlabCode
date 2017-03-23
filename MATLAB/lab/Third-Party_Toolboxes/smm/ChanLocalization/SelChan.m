% function selChan = SelChan(fileExt, varargin)
% baseDir = DefaultArgs(varargin,{[SC(pwd) 'ChanInfo/']});
% selChan = LoadVar([SC(baseDir) 'SelChan' fileExt '.mat']);
% end

function selChan = SelChan(fileExt, varargin)
baseDir = DefaultArgs(varargin,{[SC(pwd) 'ChanInfo/']});
selChan = LoadVar([SC(baseDir) 'SelChan' fileExt '.mat']);
end
