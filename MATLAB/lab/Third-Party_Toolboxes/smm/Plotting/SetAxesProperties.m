function SetAxesProperties(commandText, axesHandles)

for i=1:length(axesHandles(:))
    if axesHandles(i) ~= 0
        axes(axesHandles(i));
        eval(commandText);
    end
end