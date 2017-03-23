function y=ShuffleNr(x,varargin)
num=varargin{1};
nx=size(x,1);
if nx<2
    nx=x;
end

if num>(.8*nx)
    if nargin>2
        nt=varargin{2};
        y=randi(nx,num,nt);
    else
        y=randi(nx,num,1);
    end
    warning('with repeat')
else
    if nargin>2
        nt=varargin{2};
        [~,indx]=sort(rand(nx,nt));
        y=indx(1:num,:);
    else
        [~,indx]=sort(rand(nx,1));
        y=indx(1:num,:);
    end
end