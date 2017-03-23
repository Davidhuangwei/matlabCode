% output = LoadCircleQuads(fileBase,trialtypesbool,quadBool)
% [trialtypesbool,quadBool] = DefaultArgs(varargin, ...
%  { [1  0  1  0  0   0   0   0   0   0   0   0  0],  [1  1  1  1]});
%  % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp   q1 q2 q3 q4

function output = LoadCircleQuads(fileBase,varargin)
[trialtypesbool,quadBool] = DefaultArgs(varargin, ...
 { [1  0  1  0  0   0   0   0   0   0   0   0  0],  [1  1  1  1]});
 % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp   q1 q2 q3 q4

 
whlDat = load([fileBase '.whl']);
output = -1*ones(size(whlDat));

startLeft = [1  0  0  1  1   0   0   1   1   0   0   1  0] & trialtypesbool;
startRight = [0  1  1  0  0   1   1   0   0   1   1   0  0] & trialtypesbool;

if quadBool(1)
    temp1 = LoadMazeTrialTypes(fileBase,startLeft,[0 0 0 0 0 0 0 0 1]);
    temp2 = LoadMazeTrialTypes(fileBase,startRight,[0 0 0 0 0 0 0 1 0]);
    output(temp1(:)~=-1) = temp1(find(temp1(:)~=-1));
    output(temp2(:)~=-1) = temp2(find(temp2(:)~=-1));
end

if quadBool(2)
    temp1 = LoadMazeTrialTypes(fileBase,startLeft,[0 0 0 0 0 0 1 0 0]);
    temp2 = LoadMazeTrialTypes(fileBase,startRight,[0 0 0 0 0 1 0 0 0]);
    output(temp1(:)~=-1) = temp1(find(temp1(:)~=-1));
    output(temp2(:)~=-1) = temp2(find(temp2(:)~=-1));
end

if quadBool(3)
    temp1 = LoadMazeTrialTypes(fileBase,startLeft,[0 0 0 0 0 1 0 0 0]);
    temp2 = LoadMazeTrialTypes(fileBase,startRight,[0 0 0 0 0 0 1 0 0]);
    output(temp1(:)~=-1) = temp1(find(temp1(:)~=-1));
    output(temp2(:)~=-1) = temp2(find(temp2(:)~=-1));
end

if quadBool(4)
    temp1 = LoadMazeTrialTypes(fileBase,startLeft,[0 0 0 0 0 0 0 1 0]);
    temp2 = LoadMazeTrialTypes(fileBase,startRight,[0 0 0 0 0 0 0 0 1]);
    output(temp1(:)~=-1) = temp1(find(temp1(:)~=-1));
    output(temp2(:)~=-1) = temp2(find(temp2(:)~=-1));
end
return