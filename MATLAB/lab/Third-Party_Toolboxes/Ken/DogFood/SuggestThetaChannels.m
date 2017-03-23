% an experimental script to determine which might be good channels to
% average to produce theta
%
% MAKE IT find ones with little low-frequency power!

% function SuggestThetaChannels(FileBase,thFr)
%


if 0
	eeg = bload('/u10/ken/64trode/j360801/j360801.eeg', [57 inf]);

	for c=1:size(eeg,1)
		[b(:,:,c) f t] = specgram(eeg(c,:), 1024, 1250, 1024, 0);
	end
end

[dummy fTheta] = min(abs(f - 8));

ComplexThAmp = sq(b(fTheta,:,:));

CovMat = cov(ComplexThAmp);

% compute 1st eigenvector of (complex) covariance matrix
[v d] = eigs(CovMat,1);

subplot(3,2,1);
ComplexImage(CovMat);
title('covariance matrix');

subplot(3,2,2);
hold off; plot(v, '.')
hold on; plot(xlim, [0 0]); plot([0 0], ylim);
title('first principal component');

zoom on;
input('select desired channels by zooming, then press return here');
xl = xlim;
yl = ylim;

Good = find(real(v)>xl(1) & real(v)<xl(2) & imag(v)>yl(1) & imag(v)<yl(2));

subplot(2,1,2);
plot([mean(eeg(Good,:))', mean(eeg)', real(v.'*eeg/sum(v))']);
legend('good channels', 'all channels', 'pc');
