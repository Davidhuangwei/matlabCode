function [dstamp]=densitystamps (data,nstamps)

temp=1:floor(size(data,1)/nstamps):size(data,1);
if length(temp)~=nstamps+1; 
    temp=[temp size(data,1)];
end

for lp=1:length(temp)-1
   newdata(lp,:)= sum(data(temp(lp):temp(lp+1),:));
end
clear temp lp

temp=1:floor(size(data,2)/nstamps):size(data,2);
if length(temp)~=nstamps+1; 
    temp=[temp size(data,2)];
end

for lp_r=1:size(newdata,1)
    for lp=1:length(temp)-1
        newtemp= sum(newdata(lp_r,temp(lp):temp(lp+1)));
        dstamp(lp_r,lp)=newtemp;
    end
end
clear temp lp


