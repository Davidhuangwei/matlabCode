%
% rmbase - subtract basevector channel means from multi-epoch data matrix
%
% Usage:
%       >> [dataout] = rmbase(data);
%       >> [dataout datamean] = rmbase(data,frames,basevector);
%
% data       - data matrix (chans,frames*epochs);
% frames     - data points per epoch               (0|default  -> size(data,2))
% basevector - vector of baseline frames per epoch (0|default -> none)
%

% 2-5-96  Scott Makeig, CNL/ Salk Institute, La Jolla CA as rmrowmeans.m
% 07-30-97 converted to rmbase() -sm
% 09-30-97 fixed! -sm

function [dataout,datamean] = rmbase(data,frames,basevector)

	if nargin<3,
		basevector =0;
	end;
	if nargin < 2,
		frames = 0;
	end;
	if nargin<1,
		fprintf('rmbase() needs at least one argument.\n\n');
		help rmbase;
		return
	end

	[chans framestot]= size(data);
	if frames ==0,
		frames = framestot;
	end;
    epochs = fix(framestot/frames);

	if length(basevector)>framestot,
		fprintf('rmbase() - length(basevector) > frames per epoch.\n\n');
		help rmbase;
		return
	end;

    datamean = zeros(chans,epochs);
    fprintf('removing epoch means for %d epochs\n',epochs);

    dataout = data;
    for e=1:epochs
        if basevector~=0,
			rmeans = mean(data(:,(e-1)*frames+basevector)');
		else
			rmeans = mean(data(:,(e-1)*frames+1:e*frames)');
        end;
        datamean(:,e) = rmeans';
		diff = rmeans'*ones(1,frames);
		dataout(:,(e-1)*frames+1:e*frames) = data(:,(e-1)*frames+1:e*frames) - diff;
    end;
