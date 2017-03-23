% function badChan = BadChan(fileExt, varargin)
% baseDir = DefaultArgs(varargin,{[SC(pwd) 'ChanInfo/']});
% badChan = LoadVar([SC(baseDir) 'BadChan' fileExt '.mat']);
% end

function badChan = BadChan(fileExt, varargin)
baseDir = DefaultArgs(varargin,{[SC(pwd) 'ChanInfo/']});
badChan = load([SC(baseDir) 'BadChan' fileExt '.txt']);
end
