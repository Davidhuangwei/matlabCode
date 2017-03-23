function unionEpochs = UnionEpochs(varargin)


if any(any(round(cat(1,varargin{:})) ~= cat(1,varargin{:}))) % check if we have decimal values
        error(['Matlab:' mfilename ':EpochsMustBeInteger'],...
            'Epochs must be integers until you write better code');
else
    maxSamp = max(max(cat(1,varargin{:})));
    unionVec = zeros(maxSamp,1);
    for j=1:length(varargin)
        for k=1:size(varargin{j},1)
            unionVec(varargin{j}(k,1):varargin{j}(k,2)) = 1;
        end
    end
    unionEpochs = Times2Epochs(find(unionVec),1);
    if ~isempty(unionEpochs)
        unionEpochs(:,2) = unionEpochs(:,2) -1;
    end
end

return