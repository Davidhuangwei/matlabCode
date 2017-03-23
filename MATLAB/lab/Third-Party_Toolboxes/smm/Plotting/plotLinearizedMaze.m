function plotLinearizedMaze(fileBaseMat);

%files = ['sm9608_301';'sm9608_302';'sm9608_303';'sm9608_306';'sm9608_307';'sm9608_308';'sm9608_309';'sm9608_322';'sm9608_323';'sm9608_324';'sm9608_325';'sm9608_326';'sm9608_327'];
[nfiles c] = size(fileBaseMat);
figure()
clf
hold on
colors = [1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1; 0 1 0; 0 0 0];
for i=1:nfiles
    load([fileBaseMat(i,:) '_LinearizedWhl.mat']);
    plot(linearRLaverage,'.','color',colors(mod(i,7)+1,:));
end
