% alpha = -.160*(NA.Vm+26)./(exp((NA.Vm+26)/-4.5)-1);
% beta = .040*(NA.Vm+12)./(exp((NA.Vm+12)/10)-1);
% ds=alphas.*(1-s)+betas.*s;
% minf=alpha./(alpha-beta);
s=@(x)(.160*(x+26)./(exp((x+26)/-4.5)-1)./ ...
    (.160*(x+26)./(exp((x+26)/-4.5)-1)+.040*(x+12)./(exp((x+12)/10)-1)));


% alpha = 2./exp((NA.Vm+94)/10);
% beta = 8./(exp((NA.Vm-68)/-27)+1);
% % dr=alpha.*(1-r)+beta.*r;
% hinf=alpha./(alpha-beta);
% NA.a{k,2}=(NA.a{k,2}-hinf).*exp(-NA.dt.*(alpha-beta))+hinf;
r=@(x)(2./exp((x+94)/10)./(2./exp((x+94)/10)- 8./(exp((x-68)/-27)+1)));
figure(3);
vv=[(-90):90]+.5;
plot(vv,300*s(vv).^2.*r(vv)*NA.gm(1,2))
% figure;imagesc(stp*[1:k],1:40,vm([1:4:160,2:4:160],1:k),max(abs(vm(:)))*[-1 1])