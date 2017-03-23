

WP = [];
WI = [];
for n=1:5
  WP = [WP ALL(n).width.sccg(:,ALL(n).goodn{2})];
  WI = [WP ALL(n).width.sccg(:,ALL(n).goodn{1})];
end


CP = [];
CI = [];
for n=7:10
  CP = [CP ALL(n).width.sccg(:,ALL(n).goodn{2})];
  CI = [CP ALL(n).width.sccg(:,ALL(n).goodn{1})];
end

MWP = mean(WP);
MCP = mean(CP);

SWP = std(WP);
SCP = std(CP);

nWP = WP./repmat(WP(61,:),size(WP,1),1);
nCP = CP./repmat(CP(61,:),size(CP,1),1);

MWP = mean(nWP');
MCP = mean(nCP');

SWP = std(nWP');
SCP = std(nCP');


T = ALL(n).width.t;
GT = [61:102];

figure(753);clf
subplot(311)
plot(T(GT),nWP(GT,:),'color',[1 1 1]*0.8)
hold on
plot(T(GT),MWP(GT),'color',[1 0 0],'LineWidth',2)
plot(T(GT),MWP(GT)+SWP(GT),'--','color',[1 0 0],'LineWidth',2)
plot(T(GT),MWP(GT)-SWP(GT),'--','color',[1 0 0],'LineWidth',2)
axis tight
ylim([0 2])
%
subplot(312)
plot(T(GT),nCP(GT,:),'color',[1 1 1]*0.8)
hold on
plot(T(GT),MCP(GT),'color',[1 0 0],'LineWidth',2)
plot(T(GT),MCP(GT)-SCP(GT),'--','color',[1 0 0],'LineWidth',2)
plot(T(GT),MCP(GT)+SCP(GT),'--','color',[1 0 0],'LineWidth',2)
axis tight
ylim([0 2])

subplot(313)
plot(T(GT),MWP(GT),'color',[0 1 0],'LineWidth',2)
hold on
plot(T(GT),MCP(GT),'color',[1 0 0],'LineWidth',2)
axis tight
ylim([0 2])


