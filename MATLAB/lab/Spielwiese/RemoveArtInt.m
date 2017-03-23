function nThetInt = RemoveArtInt(ThetInt,Evt,x1,x2,thresh);
%% 
%% take out aretifacts from periods of theta
%% ThetInt: two column vector, beginning and end of theta pariods
%% Evt: time stamp of artifacts
%% [x1 x2]: intervall to exclude around the artifact
%% thrsh: threshold length for theta periods 
%% thresh
%% 

fullTh = [];
for i=1:length(ThetInt)
  fullTh = [fullTh; [ThetInt(i,1):ThetInt(i,2)]'];
end

fullEv = [];
for i=1:length(Evt)
  fullEv = [fullEv; [Evt(i)-x1:Evt(i)+x2]];
end

goodTh = fullTh(find(~ismember(fullTh,fullEv)));

count = find(diff(goodTh)>1);
 
thet(:,2) = goodTh(count);
thet(end+1,2) = goodTh(end);

thet(1,1) = goodTh(1);
thet(2:end,1) = goodTh(count+1);

nThetInt = thet(find((thet(:,2)-thet(:,1))>thresh),:);


return;


