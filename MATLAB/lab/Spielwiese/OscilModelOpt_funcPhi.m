function dphi = OscilModelOpt_funcPhi(sig,cf,f0,ft,T)

%% T = 50 * 0.1

L2 = sig*sqrt(-log(0.01));

ti = [1:100]/f0+cf*T;

gti = ti(find(ti>=T-L2 & ti<=T+L2));

phi = mod(2*pi*ft*gti+pi,2*pi);
uphi = unwrap(phi)*180/pi;

dphi = abs(max(uphi)-min(uphi));
