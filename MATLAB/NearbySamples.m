function st=NearbySamples(st,t)
% st=NearbySamples(st,t)
% get nearby samples when you want to increase samples around gamma bursts.
% 
if length(t)==1
    t=(-t):2:t;
end
st=bsxfun(@plus,st(:),t);
st=st(:);