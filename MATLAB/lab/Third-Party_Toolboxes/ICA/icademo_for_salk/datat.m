function mixt = datat(nr, nc, nt)

if(nr ~= nc)
	return;
end

n = nr;

[x, y] = meshgrid(linspace(-1, 1, n));

im1 = ((x-0.5).^2+(y-0.5).^2) < 0.2; im1 = im1(:); im1 = im1-mean(im1); im1 = im1/std(im1);
im2 = ((x+0.5).^2+(y+0.5).^2) < 0.2; im2 = im2(:); im2 = im2-mean(im2); im2 = im2/std(im2);
im3 = ((x+0.5).^2+(y-0.5).^2) < 0.2; im3 = im3(:); im3 = im3-mean(im3); im3 = im3/std(im3);

im4 = randn(n); im4 = im4(:); im4 = im4-mean(im4); im4 = im4/std(im4);

t = linspace(0, 1, nt);

t1 = sin(2*pi*7*t);    t1 = t1-mean(t1); t1 = t1/std(t1);
t2 = sin(2*pi*9*t);    t2 = t2-mean(t2); t2 = t2/std(t2);
t3 = sin(2*pi*11*t);   t3 = t3-mean(t3); t3 = t3/std(t3);
t4 = sin(2*pi*13*t);   t4 = t4-mean(t4); t4 = t4/std(t4);

mixt = im1*t1+im2*t2+im3*t3+im4*t4;

fprintf('Time courses ...\n');
jfig(1); clf;
subplot(2, 2, 1); plot( t1 ); title('Original IC 1');
subplot(2, 2, 2); plot( t2 );title('Original IC 2');
subplot(2, 2, 3); plot( t3 );title('Original IC 3');
subplot(2, 2, 4); plot( t4 );title('Original IC 4');

fprintf('Images ...\n');
jfig(2); 
subplot(2, 2, 1); pnshow( reshape(im1, nr, nc) ); title('Original image 1');
subplot(2, 2, 2); pnshow( reshape(im2, nr, nc) ); title('Original image 2');
subplot(2, 2, 3); pnshow( reshape(im3, nr, nc) ); title('Original image 3');
subplot(2, 2, 4); pnshow( reshape(im4, nr, nc) ); title('Original image 4');
drawnow;
