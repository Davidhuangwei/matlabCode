function interpChans = InterpNearAve1D(oldChans,chanMat,badChans)
% function interpChans = InterpNearAve(oldChans,chanMat,badChans)

interpChans = oldChans;
if ~isempty(badChans)
    for i=1:length(badChans)

        [m, n] = find(chanMat == badChans(i));

        above = 1;
        while  ~isempty(find(badChans(i)-above == badChans))
            above = above + 1;
        end
        if isempty(find(chanMat(:,n) == (badChans(i)-above)))
            above = inf;
        end


        below = 1;
        while  ~isempty(find(badChans(i)+below == badChans))
            below = below + 1;
        end
        if isempty(find(chanMat(:,n) == (badChans(i)+below)))
            below = inf;
        end

        if above==below
            if isinf(above) & isinf(below)
                interpChans(badChans(i),:) = oldChans(badChans(i),:);
            else

                interpChans(badChans(i),:) = mean([oldChans(badChans(i)-above,:); oldChans(badChans(i)+below,:)],1);
            end
        end
        if above < below
            interpChans(badChans(i),:) = oldChans(badChans(i)-above,:);
        end
        if below < above
            interpChans(badChans(i),:) = oldChans(badChans(i)+below,:);
        end
    end
end
return


        
        