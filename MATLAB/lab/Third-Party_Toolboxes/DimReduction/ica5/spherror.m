function wobble = spherror(center,x,y,z)
x = x - center(1);
y = y - center(2);
z = z - center(3);
radius = (sqrt(x.^2+y.^2+z.^2)); 
wobble = std(mean(radius))/mean(radius); % test if xyz values are on a sphere
