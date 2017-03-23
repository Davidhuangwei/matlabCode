% Generate sine wave data

f1=10; 
f2=20; 
ns=125; 
noise=0.3; 
t=[1/ns:1/ns:1];
x=[sin(2*pi*f1*t)+noise*randn(size(t)) sin(2*pi*f2*t)+noise*randn(size(t))]; 
plot(x);

hmm.data.Xtrain=x(:); hmm.data.Xtest=x(:); hmm.data.T=length(x);


% Specify HMM-AR model
hmm.K=2; 
hmm.P=init_trans(hmm.K, 1, ns); 
hmm.obsmodel='AR';

p=8;

% Initialise AR models using Penny and Roberts method
%hmm = init_ar (x,ns,p,hmm,[],[],0.1,0);
hmm = init_ar (x,ns,p,hmm,[],[],[],0);

% Initialise AR models using `random method' 
%for k=1:hmm.K,
%  hmm.state(k).p=p;
%  hmm.state(k).a=rand(p,1);
%  hmm.state(k).v=0.1; 
%end


% Update observation model hmm.train.obsupdate=ones(1,hmm.K);
hmm.train.tol=0.01; 
hmm.train.init=1; 

% Train using EM
hmm=hmmtrain(hmm.data.Xtrain,hmm.data.T,hmm);

% Viterbi decoding
[block,LL]=hmmdecode(hmm.data.Xtrain,hmm.data.T,hmm);

hold on
plot(block.gamma(:,1),'r');  % single state decoding
plot(block.q_star,'k'); % viterbi decoding

disp('Black = viterbi state decoding');
disp('Red = instantaneous proby of state 1');

% Plot associated spectra
figure
for k=1:hmm.K,
  [p,f] = ar_spec (hmm.state(k).a,hmm.state(k).v,ns);
  subplot(hmm.K,1,k);
  plot(f,p);
end



