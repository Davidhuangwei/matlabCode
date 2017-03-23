function XYSetAxisProperties(commandText, axesHandles)

[x, y] = size(axesHandles);

for i=1:x
    for j=1:y
        axes(axesHandles(i,j));
        eval(commandText);
    end
end