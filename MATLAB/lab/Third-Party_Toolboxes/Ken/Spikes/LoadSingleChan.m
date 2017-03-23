% out = LoadSingleChan(fname, nChannels, ChannelToLoad, SamplesToLoad, From)
%
% Loads a single channel from a multi-channel dat file.  Assumes 2-byte integers
%
% last 3 arguments are optional and will default to 'short', the whole file, and the beginning
%
% NB ChannelToLoad counts from 1, not 0

function out = LoadSingleChan(fname, nChannels, ChannelToLoad, SamplesToLoad, From)


if (nargin<4)
	SamplesToLoad = inf;
end

if (nargin<5)
	From = 0;
end

fp = fopen(fname, 'r');

status = fseek(fp, From*nChannels*2 + (ChannelToLoad-1)*2, 'bof');

if (status ~= 0)
	error('Error doing fseek');
end

out = fread(fp, [1, SamplesToLoad], 'int16', (nChannels-1)*2);

fclose(fp);