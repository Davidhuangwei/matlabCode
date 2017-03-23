whl = LoadMazeTrialTypes('sm9614_363');


whl = [];
%files = [LoadVar('AlterFiles.mat');LoadVar('CircleFiles.mat')];
%files = [LoadVar('ZMazeFiles.mat')];
files = [LoadVar('AlterFiles.mat')];
for i=1:size(files,1)
cd(files(i,:))
whl = cat(1,whl,LoadMazeTrialTypes(files(i,:),[],[0 0 0 0 0 0 0 1 1]));

%whl = cat(1,whl,load([files(i,:) '.whl']));
cd ..
end

whl(whl(:,1)~=-1,[2 4]) = whl(whl(:,1)~=-1,[2 4])*1.13;

dist = sqrt((whl(:,1)-whl(:,3)).^2+(whl(:,2)-whl(:,4)).^2);
correctDist = find(dist>mean(dist(dist>0))-0.5*std(dist(dist>0)) & dist<mean(dist(dist>0))+0.5*std(dist(dist>0)));
plot(whl(:,1),whl(:,2),'.')

clf
hold on
plot(dist)
plot([1 length(dist)],[mean(dist(dist>0)) mean(dist(dist>0))])
plot([1 length(dist)],[mean(dist(dist>0))+0.5*std(dist(dist>0)) mean(dist(dist>0))+0.5*std(dist(dist>0))],'g')
plot([1 length(dist)],[mean(dist(dist>0))-0.5*std(dist(dist>0)) mean(dist(dist>0))-0.5*std(dist(dist>0))],'g')
plot(correctDist,dist(correctDist),'c.')

%correctDist2 = (correctDist>mean(correctDist)-std(correctDist)) & (correctDist<mean(correctDist)+std(correctDist));
%plot(dist(correctDist),'r')



asinWhl = abs(asin((whl(:,2)-whl(:,4))./dist));
%acosWhl = acos((whl(:,2)-whl(:,4))./dist);

clf
hold on
plot(asinWhl(correctDist),'.')
%plot(acosWhl(correctDist),'r.')


%plot(angle(correctDist))
%plot(acosWhl(correctDist),dist(correctDist),'.r')

clf
hold on
plot(asinWhl(correctDist),dist(correctDist),'.')

b = robustfit([ones(size(dist(correctDist))) dist(correctDist)], asinWhl(correctDist));
b = robustfit(asinWhl(correctDist), dist(correctDist) );

hold on
plot([0 pi/2],[b(1) b(1)+b(2)*pi/2]+3,'r');
plot([0 pi/2],[b(1) b(1)+b(2)*pi/2],'r');
plot([0 pi/2],[25 25],'g');
plot([0 pi/2],[24 24],'g');
(b(1))
((b(1)+b(2)*pi/2))
(b(1)+3)/((b(1)+b(2)*pi/2)+3)

clf
hist(abs(whl(:,1)-whl(:,3)),max(abs(whl(:,1)-whl(:,3))))
hist(abs(whl(:,2)-whl(:,4)),max(abs(whl(:,2)-whl(:,4))))

dist = sqrt((whl(:,1)-whl(:,3)).^2+(whl(:,2)-whl(:,4)).^2);
correctDist = find(dist>mean(dist(dist>0))-0.5*std(dist(dist>0)) & dist<mean(dist(dist>0))+0.5*std(dist(dist>0)));
plot(whl(:,1),whl(:,2),'.')



regCos = regress(asinWhl(correctDist),[ones(size(dist(correctDist))) dist(correctDist)] )
regCos = 1/regress(dist(correctDist),[ones(size(asinWhl(correctDist))) asinWhl(correctDist)])
regCos = 0.13

yoffset = mean(dist(correctDist))
yoffset = 23;
%plot([-1 1],[yoffset-regCos*min(cosWhl(correctDist)) yoffset+regCos*max(cosWhl(correctDist))],'r')
plot([min(asinWhl(correctDist)) max(asinWhl(correctDist))],[yoffset-regCos(2)*min(asinWhl(correctDist)) yoffset+regCos(2)*max(asinWhl(correctDist))],'r')

%tanWhl = tan((whl(:,2)-whl(:,4))./(whl(:,1)-whl(:,3)));


