% function [nearVals varargout] = FindNearest(val,vec,varargin)
% nNear = DefaultArgs(varargin,{1});
% varargout = {nearInds};
% nearInds = find(abs(val-vec)==min(abs(val-vec)),nNear);
% nearVals = vec(nearInds);
% varargout = {nearInds};
function [nearVals varargout] = FindNearest(val,vec,varargin)
nNear = DefaultArgs(varargin,{1});

nearInds = find(abs(val-vec)==min(abs(val-vec)),nNear);
nearVals = vec(nearInds);
varargout = {nearInds};