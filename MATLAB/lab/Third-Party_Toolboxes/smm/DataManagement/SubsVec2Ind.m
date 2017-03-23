function index = SubsVec2Ind(matSize,subsVec)
% given the subscripts of a matSize matrix, returns the index.
% Similar to sub2ind, but indexes are passed in a vector rather than comma
% delimited
if length(subsVec) == 1
    index = subsVec(1);
else
    kloogText = ['sub2ind([' num2str(matSize) ']'];
    for i=1:length(subsVec)
        kloogText = [kloogText ',' num2str(subsVec(i))];
    end
    kloogText = [kloogText ')'];
    index = eval(kloogText);
end
return