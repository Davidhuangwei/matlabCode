function LinResample(T,Data,Rate)
%%
%% LinResample(T,Data,Rate)


T = sort(rand(100,1)*100);
Data = T.^2+T.^3+T.^4+T.^5;
Rate = 2;

RT = [0:2:100];

D = interp1(T,Data,RT);

figure(8);clf
plot(T,Data,'.-')
hold on
plot(RT,D,'.-r')
