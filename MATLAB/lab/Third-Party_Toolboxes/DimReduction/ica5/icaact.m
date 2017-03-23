%
% icaact() - compute ICA activation waveforms = weights*sphere*(data-meandata)
%
% Usage:
%          >> [activations] = icaact(data,weights,sphere,datamean);
% Inputs:  
%     data,weights,sphere = runica() output variables
%                datamean = 0 or mean(data')  (default 0);
%
%  NOTE: If datamean==0, data means are distributed over activations.
%           Use this form for plotting component projections.
% Output:  
%     activations = ICA component activation waveforms 
%

% Scott Makeig, Salk Institute / La Jolla CA 4-3-97
% 6-17-97 extended to non-square weight matrices -sm

function [activations] = icaact(data,weights,sphere,datamean)

if nargin < 4
    datamean = 0;
elseif nargin < 3
    help icaact
    return
end

[chans, framestot] = size(data);

if datamean == 0,
    datamean = zeros(chans,1); % single-epoch 0s
end

if size(datamean,1) == 1    % if row vector
    datamean = datamean';   % make a column vector
end
[meanchans,epochs] = size(datamean);
if epochs < 1,
	fprintf('icaact(): datamean empty.\n');
	return
end
frames = fix(framestot/epochs);

if frames < 1,
	fprintf('icaact(): data empty.\n');
	return
end

if frames*epochs ~= framestot
	fprintf(...
   'icaact(): datamean epochs %d does not divide data length %d.\n',...
                          epochs,                           framestot);
	return
end

if size(datamean,1) ~= chans
	fprintf('icaact(): datamean channels ~= data channels.\n');
	return
end

w = weights*sphere;
activations = zeros(size(w,1),size(data,2));
for e=1:epochs
	activations(:,(e-1)*frames+1:e*frames) =  ...
        w*(data(:,(e-1)*frames+1:e*frames) - datamean(:,e)*ones(1,frames));
end
