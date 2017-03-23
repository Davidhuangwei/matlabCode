% readfloats() - read a file of multiplexed float data
%
% Usage:   >> data = readfloats('myfile');         % read as row vector
%          >> data = readfloats('myfile',channels);    % read as matrix
% Inputs:
%         'myfile' - single-quoted pathname of a file of multiplexed floats
%         channels - number of channels (rows) in data matrix {default: 1}
% Output:   data   - matrix of float values read (or NaN if read fails)

% Scott Makeig 11-22-98 CNL / Salk Institute, La Jolla CA

function data = readfloats(filename,channels)

if nargin<1
  help readfloats
  return
elseif nargin<2
  channels = 0;
end
if ischar(channels)
  help readfloats
  return
end
if channels==0
  channels=1;
end

if ~ischar(filename)
  help readfloats
  return
end
fid = fopen(filename,'r'); 
% Note: fopen(filename,'r','b') to reverse bytes

if fid<3
  fprintf('readfloats(): file open failed.\n');
  data = NaN;
  return
end
[data samps] = fread(fid,'float');

if samps<1
  fprintf('readfloats(): no data read.\n');
  data = NaN;
  return
end
if rem(samps,channels) ~= 0
  fprintf('readfloats(): channels (%d) doesnt divide data length (%d) - reshape manually.\n',channels,samps);
else
  data = reshape(data,channels,samps/channels);
end
if fclose(fid)< 0
  fprintf('readfloats(): could not close file fid.\n');
end
