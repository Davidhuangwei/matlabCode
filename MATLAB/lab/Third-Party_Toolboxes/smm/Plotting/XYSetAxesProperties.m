function XYSetAxesProperties(commandText, axesHandles)

[x, y] = size(axesHandles);

for i=1:x
    for j=1:y
        if axesHandles(i,j) ~= 0
            axes(axesHandles(i,j));
            eval(commandText);
        end
    end
end