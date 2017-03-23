function psscpcp=mKCIcausal_new(hX,hY,hZ,pars,bss,tlag)
% function [pval,sta,p_val,Sta]=KCIcausal_new(X,Y,Z,par,t,tlag)
% function value the information at each timelag based on the time serials
% given by X,Y,Z. 
% well... indeed we perform the conditional independent test to see at
% each time lag the pval
% based on the kernal method. 
%
% INPUT:
%   X          Nxd1 matrix of samples (N sample points, d1 dimensions)
%   Y          Nxd2 matrix of samples (N sample points, d2 dimensions)
%   Z          Nxd3 matrix of samples (N sample points, d3 dimensions)
%   pars       structure containing parameters for the independence test
%     .pairwise	    if true, the test is performed pairwise if d1>1 (standard: false)
%     .bonferroni   if true, bonferroni correction is performed (standard: false)
%     .width        kernel width (standard: 0, which results in an automatic -heuristic- choice)
%
% OUTPUT:
% psscpcp: [pval,sta,Sta, Cri, p_val, Cri_appr, p_appr] at each time lag.
% t
% tlag: the timelag to each pval 

%% from indtest_new
    pars.pairwise = false;
    hX=sq(hX);
    hY=sq(hY);
    hZ=sq(hZ);
    [nt, vz]=size(hZ);
%     uniz=[];    
%     for k=1:vz
%         [~,uz,~]=unique(hZ(:,k));
%     uniz=[uniz,setdiff(1:nt,uz')];
%     end
%     uz=setdiff(1:nt,unique(uniz)')';
%     luz=length(uz);
%     hX=hX(uz,:);
%     hY=hY(uz,:);
%     hZ=hZ(uz,:);
    
    
%     hX=zscore(hX);
%     hY=zscore(hY);
%     hZ=zscore(hZ);
%     if isreal(hY)
%         hX=zscore(hX);
%         hY=zscore(hZ);
%     else
%         hX=bsxfun(@times,hX,conj(fangle(mean(fangle(hX)))));
%     hY=bsxfun(@times,hY,conj(fangle(mean(fangle(hY)))));
%     end
%     if isreal(hZ)
%         hZ=zscore(hZ);
%     else
%     hZ=bsxfun(@times,hZ,conj(fangle(mean(fangle(hZ)))));
%     end
luz=size(hX,1);
    t=1:luz;
    isshowxy=false;%true;
    if isshowxy
        figure(158)
        plot(angle(hX),angle(hY),'.')
    end
if ~isfield(pars,'bonferroni')
    pars.bonferroni = false;
end
if ~isfield(pars,'width')
    pars.width = 0;
end
t=t(t>=(max(tlag)+1));
nlag=length(tlag);
Y=hY(t,:);
nempZ=~isempty(hZ);
if nempZ
Z=hZ(t,:);
end
clear hY hZ
if nempZ
psscpcp=zeros(nlag,4);
else 
    psscpcp=zeros(nlag,2);
end
for k=1:nlag
    X=hX(t-tlag(k),:);

    [pval,sta] = UInd_KCItest(X, Y);%, pars.width
    if nempZ
        [Sta, p_val] = CInd_test_new_withGPm(X, Y, Z,pars.width,bss);%;, 
    psscpcp(k,:)=[pval,sta,p_val,Sta];
    else
        psscpcp(k,:)=[pval,sta];
    end
end

end % EOF