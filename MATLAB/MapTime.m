function [btt, indtt]=MapTime(bt, tt)
% function [btt, indtt]=MapTime(bt, tt)
% map burst time to time sequence. btt=tt(indtt);
bt=repmat(bt(:),1,2);
bt(:,2)=0;
tt=[tt(:),[1:length(tt)]'];
nt=sortrows([bt;tt],1);
indtt=unique([nt(min(find(nt(:,2)==0) +1,length(nt)),2),nt(max(find(nt(:,2)==0) -1,1),2)]);
indtt(indtt==0)=[];
btt=tt(indtt);