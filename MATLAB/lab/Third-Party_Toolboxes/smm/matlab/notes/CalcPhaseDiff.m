
minima_cell = load minimafile

refMinima = minima_cell{refChan};
nearestMinima = NaN*ones(length(minima_cell),(length(refMinima)));
for i=1:length(minima_cell)
    testMinima = minima_cell{i};
    for j=1:length(refMinima)
        temp = find(abs(refMinima(j) - testMinima) == min(abs(refMinima(j) - testMinima)));
        nearestMinima(i,j) = testMinima(temp(1));
        nearestMinima(i,j);
    end
end
