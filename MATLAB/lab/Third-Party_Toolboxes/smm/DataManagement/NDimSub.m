function outMat = NDimSub(inMat,indexMat)
% function outMat = NDimSub(inMat,indexMat)
% optional argument indexMat is an n by 2 mat with the first column
% designating the dimension of the index in the second column



if ~isempty(indexMat)
    kloogText = ['inMat('];
    if ndims(inMat)==2 & size(inMat,2)==1
        nDimen = ndims(inMat) - 1;
    else
        nDimen = ndims(inMat);
    end
    for i=1:nDimen
        if isempty(find(indexMat(:,1)==i))
            kloogText = [kloogText ':'];
        else
            kloogText = [kloogText num2str(indexMat(find(indexMat(:,1)==i),2))];
        end
        if i~=nDimen
            kloogText = [kloogText ','];
        else
            kloogText = [kloogText ')'];
        end
    end
	outMat = eval(kloogText);
else
    outMat = inMat;
end
