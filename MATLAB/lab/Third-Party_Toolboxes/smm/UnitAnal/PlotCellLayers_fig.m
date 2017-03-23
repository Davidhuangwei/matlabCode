function PlotCellLayers(unitAnalDir,fileBase,varargin)
chanInfoDir = DefaultArgs(varargin,{'ChanInfo/'});

cluLocFile = [unitAnalDir fileBase '.cluloc'];
typeFile = [unitAnalDir fileBase '.type'];
chanMatFile = [chanInfoDir 'ChanMat.eeg.mat'];
chanLocFile = [chanInfoDir 'ChanLoc_Full.eeg.mat'];
anatCurvesFile = [chanInfoDir 'AnatCurves.mat'];
offsetFile = [chanInfoDir 'Offset.eeg.txt'];
cellLayerFile = [unitAnalDir fileBase '.cellLayer'];

cluLoc = load(cluLocFile);
chanMat = LoadVar(chanMatFile);
chanLoc = LoadVar(chanLocFile);
offset = load(offsetFile);
cellType = LoadCellTypes(typeFile);

cellLayer = LoadCellLayers(cellLayerFile);
anatLayers = unique(cellLayer(:,3));

%anatLayers = fieldnames(chanLoc);
% for j=1:size(cluLoc,1)
%     cellLayer{j,1} = cluLoc(j,1);
%     cellLayer{j,2} = cluLoc(j,2);
%     for k=1:length(anatLayers)
%         if sum([chanLoc.(anatLayers{k}){:}] == cluLoc(j,3))>0
%             cellLayer{j,3} = anatLayers{k};
%         end
%     end
% end

plotColors = [...
    0 0 0; ...
    1 1 1; ...
    0.5 0 0.5;...
    1 0 1; ...
    1 1 0; ...
    0 0 1; ...
    0.5 0.5 0.5; ...
    [1 0 0]
    ];
%noDesigColor = ;
keyboard

figure(1)
clf
imagesc(ones(size(chanMat)));
PlotAnatCurves(anatCurvesFile,size(chanMat),0.5-offset)
set(gca,'ylim',[0.5 size(chanMat,1)+0.5],'xlim',[0.5 size(chanMat,2)+0.5])
set(gca,'ytick',[0:size(chanMat,1)+1],'xtick',[0:size(chanMat,2)+1])
grid on
hold on
for j=1:size(chanMat,1)
    for k=1:size(chanMat,2)
    plot(k,j,'ks','markersize',3)
    end
end
prevLoc = zeros(size(chanMat));
for j=1:size(cluLoc,1)
    hold on
    jitter = [rand(1,1)/2 rand(1,1)/4];
    [m,n] = find(chanMat==cluLoc(j,3));
    prevLoc(m,n) = prevLoc(m,n) + 1;
    newAngle = prevLoc(m,n)*60/360*pi
figure(1)
clf
imagesc(ones(size(chanMat)));
PlotAnatCurves(anatCurvesFile,size(chanMat),0.5-offset)
set(gca,'ylim',[0.5 size(chanMat,1)+0.5],'xlim',[0.5 size(chanMat,2)+0.5])
set(gca,'ytick',[0:size(chanMat,1)+1],'xtick',[0:size(chanMat,2)+1])
hold on
for j=1:size(chanMat,1)
    for k=1:size(chanMat,2)
    plot(k,j,'ks','markersize',3)
    end
end
prevLoc = zeros(size(chanMat));
for j=1:size(cluLoc,1)
    hold on
    jitter = [rand(1,1)/2 rand(1,1)/4];
    [m,n] = find(chanMat==cluLoc(j,3));
    prevLoc(m,n) = prevLoc(m,n) + 1;
    newAngle = (prevLoc(m,n)*90 + 90)/180*pi;
    jitter = [sin(newAngle) cos(newAngle)*3]*0.1;
    switch cellType{j,3}
        case 'w'
            cellMarker = '^';
        case 'n'
           cellMarker = 'o';
        otherwise
            cellMarker = 'd';
    end
            
    plot(n+jitter(1),m+jitter(2),['r' cellMarker],'markersize',7)
end
  ;
    jitter = [sin(newAngle) cos(newAngle)]*0.25;
    plot(n+jitter(1),m+jitter(2),'ro')
end
    if sum(strcmp(anatLayers,cellLayer{j,3}))>0
        plotColor = plotColors(strcmp(anatLayers,cellLayer{j,3}),:);
%     else
%         plotColor = noDesigColor;
    end
    text(n-0.25+jitter(1),m-0.25+jitter(2),[num2str(cluLoc(j,1)) ',' num2str(cluLoc(j,2)) ':' cellType{j,3}],...
        'fontsize',2,'color',plotColor)
end
for k=1:length(anatLayers)
    text(0,k,anatLayers{k},'color',plotColors(k,:));
end
%text(0,length(anatLayers)+1,'noDesig','color',noDesigColor);