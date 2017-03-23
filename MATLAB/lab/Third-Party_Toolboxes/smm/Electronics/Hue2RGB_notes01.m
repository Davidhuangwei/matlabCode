hue = [0:255 0:255];

g = 255 - clip(abs(85-hue),0,85)*255/85;
hue = mod(hue - 85,255)
r = 255 - clip(abs(85-hue),0,85)*255/85;
hue = mod(hue - 85,255)
b = 255 - clip(abs(86-hue),0,85)*255/85;

hue = [0:255 0:255];
cla
hold on
plot(hue,b,'b.')
plot(hue,g,'g.')
plot(hue,r,'r.')

hue = [0:255 0:255];
cla
hold on
plot(hue,log(b.^42),'b.')
plot(hue,log(g.^42),'g.')
plot(hue,log(r.^42),'r.')


offset = 85;
hue = mod(hue + offset,255)

