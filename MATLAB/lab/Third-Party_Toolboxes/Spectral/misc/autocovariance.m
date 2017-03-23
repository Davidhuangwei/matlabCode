%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    %  Plot the autocovariance %
%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%

     function autocovariance
     
     load eg2
     
     Tint1 = [1.5 2];
     NT = 13;
     T = Tint1(2)-Tint1(1);
     DD = zeros(size(D));
     for n=1:13
       indx = find(D(n,:)<Tint1(2) & D(n,:)>Tint1(1));
       DD(n,1:length(indx)) = D(n,indx)-Tint1(1);
       ND(n) = length(indx);
     end  
     
     ND
     
     
     D = DD;

     disp('Plot the autocovariance')

%    Autocorrelation type : 1 = basic : 2 = - poisson corr 
%                           3 = -poisson corr & normalized

     N_bins = 100;
     spc = T/(N_bins-1);
     X = linspace(spc/2,0.5,N_bins);
     M = zeros(1,N_bins); 
     N = zeros(NT,N_bins);
     
     for tr = 1:NT
       disp(['Trial = ' num2str(tr) ': Points = ' ...
	      num2str(ND(tr)) ' : Point pairs ' ...
	      num2str(ND(tr)*(ND(tr)-1)/2)]);
       clear Ac       
       indx = 0;      
       for t = 1:ND(tr)-1
         for tau = t+1:ND(tr)
           tp = D(tr,tau) - D(tr,t);
           indx = indx + 1;
   	     Ac(indx) = tp;
	      end        	      
       end            
       Ac = sort(Ac); 
       Mean_N = ND(tr)*(ND(tr)-1)*(T-X)*spc/(T^2);
       N(tr,:) = hist(Ac,X)-Mean_N;
     end              
     
     mu = mean(N);
     plot(X,mu,'r-')
     hold on
     plot(X,mu,'r.')
     
     % do bootstrap variance
     
     boot = 5;
     mub = zeros(boot,N_bins);
     for b=1:boot
       indx = floor(NT*rand(NT,1))+1;
       NN = N(indx,:);
       mub(b,:) = mean(NN);
     end
     err = std(mub);
     plot(X,mu+2*err,'g-');
     plot(X,mu-2*err,'g-');
     

     
% now do confidence lines...

pp = 0;
for n=1:NT
  pp = pp + ND(tr)*(ND(tr)-1)/2;
end
pp = pp/NT;

p = 2*(T-X)*spc/(T^2);
q = 1-p;
mean_N = pp*p;
conf_up = binoinv(0.95,fix(pp),max(p,0.000001))-mean_N;
conf_dn = binoinv(0.05,fix(pp),max(p,0.000001))-mean_N;
plot(X,conf_up,'r-')
plot(X,conf_dn,'r-')
