function vout = testrotations101905(dt, delta)
'2 arguments: first is dt, second is error tolerance'
randn('seed', 0) ; % for reproducibility of results
rand('seed', 0) ; % for reproducibility of results
numPoints = 200 ;
Q = 100 * randn(numPoints, 3) ;
t = pi/2 ;
s = sin(t) ;
c = cos(t) ;
R = [c s 0 ; -s c 0 ; 0 0 1] ;
R = [1 0 0 ; 0 c s ; 0 -s c] * R ;
P = Q * R ;
myrot = rotations(P, Q, dt) ;
figure(1)
h=plot3(0,0,0,'b.','EraseMode','xor');
%axis equal;
title('efficient rotation')
relativeerror = norm(P - Q) / norm(Q) 
while relativeerror > delta
 myrot = rotate(myrot) ;
 relativeerror = norm(P - Q) / norm(Q) 
 P = getp(myrot) ;
 x = P(:,1) ; y = P(:,2) ;  z = P(:,3) ;
 set(h,'x',x,'y',y,'z',z);
 drawnow;
% pause(.01);
end
