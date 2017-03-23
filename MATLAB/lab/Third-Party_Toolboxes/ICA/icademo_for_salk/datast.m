function [ICs, ICt, mixt] = datast(nr, nc, nt)

% Mixes within space and within time.
% One image per column in mixt.
% Collect ICs, one IC per row.
% eg [ics ict x]=datast(16,16,256);

mix_fac = 0.28; % 0.28 with remove IC corrs=1.

mix_space = 1;
mix_time = 1;
p=0.3;	% power to raise ICs to. (0.3)

remove_ic_corrs = 1; % (1) Leave hi order dependency but remove correlations.
 
% nr = image rows
% nc = image columns

% e.g. m = datas(32,32,100);

[x, y] = meshgrid(linspace(0, 1, nr), linspace(0, 1, nc));

% (2) 3 5 7 9 11 13
im1 = sin(2*pi*2*x);
im2 = sin(2*pi*4*y);
im3 = sin(2*pi*2*x).*sin(2*pi*2*y);
im4 = sin(2*pi*7*x).*sin(2*pi*7*y);

% CLUDGE - THIS GIVES SIN TIME COURSE and is not ind for > 2 sources.
sin_time=1;
if sin_time
% Make time courses.
t = linspace(0, 1, nt);

% t1=reshape(t1, nr, nc);t1=t1';t1=t1(:);
t1 = t1+sin(2*pi*7);
t2 = sin(2*pi*19*t);    t2 = ic_norm(t2);

t3 = sin(2*pi*16*t); t3 = ic_norm(t3);
t4 = sin(2*pi*16*t); t4 = ic_norm(t4);

t1 = ic_norm(t1);
t2 = ic_norm(t2);
end;

% im1=t1; im2=t2;im3=t3;im4=t4;

% im1=randk(nr,nc); im2=randk(nr,nc);

tiny=1e-6;
im1=im1-min(im1(:));
im2=im2-min(im2(:));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% im4 = rand(nr, nc);
%im4 = randn(nr, nc); % gets mixed up!

im1 = im1(:); im1 = ic_norm(im1);
im2 = im2(:); im2 = ic_norm(im2);
im3 = im3(:); im3 = ic_norm(im3);
im4 = im4(:); im4 = ic_norm(im4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MIX IMAGES.

% Make all > 0.

if mix_space
temp=im2-min(im2)+1e-6;
temp = temp.^p; 
temp=temp.*sign(im2);
temp=ic_norm(temp);
im1 = (1-mix_fac)*im1 + mix_fac*(temp);

temp = im1-min(im1)+1e-6;
temp = temp.^p; 
temp=temp.*sign(im1);
temp=ic_norm(temp);
im2 = (1-mix_fac)*im2 + mix_fac*(temp);
end;

% REMOVE CORRS BETWEEN IMAGES.
if remove_ic_corrs
im2=remove_signal(im1',im2');
jangle(im1,im2,1) 
end;

% Set zero mean again ...
im1 = im1(:); 
im1=ic_norm(im1);

im2 = im2(:); 
im2=ic_norm(im2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('ICs==Images ...\n');
jfig(6); clf;
subplot(2, 1, 1); pnshow( reshape(im1, nr, nc));title('Original IC 1');axis square;
subplot(2, 1, 2); pnshow( reshape(im2, nr, nc));title('Original IC 2');axis square;
% subplot(2, 2, 3); pnshow( reshape(im3, nr, nc) );title('Original IC 3');
% subplot(2, 2, 4); pnshow( reshape(im4, nr, nc) );title('Original IC 4');

% PLOT SPATIAL ICS.
jfig(1); subplot(2,1,1); pnshow( reshape(im1, nr, nc) );axis square;
jfig(1); subplot(2,1,2); pnshow( reshape(im2, nr, nc) );axis square;
% jfig(3); clf; pnshow( reshape(im3, nr, nc) );
% jfig(4); clf; pnshow( reshape(im4, nr, nc) );
drawnow;

% DEFINE TIME COURSES OF ICS.
t = linspace(0, 1, nt);
t1 = t;
t2 = t.^2;
t3 = log(t*100+1); % randn(1, nt);
a=t; a=a/max(a); a=a*2*pi; t4 = cos(a); % 10*t; t4 = t4-floor(t4);

% t1=randk(1,nt); t2=randk(1,nt);

% CLUDGE - THIS GIVES SIN TIME COURSE and is not ind for > 2 sources.
sin_time=1;
if sin_time
% Make time courses.
t = linspace(0, 1, nt);
t1 = sin(2*pi*7*t);     t1=ic_norm(t1);
t2 = sin(2*pi*19*t);    t2=ic_norm(t2);

t3 = sin(2*pi*11*t);   
t3=ic_norm(t3);
t4 = sin(2*pi*13*t);   
t4=ic_norm(t4);
end;

hikurt=0;
if hikurt
	t1=randk(1,nt); t2=randk(1,nt); t3=randk(1,nt);t4=randk(1,nt);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MIX TIME COURSES

if mix_time

temp = t2-min(t2);
temp = temp.^p; 
temp=sign(t2).*temp;
temp=ic_norm(temp);

t1 = (1-mix_fac)*t1 + mix_fac*temp;

temp = t1-min(t1);
jfig(9);plot(temp);
temp = temp.^p; 
temp=sign(t1).*temp;
temp=ic_norm(temp);
t2 = (1-mix_fac)*t2 + mix_fac*temp;

% REMOVE CORRS BETWEEN TIME COURSES.
if remove_ic_corrs
t2=remove_signal(t1,t2);
jangle(t1,t2,1) 
end;

end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t1=ic_norm(t1);
t2=ic_norm(t2);
t3=ic_norm(t3);
t4=ic_norm(t4);

% mixt = im1*t1+im2*t2+im3*t3+im4*t4;
mixt = im1*t1 + im2*t2;

% PLOT TIME COURSES.
fprintf('Time courses ...\n');
jfig(7); clf;
subplot(2, 1, 1); plot( t1 ); title('Original time course 1');
subplot(2, 1, 2); plot( t2 ); title('Original time course 2');
% subplot(2, 2, 3); plot( t3 );title('Original time course 3');
% subplot(2, 2, 4); plot( t4 );title('Original time course 4');
drawnow;

% Collect ICs, one IC per row.
ICs =[im1,im2]';
ICt =[t1; t2];

n=50;
for i=1:2
	jfig(8);
	subplot(2,1,1); hist(im1,n);
	subplot(2,1,2); hist(im2,n);
end;

for i=1:2
	jfig(9);
	subplot(2,1,1); hist(t1,n);
	subplot(2,1,2); hist(t2,n);
end;