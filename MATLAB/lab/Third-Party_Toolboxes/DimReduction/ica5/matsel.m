% matsel() - select rows, columns, and epochs from given multi-epoch data matrix
%
% Usage:
%       >> [dataout] = matsel(data,frames,framelist);
%       >> [dataout] = matsel(data,frames,framelist,chanlist);
%       >> [dataout] = matsel(data,frames,framelist,chanlist,epochlist);
%
% data      - input data matrix (chans,frames*epochs) 
% frames    - frames (data columns) per epoch (0 -> frames*epochs)
% framelist - list of frames per epoch to select (0 -> 1:frames)
%
% chanlist  - list of chans to select (0 -> 1:chans)
% epochlist - list of epochs to select (0 -> 1:epochs)
%
% The size of dataout is (length(chanlist), length(framelist)*length(epochlist))

% 5-21-96 -sm
% 5-25-96 added chanlist, epochlist -sm
% 10-05-97 added out of bounds tests for chanlist and framelist -sm
% 02-04-00 truncate to epochs*frames if necessary -sm

function [dataout] = matsel(data,frames,framelist,chanlist,epochlist)

if nargin<1
  help matsel
  return
end

if isempty(data)
  fprintf('matsel(): empty data matrix!?\n')
  return
end

[chans framestot] = size(data);
if chans<1 
  help matsel
  return
end

if nargin < 5,
  epochlist = 0;
end
if nargin < 4,
  chanlist = 0;
end
if nargin < 3,
  fprintf('matsel(): needs at least 3 arguments.\n\n');
  return
end

if frames == 0,
  frames = framestot;
end

if framelist == 0,
  framelist = [1:frames];
end

framesout = length(framelist);

if chanlist == 0,
  chanlist = [1:chans];
end

chansout = length(chanlist);
epochs = floor(framestot/frames);

if epochs*frames ~= framestot
    fprintf(...
        'matsel(): data length %d was not a multiple of %d frames.\n',...
                          framestot,frames);
    data = data(:,1:epochs*frames);
end

if epochlist == 0,
    epochlist = [1:epochs];
end
epochsout = length(epochlist);

if max(epochlist)>epochs 
      fprintf('matsel(): max index in epochlist (%d) > epochs in data (%d)\n',...
                        max(epochlist),epochs);
      return
end

if max(framelist)>frames 
      fprintf('matsel(): max index in framelist (%d) > frames per epoch (%d)\n',...
                        max(framelist),frames);
      return
end
    
if min(framelist)<1
      fprintf('matsel(): framelist min (%d) < 1\n',...
                        min(framelist));
      return
end
    
if max(chanlist)>chans
      fprintf('matsel(): chanlist max (%d) > chans (%d)\n',...
                        max(chanlist),chans);
      return
end
    
if min(chanlist)<1
      fprintf('matsel(): chanlist min (%d) <1\n',...
                        min(chanlist));
      return
end
    
dataout = zeros(chansout,framesout*epochsout);
for e=1:epochsout
    dataout(:,framesout*(e-1)+1:framesout*e) = ...
                data(chanlist,framelist+(epochlist(e)-1)*frames); 
end

