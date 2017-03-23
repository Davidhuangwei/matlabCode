function KenjiMakeInfo(FileBase,PyrIntMap,Clean)

Par = LoadPar([FileBase '.xml']);
if nargin<2 | isempty(PyrIntMap)
    load('../Rat5_All_Region_PyrIntMap_Clean.mat','PyrIntMap','Clean');
end

% PyrIntMap = 
% 
%             Map: [7846x43 double]
%            date: '25-Dec-2008'
%        fileBase: {1x115 cell}
%     whichRegion: {{1x8 cell}  {1x2 cell}  {1x2 cell}}
%         content: {1x43 cell}
%       WhichFile: {'ec012'  'ec013'  'ec014'  'ec015'  'ec016'  'i01_m'}
% 
% 
% 
% PyrIntMap.content(:)'
% 
% ans = 
% 
%   Columns 1 through 10
%      'file_ID'    'cell_ID'    'ele'    'clu'    'exciting'    'inhibiting'    'excited'    'inhibited'    'wide'    'narrow'
%   Columns 11 through 18
%     'IsPositive'    'eDist'    'RefracRatio'    'RefracViol'    'eDist_ind'    'RefracRatio_ind'    'RefracViol_ind'    'FileID'
%   Columns 19 through 26
%     'RegionID'    'AnimalID'    'FireRate'    'totalFireRate'    'Clean_G'    'Clean_ind'    'COM_15_msec'    'COM_20_msec'
%   Columns 27 through 33
%     'COM_25_msec'    'COM_30_msec'    'COM_40_msec'    'COM_50_msec'    [1x22 char]    'Wide_ind_WidthR-COM'    [1x29 char]
%   Columns 34 through 41
%     [1x25 char]    [1x24 char]    [1x21 char]    [1x31 char]    [1x27 char]    [1x22 char]    [1x24 char]    'Wide_final'
%   Columns 42 through 43
%     'Narrow_final'    [1x37 char]

FileInd = find(strcmp(PyrIntMap.fileBase,FileBase));

Info.Par = Par;
Info.Map = PyrIntMap.Map(PyrIntMap.Map(:,1)==FileInd,:);
Info.content = PyrIntMap.content;
Info.whichRegion=PyrIntMap.whichRegion;
Info.Clean = Clean(PyrIntMap.Map(:,1)==FileInd);


[OrderedMap ReorderInd GoodInd] = unique(Info.Map(:,[3 4]),'rows'); % reorders to get the index within normal map

%reorder the Info.Map accordingly

Info.Map = Info.Map(ReorderInd,:);
Info.Clean = Info.Clean(ReorderInd);

%important! the order of units is not as in Map from LoadCluRes!!!! it is
%ordered by unit origin and not electrode/cluster number

% Clean = Map(:,12)<3 | Map(:,14)>0.02 | (Map(:,14)>0.01  & Map(:,13)>0.3) | (Map(:,14)>0.008 & Map(:,13)>0.4) | ...
%     (Map(:,14)>0.007 & Map(:,13)>0.5) | (Map(:,14)>0.006 & Map(:,13)>0.6) | (Map(:,14)>0.005 & Map(:,13)>0.7);
% 
% Clean = ~Clean;

save([FileBase '.info.mat'],'Info');




