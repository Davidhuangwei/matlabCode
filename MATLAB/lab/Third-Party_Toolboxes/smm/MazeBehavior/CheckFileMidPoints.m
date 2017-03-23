function CheckFileMidPoints03(fileBaseMat,timeWindow,trialtypesbool)

if ~exist('trialtypesbool','var') | isempty(trialtypesbool)
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                    %LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
                    %cr ir cl il crp irp clp ilp crb irb clb ilb xp
end
whlSamp = 39.065;
figure(1)
clf

for j=1:size(fileBaseMat,1)
figure(1)
clf
hold on
    fileBase = fileBaseMat(j,:);
    cd(fileBase)
    fprintf('%s \n',fileBase)
    %subplot(size(fileBaseMat,1),1,j)
    %hold on
    whl = load([fileBase '.whl']);
    plot(whl(:,1),whl(:,2),'y.');
    midPoints = CalcFileMidPoints02(fileBase,0,trialtypesbool);
    midPoints = midPoints.(fileBase);
    fields = fieldnames(midPoints);
    len = length(midPoints.(fields{1}));
    for k=1:len
        for m=1:length(fields)
            index = midPoints.(fields{m})(k);
            plot(whl(index-round(timeWindow/2*whlSamp):index+round(timeWindow/2*whlSamp),1),...
                whl(index-round(timeWindow/2*whlSamp):index+round(timeWindow/2*whlSamp),2),...
                '.','color',[mod(round((m-1)/2),2) 0 mod(round(m/1),2)]);            
%             plot(whl(index,1),whl(index,2),'g.','markersize',20)
        end
    end
    for k=1:len
        for m=1:length(fields)
             index = midPoints.(fields{m})(k);
           plot(whl(index,1),whl(index,2),'g.','markersize',20)
        end
    end    
    
    cd ..
    %keyboard
    pause
end