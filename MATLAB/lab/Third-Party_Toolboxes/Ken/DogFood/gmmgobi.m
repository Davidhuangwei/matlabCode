% gmmgobi(mix,data)
%
% Assigns the data to groups and then runs an xgobi

function gmmgobi(mix,data)

p = gmmpost(mix,data);

[dummy ind] = max(p,[],2);

xgobi(data,ind,31);