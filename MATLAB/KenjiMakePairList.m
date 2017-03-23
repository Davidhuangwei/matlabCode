function [PairList Lab] = KenjiMakePairList(FileBase,varargin)
if isstruct(FileBase)
    Info = FileBase;
else
    load([FileBase '.info.mat']);
end
Type = {'Int','Pyr'};
Lab = {};

for ii=1:3
    for jj=[1 2 4]
        for ll=[0 1]
            % we just need Map = Info.Map(:,[43. 19 41]) which contains: 
% region, cell type and int/pyr 
           inds = find(Info.Map(:,43)==ii & Info.Map(:,19)==jj & Info.Map(:,41)==ll & Info.Clean);
            if isempty(inds) continue; end
            nkk = length(inds);
            for kk=inds(:)'
                tit = sprintf('%s, %s ; %d %d %d\n',Info.whichRegion{ii}{jj}, Type{Info.Map(kk,41)+1},[kk Info.Map(kk,[3 4])]);
             %   fprintf(tit);
                Lab{kk,1} = [Info.whichRegion{ii}{jj} Type{Info.Map(kk,41)+1}];
                %Lab{cnt,2} = Type{Info.Map(kk,41)+1};
            end
        end
    end
end
%%PairLab = {{'EC3Pyr'},{'EC2Pyr','EC5Pyr','CA1Pyr','CA3Pyr','DGPyr','EC2Int','EC5Int','CA1Int','CA3Int','DGInt'

PreLab = {'EC2Pyr','EC3Pyr','EC5Pyr'};
PostLab = {'EC2Pyr','EC3Pyr','EC5Pyr','CA1Pyr','CA3Pyr','DGPyr','EC2Int','EC3Int','EC5Int','CA1Int','CA3Int','DGInt'};
PairList = [];
for kk=1:length(PreLab)
    for jj=1:length(PostLab)
        myPairsPre = find(strcmp(Lab,PreLab{ii}));
        myPairsPost = find(strcmp(Lab,PostLab{ii}));
        myPairsList = cat(3,repmat(myPairsPre,1,length(myPairsPost)), repmat(myPairsPost',length(myPairsPre),1));
        myPairsList = reshape(myPairsList,[],2);
        PairList = cat(1,PairList,myPairsList);
    end
end
