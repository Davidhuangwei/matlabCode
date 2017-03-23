function CalcUnitTrigRates(fileBaseCell,trigFileName,timeWin,timeRes,varargin)
datSamp = DefaultArgs(varargin,{20000});

to = -timeWin/2:timeRes:timeWin/2;

for k=1:length(fileBaseCell)
    fileBase = fileBaseCell{k};
    cellTypes = LoadCellTypes([SC(fileBase) fileBase '.type' ]);
    trigTimes = load([SC(fileBase) trigFileName]);
    trigRateSeg = zeros(size(cellTypes,1),timeWin/timeRes +1);
    elNum = 0;
    for m=1:size(cellTypes,1)
        if elNum ~= cellTypes{m,1}% saves a little time
            clu = load([fileBase '/' fileBase '.clu.' num2str(cellTypes{m,1})]);
            res = load([fileBase '/' fileBase '.res.' num2str(cellTypes{m,1})]);
        end
        elNum = cellTypes{m,1};
        selInd = clu(2:end)==cellTypes{m,2};
        for n=1:length(trigTimes)
            spks = res(selInd & res>round((trigTimes(n)-timeWin/2)*datSamp) ...
                & res<round((trigTimes(n)+timeWin/2)*datSamp));
            spks = spks/datSamp-trigTimes(n);
            rate = hist(spks,to)/timeRes;
            if ~isempty(rate)
                trigRateSeg(m,:) = trigRateSeg(m,:) + rate/length(trigTimes);
            end
        end

    end
    trigRates.rates = trigRateSeg;
    trigRates.to = to;
    trigRates.numEpochs = length(trigTimes);
    trigRates.timeWin = timeWin;
    trigRates.timeRes = timeRes;
    fileName = [SC(fileBase) trigFileName '_UnitRates' num2str(timeWin) 's.mat'];
    fprintf('Saving: %s\n',fileName);
    save(fileName,SaveAsV6,'trigRates')
end