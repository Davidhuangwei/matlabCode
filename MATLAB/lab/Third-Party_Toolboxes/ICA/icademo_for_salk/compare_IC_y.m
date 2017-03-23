function compare_IC_y(ics,ys,ict,yt);

jsize(ys,'ys');jsize(ics,'ics');
jsize(yt,'yt');jsize(ict,'ict');
[nic n]=size(ics);

use_corr = 1;
if use_corr==1
	fprintf('compare_IC_y: Using 2nd moment for correlations ...\n');
else
	fprintf('compare_IC_y: Using Nth moments for correlations ...\n');
end;

s=zeros(nic,nic);
for i=1:nic
	for j=1:nic
		if use_corr==1
		s(i,j) = jcorr(ics(i,:),ys(j,:));
		else
		s(i,j) = jcorr_info(ics(i,:),ys(j,:));
		end;
	end;
end;

t=zeros(nic,nic);
for i=1:nic
	for j=1:nic
		if use_corr==1
		t(i,j) = jcorr(ict(i,:),yt(j,:));
		else
		t(i,j) = jcorr_info(ict(i,:),yt(j,:));
		end;
	end;
end;

s
t