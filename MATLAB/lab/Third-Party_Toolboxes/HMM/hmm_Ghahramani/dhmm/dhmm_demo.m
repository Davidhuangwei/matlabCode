alphabet='abchrt';

S={'cat' 'cab' 'cataract' 'that' 'act' 'chat' 'rat' 'hat' }
K=3;
cyc=50;
[E,P,Pi,LL]=dhmm(S,alphabet,K,cyc)

disp('Hit any key to plot log likelihood');
pause;
plot(LL);



