fileBase = 'sm9608_346'
fileBase = 'sm9614_382'

cellTypes = LoadCellTypes([fileBase '.type']);
cellLayer = LoadCellLayers([fileBase '.cellLayer']);

strcmp('w',cells(:,1))
cells = cat(2,cellTypes(:,3),cellLayer(:,3))

cellTypeNames = {'n','w'}
cellLayerNames = struct2cellarray(LoadVar('../ChanInfo/SelChan.eeg.mat'))

cellMat ={}
for j=1:length(cellTypeNames)
    for k=1:length(cellLayerNames)
        cellMat{k,j} = sum(strcmp(cellTypeNames{j},cells(:,1)) & strcmp(cellLayerNames{k},cells(:,2)));
    end
end
cat(2,cellLayerNames(:,1),cellMat)

                int   princ
sm9603
   'or'        [1]    [ 0]
    'ca1Pyr'    [0]    [10]
    'rad'       [0]    [ 0]
    'lm'        [0]    [ 0]
    'mol'       [1]    [ 0]
    'gran'      [1]    [ 0]
    'hil'       [0]    [ 2]
    'ca3Pyr'    [0]    [ 5]
    
sm9608
ans = 

    'or'        [1]    [ 0]
    'ca1Pyr'    [2]    [19]
    'rad'       [2]    [ 0]
    'lm'        [0]    [ 0]
    'mol'       [0]    [ 0]
    'gran'      [1]    [ 2]
    'hil'       [2]    [ 3]
    'ca3Pyr'    [0]    [ 6]

sm9614
    'or'        [0]    [ 0]
    'ca1Pyr'    [0]    [ 0]
    'rad'       [0]    [ 0]
    'lm'        [0]    [ 0]
    'mol'       [0]    [ 0]
    'gran'      [3]    [ 1]
    'hil'       [1]    [ 3]
    'ca3Pyr'    [3]    [15]
    
    
    Alternation task place cell firing
sm9603
low
11111.1
not low off run arms
11

sm9608
low
11111.1
not low off run arms
111

sm9614
low
1111
not low off run arms
1111
    