% same as imagesc but it flips the map so x is arg 1
% and y is arg 2 and it's the right way up.


function h = imagescXY(Arg1, Arg2, Arg3, Arg4)

switch nargin
case 1
	h = imagesc(Arg1.');
case 3
	h = imagesc(Arg1, Arg2, Arg3.');
case 4
	h = imagesc(Arg1, Arg2, Arg3.', Arg4);
otherwise
	error('incorrect number of arguments');
end

set(gca, 'ydir', 'normal');