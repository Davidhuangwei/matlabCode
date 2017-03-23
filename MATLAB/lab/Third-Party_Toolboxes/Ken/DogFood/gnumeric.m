% gnumeric(data)
%
% initiates a gumeric session to display data.

function gnumeric(data);
msave('/tmp/matgnumeric', data);
! /usr/bin/gnumeric /tmp/matgnumeric &
	
