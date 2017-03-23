function ComplexStudy
figure(1)
clf
hold on
z = complex(randn(1000,1),5*randn(1000,1));
plot(z,'r.')
mz = mean(z);
plot(mz,'b.','markersize',40)
title('blue = circular mean, cyan = ordinary mean')
%atan2(imag(mz),real(mz))
fprintf('\ncircular mean of phases = %f\n',atan2(imag(mz),real(mz)))

circZ = atan2(imag(z),real(z));
figure(2)
clf
hist(circZ) 
%mean(circZ)
fprintf('\nordinary mean of phases = %f\n',mean(circZ))
figure(1)
plot(cos(mean(circZ)),sin(mean(circZ)),'c.','markersize',40)

% clf % clear figure