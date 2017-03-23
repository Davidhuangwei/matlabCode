
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%    Function to remove lines:                                         %
%    Inputs: data                            data(channels,indx)  R   %
%            frequencies to be removed       fn                    R   %
%            sampling frequency              Fs                    R   %
%            time-bandwidth parameter        NW                    R   %
%            Time window                     Tw                    R   %
%            Shift window                    Tshift               Tw/2 %
%            parameter for 1-step dependency beta                  0.9 %
%                                                                      %
%     Output: Transformed data   F                                     %
%              time               time                                 %
%              Xest               Estimated amplitudes                 %
%              Fstat              Fstatistics for each window          %
%                                                                      %
%     models the harmonic as linear within window and interpolates    %
%     between windows to take care of non-linearity::                 %
%                X(t)=[a(t)+t b(t-tmp))]exp(2\pi i fn (t-tmp))+\eta    % 
%                tmp is the midpoint of the window                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [F,time,Xest,Fstat]=fitlines2(data,fn,Fs,NW,Tw,Tshift,beta)
%
%     Check for input arguments, set defaults if necessary
%
if isempty(data)
   fprintf('need data\n');
   return;
elseif isempty(fn)
   fprintf('need frequencies to be removed\n');
   return;
elseif isempty(Fs)
   fprintf('need sampling frequencies\n');
   return;
elseif isempty(NW)
   fprintf('need time-bandwidth parameter\n');
   return;
elseif isempty(Tw)
   fprintf('need window size\n');
   return;
elseif isempty(Tshift)
   Tshift=Tw/2;
elseif Tshift==Tw
   fprintf('reduce Tshift\n');
   return;
end;
if isempty(beta)
   beta=0.9;
end;

if Tshift<Tw/2;
disp('increase shift');
return;
end;
%
%     Initialize quantities
%
Nchannels=length(data(:,1));
NT=length(data(1,:));
Nt=Tw*Fs; 
Nshift=Tshift*Fs;
nn=0;
while Nshift*nn+Nt<=NT nn=nn+1; end;
Nwindows=nn;
%
%     Calculate tapers, sum_over_time(tapers) and sum_over_time(time*tapers)
%
K=2*NW-1;
u=dpss(Nt,NW,K);
time=[-Nt/2:Nt/2-1]./Fs;
avetu=(time*u)';
aveu=(sum(u,1))';

X=zeros(2,Nwindows);
Xest=zeros(2,Nshift*(Nwindows-1)+Nt);
F=zeros(Nchannels,length(Xest(1,:)));
Fstat=zeros(Nchannels,Nwindows);
%
%     Set up the padding factors for the fft
%
pad = 5;
nextpowerof2=2^(floor(log(Nt)/log(2))+1);
length_fft=pad*nextpowerof2;
df=Fs/(length_fft-1);
nfn=round(fn/df)+1;
f=nfn*df;
%
%     calculate the overlap filter
%
overlap=[0:1/(Nt-Nshift):(Nt-Nshift-1)/(Nt-Nshift)];
alpha=0.5*(1+cos(overlap*pi));

for c=1:Nchannels;
   fprintf('channel = %d\n',c);
   FF=(squeeze(data(c,:)))';
   for iwindow=1:Nwindows;
      indx=[(iwindow-1)*Nshift+1:(iwindow-1)*Nshift+Nt];
%
%              Extract data from a particular time window
%
       GG=FF(indx);
%
%              Multiply by the tapers; gives a Tw*K matrix
%              Fourier transform with taper; gives a K dimensional row vector
%
       for k=1:K;  GGu(:,k)=GG.*u(:,k);  end;
       ggfft=fft(GGu,length_fft);
       gg=squeeze(ggfft(nfn,:));

       X(:,iwindow)=[(gg*aveu)/(norm(aveu)*norm(aveu));
	(gg*avetu)/(norm(avetu)*norm(avetu))];
%
%             Compute Fstatitics
%
        numerator=(K-1)*abs(X(1,iwindow))*abs(X(1,iwindow))*norm(aveu)*norm(aveu);
        denominator=(norm(squeeze(ggfft(nfn,:)-X(1,iwindow)*aveu')))^2;
        Fstat(c,iwindow)=numerator/denominator;

   end;

   for iwindow=2:Nwindows;
	X(:,iwindow)=beta*X(:,iwindow)+(1-beta)*X(:,iwindow-1);
   end;


   tmidpt=Nt/2/Fs;
   Xest(1,1:Nshift)=(X(1,1)-tmidpt*X(2,1));
   Xest(2,1:Nshift)=X(2,1);
   for iwindow=2:Nwindows;
      tmidptl=tmidpt;
      tmidpt=tmidpt+Nshift/Fs;
      jl=Nshift*(iwindow-1)+1;
     ju1=Nshift*(iwindow-2)+Nt;
     if iwindow<Nwindows;
         ju2=Nshift*iwindow;
     else
        ju2=Nshift*(iwindow-1)+Nt;
     end;

     x1l=(X(1,iwindow-1)-tmidptl*X(2,iwindow-1));
     x1r=(X(1,iwindow)-tmidpt*X(2,iwindow));
     x2l=X(2,iwindow-1);
     x2r=X(2,iwindow);

     Xest(1,jl:ju1)=alpha.*x1l+(1-alpha).*x1r;
     Xest(2,jl:ju1)=alpha.*x2l+(1-alpha).*x2r;
     if ju1+1<=ju2;
         Xest(1,ju1+1:ju2)=x1r;
         Xest(2,ju1+1:ju2)=x2r;
     end;
  end;

time=[0:length(Xest(1,:))-1]./Fs;
Amplitude=squeeze(Xest(1,:))+time.*squeeze(Xest(2,:));
F(c,:)=2.*real(Amplitude.*exp(2*pi*i*fn*time));

end;


