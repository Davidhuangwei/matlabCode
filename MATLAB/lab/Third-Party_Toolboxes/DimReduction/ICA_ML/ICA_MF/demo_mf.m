function [] = demo_mf()
close all

demo_speech

%demo_digits_and_brain_images('digits') % runs digits

%demo_digits_and_brain_images('brain') % runs brain images


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% demo speech %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = demo_speech()

% set up data 
load speech.mat
M=3;
N=8000;
Sr=S(:,1:N)./repmat(max(abs(S(:,1:N)),[],2),1,N);
sigma2=0.0;
X=A(:,1:M)*Sr(1:M,:)+sqrt(sigma2)*randn(size(A,1),N);
   
% run MF
par.sources=M; % can also be e.g. 3->2 mixing by setting M=3 and par.sources=2
A_init=[0.8944   -0.3162    0.2425;0.4472    0.9487    0.9701]; 
par.A_init=A_init(:,1:par.sources); 
% final solution somewhat dependent upon initial conditions - works well with above
par.solver='sequential'; % {'sequential','beliefprop2'}
par.S_max_ite=1000; par.tol=10^-5; par.max_ite=100;
prior.method='pos_kutorsis';
draw=2;
[Sest,Aest,ll,sigma2,chi]=ica_adatap(X,prior,par,draw);

% run ML
[SestML,AestML,llML]=icaML(X);
llML=llML/(M*N);

% plot figures

figure(1)
hold on
MMF=size(Sest,1);
corrMF=zeros(M,MMF);
k=0;
for i=1:M
  for j=1:MMF
    k=k+1;
    subplot(M,MMF,k); plot(Sr(i,:),Sest(j,:),'.')
    corrMF(i,j)=abs((Sr(i,:)*(Sest(j,:))')/sqrt(Sr(i,:)*(Sr(i,:))'*Sest(j,:)*(Sest(j,:))'));
  end
end
xlabel('true vs estimated sources - MF') 
corrMF

figure(2) 
MML=size(SestML,1);
corrML=zeros(M,MML);
k=0;
for i=1:M
  for j=1:MML
    k=k+1; 
    subplot(M,MML,k); plot(Sr(i,:),SestML(j,:),'.')
    corrML(i,j)=abs((Sr(i,:)*(SestML(j,:))')/sqrt(Sr(i,:)*(Sr(i,:))'*SestML(j,:)*(SestML(j,:))'));
  end
end
xlabel('true vs estimated sources - ML') 
corrML

figure(3)   
title('A-directions and scatter-plot of X'); hold on
plot(X(1,:),X(2,:),'.')
for i=1:M plot([0 A(1,i)],[0 A(2,i)],'g','LineWidth',2); end
n=sqrt(diag(Aest'*Aest));
for i=1:MMF plot([0 Aest(1,i)/n],[0 Aest(2,i)/n],'r','LineWidth',2); end
n=sqrt(diag(AestML'*AestML));
for i=1:MML plot([0 AestML(1,i)/n],[0 AestML(2,i)/n],'m','LineWidth',2); end

figure(4); 
for i=1:M subplot(M,1,i); plot(Sr(i,:)); end
xlabel('original data'); 

figure(5); 
for i=1:MMF subplot(MMF,1,i); plot(Sest(i,:)); end
xlabel('reconstructed data - MF');

figure(6); 
for i=1:MML subplot(MML,1,i); plot(SestML(i,:)); end
xlabel('reconstructed data - ML');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% demo digits and brain images %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  [] = demo_digits_and_brain_images(choice)

% set up data 
randn('state',0)
try
 digits=strcmp('digits',choice); 
catch
 digits=1;
end
if digits % run digits
  load digits.mat; X=X/max(max(X));
  par.sources=25;
else % run brain images
  load brain_images.mat; X=X11/max(max(X11)); 
  par.sources=9;
end   

% run MF
prior.method='positive'; % {'positive','pos_kurtosis','fa','ppca'}
par.S_max_ite=1000;
par.solver='beliefprop2'; % {'sequential'}  

bic=0; % bic or not
if bic               
  ica_adatap_bic(X,prior,par,[par.sources-2:par.sources+2]);
else
  [S,A,loglikelihood,Sigma,chi,exitflag]=ica_adatap(X,prior,par,2); 

  % plot figures 
  if digits
    figure(1)
    title('estimated sources - digits')
    colormap(1-gray);
    for mm=1:par.sources;
      subplot(sqrt(par.sources),sqrt(par.sources),mm);
      imagesc(reshape(S(mm,:),16,16)');drawnow;
    end;
  else 
    figure(1)
    title('estimated sources - brain images')
    colormap('default')
    for mm=1:par.sources;
      subplot(sqrt(par.sources),sqrt(par.sources),mm);
      imagesc(flipud(reshape(S(mm,:),29,33)'));
    end;
    figure(2)
    title('estimated mixing matrix - brain images')
    M=size(A,1);
    for mm=1:par.sources;
      subplot(sqrt(par.sources),sqrt(par.sources),mm);
      plot(1:M,A(:,mm))
      axis([1 M min(A(:,mm)) max(A(:,mm))]) 
    end;
  end
end