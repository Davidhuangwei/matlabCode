function plotshuffCC(hist,tit,type)
figure

plnum=size(hist,1);
if nargin<3 |isempty(type)
    type='b';
end

if nargin<2 | isempty(tit)
    tit='';
end
for i=1:plnum
    subplotfit(i,plnum);
    if type=='b'
            bar(hist{i}(:,3),hist{i}(:,1),'b');
    else
            plot(hist{i}(:,3),hist{i}(:,1),'b');
     end
    hold on;
    plot(hist{i}(:,3),hist{i}(:,2),'g--');
    plot(hist{i}(:,3),-hist{i}(:,2),'g--');
    
    if ~isempty(tit)
        title(tit{i});
    end
end