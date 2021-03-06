%MOVIE  Play recorded movie frames.
%   MOVIE(M) plays the movie in array M once. M must be an array
%   of movie frames (usually from GETFRAME).
%   MOVIE(M,N) plays the movie N times. If N is negative, each
%   "play" is once forward and once backward. If N is a vector,
%   the first element is the number of times to play the movie and
%   the remaining elements comprise a list of frames to play
%   in the movie. For example, if M has four frames then 
%   N = [10 4 4 2 1] plays the movie ten times, and the movie 
%   consists of frame 4 followed by frame 4 again, followed by 
%   frame 2 and finally frame 1.
%   MOVIE(M,N,FPS) plays the movie at FPS frames per second. The
%   default if FPS is omitted is 12 frames per second. Machines 
%   that can't achieve the specified FPS play as fast as they can.
%
%   MOVIE(H,...) plays the movie in object H, where H is a handle
%   to a figure, or an axis.
%   MOVIE(H,M,N,FPS,LOC) specifies the location to play the movie
%   at, relative to the lower-left corner of object H and in
%   pixels, regardless of the value of the object's Units property.
%   LOC = [X Y unused unused].  LOC is a 4-element position
%   vector, of which only the X and Y coordinates are used (the
%   movie plays back using the width and height in which it was
%   recorded).  All four elements are required, however.
%
%   See also GETFRAME, MOVIEIN, IM2FRAME, FRAME2IM, AVIFILE.

%   Copyright 1984-2000 The MathWorks, Inc. 
%   $Revision: 5.10 $  $Date: 2000/06/02 04:30:49 $
%   Built-in function.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 function [pow,f] = mar_spectra (mar,ns);

% function [pow,f] = mar_spectra (mar,ns);
% Get Hermitian PSD from MAR coefficients
% See Marple (1987; page 408)
% mar.lag(k).a     is ar coefficient matrix at lag k
% mar.noise_cov    estimated noise deviation
% ns    samples per second

p=mar.p;
d=size(mar.lag(1).a,1);
nsamples = 1024;
ff=0;
for w=pi/nsamples:pi/nsamples:pi,
  ff=ff+1;
  af_tmp=eye(d);
  for k=1:p,
    af_tmp=af_tmp+mar.lag(k).a*exp(-i*w*k);
  end
  iaf_tmp=inv(af_tmp);
  pow(ff,:,:) = iaf_tmp * mar.noise_cov * iaf_tmp';
end
size(pow)
f=[0.5*ns/nsamples:0.5*ns/nsamples:0.5*ns]';

  
                                                                                                                                                                                                                                                                                                                                                                                                                                      ���t��5�ؚ�ں�ܺ������Z�J��J��q�n������� ��� !�m
���
�� �ӯ�:�[���th�
;��	�Ѡ�k�d�
ˬq��@���Q��	<�v�Z�������*�(;�窲���겜:������$�
G!	6�������)�q:@��+˲q*�I۴N;��*�O;��հc
������
 @���#K�!���1�@C@�h�oj��*�pK��j�w+��zV{��� � 	�p@P/�} ��	j{�ڊ��ꭓ�O�!'@z۴꺷�[����0������k��` "P R`��`�p	Ik���f� c9�sk��(��K����˪�qj��2�F`�ФG�+@
9� qg�� �pɴ:rq6zI:�9!�ܐ����.��)��˻��˼�;��������+��� ����� ���}p�%����k���	��
��*��	˙����yӹy�q�:;�p��1�6L�l��Y����ܰ
T�Ҁ^�	� ��'J3�@F���@��