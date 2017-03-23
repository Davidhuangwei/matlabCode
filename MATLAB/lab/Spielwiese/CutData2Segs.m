function [segs,NumWin,overlap] = CutData2Segs(totl,winlength,varargin)
[overlap] = DefaultArgs(varargin,{0.5});
%
% function CutData2Segs(data,winlength,varargin)
% [overlap] = DefaultAgrs(varargin,{0.5});
% 
% cuts data into overlapping segments. 
% 
% input:
%   totl: total length of data
%   winlength: window length
%   overlap: window overlap as ration (default 0.5)
% 
% output: 
%   segs: nx2 matrix with beginning and ends of segments
%

%% check window length
if winlength > totl
  error(['The windowlength must be equal or smaller than the length of the dataset!\n'])
end

overlap = overlap*winlength;

%% number of windows
NumWin = round((totl-winlength)/(winlength-overlap)+1);

if NumWin==1
  segs(1,1) = 1;
  segs(1,2) = totl;
  overlap = 0;
else
  %% recompute overlap such that NumWin windows fit
  overlap = winlength-(totl-winlength)/(NumWin-1);

  %% get beginning and ends of windows:
  segs(:,1) = [1; round([1:NumWin-1]'*(winlength-overlap))];
  segs(:,2) = segs(:,1)+winlength;
  if segs(end,2)~=totl
    segs(end,:) = segs(end,:) + (segs(end,2)-totl);
  end
end

return;