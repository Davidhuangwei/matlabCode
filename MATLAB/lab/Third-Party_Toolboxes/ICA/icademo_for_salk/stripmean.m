function im2 = stripmean(im1, type)

% function im2 = stripmean(im1, type)
%
% remove space/time means from image block
%
% im1  = input (nrxnc) x nt array
% type = 's'  remove space mean
%        't'  remove time mean
%        'st' remove both
%
% im2  = output array

[nrxnc, nt] = size(im1);

if ismember('s', type)
	m = mean(im1);
	m = m(ones(nrxnc, 1), :);
	im1 = im1-m;
end

if ismember('t', type)
	im1 = im1';
	m = mean(im1);
	m = m(ones(nt, 1), :);

	im2 = im1-m;
	im2 = im2';
else
	im2 = im1;
end
