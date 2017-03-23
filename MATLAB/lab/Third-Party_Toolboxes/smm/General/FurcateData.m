% function varargout = FurcateData(furcateVec,data,varargin)
% varargout={outData,indexes};
% furcateArg = DefaultArgs(varargin,{'round'});
% mulitfurcates data to the values in furcateVec. 
% FurcateArg specifies how data is rounded to furcateVec values:
% ceil increases data values to next furcateVec value
% floor decreases data values to next furcateVec value
% round finds nearest furcateVec value
% tag:furcate
% tag:ceil
% tag:floor
% tag:round
% 
function varargout = FurcateData(furcateVec,data,varargin)
furcateArg = DefaultArgs(varargin,{'round'});

tempData = [];
ltData = [];
gtData = [];
for j=1:length(furcateVec)
    tempData = cat(1,tempData,shiftdim(clip(data,min(furcateVec),max(furcateVec))-furcateVec(j),-1));
    gtData = cat(1,gtData,shiftdim(data>=furcateVec(j),-1));
    ltData = cat(1,ltData,shiftdim(data<=furcateVec(j),-1));    
end

switch furcateArg
    case 'round'
        [minVal minInd] = min(abs(tempData),[],1);
        indexes = shiftdim(minInd,1);
        minInd = shiftdim(minInd,1);
        outData = furcateVec(minInd);

    case 'floor'
        furcData = repmat(furcateVec(:),[1 size(data)]);
        gtIndexes = logical(cat(1,gtData(1,:,:),diff(gtData,1)));
        indexes = shiftdim(gtIndexes,1);
        outData = -inf*ones(size(furcData));
        outData(gtIndexes) = furcData(gtIndexes);
        outData = shiftdim(max(outData),1);

    case 'ceil'
        furcData = repmat(furcateVec(:),[1 size(data)]);
        ltIndexes = logical(cat(1,diff(ltData,1),ltData(end,:,:)));
        indexes = shiftdim(ltIndexes,1);
        outData = inf*ones(size(furcData));
        outData(ltIndexes) = furcData(ltIndexes);
        outData = shiftdim(min(outData),1);
    otherwise
        error([mfilename ':UnknownFurcateArg'],...
            ['furcateArg "' furcateArg '" unknown. Use: round, ceil, floor'])
end

varargout={outData,indexes};
varargout=varargout(1:nargout);


