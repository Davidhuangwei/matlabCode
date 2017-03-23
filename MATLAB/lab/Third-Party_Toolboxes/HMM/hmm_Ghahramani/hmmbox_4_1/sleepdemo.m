% A demonstration of the HMM software using a Gaussian observation
% model on AR features extracted from an overnight sleep EEG  recording.
clear
disp(sprintf(['A demonstration of the HMM software using a Gaussian' ...
	      ' observation model on AR features extracted from an' ...
	      ' overnight sleep EEG  recording.\n']));
disp(sprintf('Press a key to continue\n\n'));
pause;


load 14ar.mat
T=size(A,1);
figure
plot(hyp),title('Hypnogram'),drawnow;

disp(sprintf(['The data are Autoregressive coefficients extracted from' ...
	      ' sleep EEG recordings. The figure the manually scored' ...
	      ' sleep profile, the so-called hypnogram\n']));
disp(sprintf('Press a key to continue\n\n'));
pause;


% Train up GMM on this data
hmm.K=7;
disp(sprintf('Initialising a GMM to %d kernels (Might take a while!)\n\n', ...
	      hmm.K));

hmm=hmminit(A,hmm);
hmm.obsmodel='Gauss';
obsoptions=struct('prrasc',1);
hmm=obsinit(A,hmm,obsoptions);


disp(sprintf(['I can set the priors so as to emphasis on fewer transitions' ...
	      ' between sleep stages, or by extracting the prior ' ...
	      'information from the hypnogram\n']));
disp(sprintf('Press a key to continue\n\n'));
pause;


% emphasising on few transitions
hmm.priors.Dir2d_alpha=ones(hmm.K)+2*eye(hmm.K);

% Alternatively, we can train the model by setting the priors
% according ot the hypnogram
%   N=length(hyp);
%   [H,X,Ntot]  = mdhistogramm([hyp(1:N-1) hyp(2:N) ],[7 7]);
%   hmm.priors.Dir2d_alpha=ceil(ceil(rdiv(H,sum(H,2))*100/50))'+1;

hmm.train.obsupdate=ones(1,hmm.K);    % update observation models ?
hmm.train.init=1;         % Yes, we've already done initialisation

disp(sprintf('We will now train the HMM using Baum/Welch\n'));
disp(sprintf('Press a key to continue\n\n'));
pause;

hmm=hmmtrain(A,T,hmm);

[block]=hmmdecode(A,T,hmm);

disp(sprintf('Sorting and filtering State sequence \n'));
disp(sprintf('Press a key to continue\n\n'));
pause;

% sorting the labels s.t. lowest starts first
block.sq_star=ones(size(block.q_star));
l=block.q_star(1);
for i=1:hmm.K
  ndx=find(~ismember(block.q_star,l));
  block.sq_star(ndx(:))=block.sq_star(ndx(:))+ones(1,length(ndx));
  if isempty(ndx), break; else l=[l block.q_star(ndx(1))]; end;
end;

figure
subplot(211),plot(hyp),title('(Manual) Hypnogramm');
subplot(212),plot(movmed(block.sq_star,11)),
title('HMM Classification (11pt Median Filtered)');

disp(' ');
disp(sprintf(['The comparison shows that HMMs typically merge several' ...
	     ' manually scored states into one state. That is in part' ...
	     ' because the human labels might apply to only a fraction' ...
	     ' of the scoring window, whilst HMMs have much higher' ...
	     ' resolution\n\n\n']));
	     






