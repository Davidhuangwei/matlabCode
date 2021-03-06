function csd=mkCSD(lfp,r,X,nX,lambda,theta)
% csd=mkCSD(lfp,r,X,nX,lambda,theta)
% home made kernel CSD. 
% input: 
% lfp
% r: radium of electrical column, how large is the contributing cluster
% size.
% X: the coordinate of lfp
% nX: the coordinate of your interested current sites.
% lambda: the allowed prior errors.
% theta: [sigma, scale (consider anything like conductency), span]
% YYC
% NB: note that the major neck point of using directly continuse CSD is the
% different noise level or signal amplifiering from different channels. and
% the leaking current which does not fit into sterotipical pattern of
% within foeld csd. so, if you can, do ICA denoise first, get rid of
% effects by bad channel and volumne conductence. 

[nt, nch]=size(lfp);
src=(X(1)-1):.1:(X(end)+1);
[SrcM, bw_new] = Skernel(nX(:), src(:), theta);
[CurM, bw_new] = Ckernel(src(:), X(:), theta,r);
KXX=CurM'*CurM;
KnXX=SrcM*CurM;
csd=zeros(nt,length(nX));
for k=1:floor(nt/200)
    t=(k-1)*200+[1:200];
    csd(t,:)=lfp(t,:)/(KXX+lambda.*eye(length(X)))*KnXX';
    fprintf('-')
end
t=(k*200+1):nt;
csd(t,:)=lfp(t,:)/(KXX+lambda.*eye(length(X)))*KnXX';

end                                                                                                                                                                                                        