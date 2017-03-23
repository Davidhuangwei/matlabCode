function CalcRunBehavTimes(description,fileBaseCell,midPointsBool,varargin)

chanInfoDir = 'ChanInfo/';

[trialTypesBool,excludeLocations,minSpeed] = ...
    DefaultArgs(varargin,{[1 1 1 1 1 1 1 1 1 1 1 1 0],[1 1 1 0 0 0 0 0 0],0});
