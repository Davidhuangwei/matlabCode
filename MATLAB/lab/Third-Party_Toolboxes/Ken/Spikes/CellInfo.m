% [xg Type Label] = CellInfo(DescList)
%
% creates a structure containing information about cells, suitable for
% passing to xgobi. gets some stuff from db, also from .meanthph
% and .info files if present
%
% Type is 1 for Pyramidal, 2 for interneuron, 3 for other.
%
% label is a string.
% so you would run xgobi(xg, Type, [], Label);
%
% optional argument DescList gives the option to specifiy a list of descriptions
% and it will only give cells fitting those 

function [xg, Type, Label] = CellInfo(DescList)

sqlHead = ['SELECT FileBase, Description, Cells.Type, Files.FileID, nCh, nBits, SampleRate, ' ...
    'ElecGps.ElecGpID, GpNo, CellID, BigCluNo, SmallCluNo, eDist, bRat, fRate, IFNULL(EquivClass,0) '];

if nargin>=1
    if iscell(DescList)
        List = CommaList(strcat('''', DescList, ''''));
        sqlTail = ['FROM Files, ElecGps, Cells WHERE Files.FileID=ElecGps.FileID '...
            'AND ElecGps.ElecGpID=Cells.ElecGpID AND Description In (' List ');'];
    else
        sqlTail = ['FROM Files, ElecGps, Cells WHERE Files.FileID=ElecGps.FileID '...
            'AND ElecGps.ElecGpID=Cells.ElecGpID AND Description LIKE "' DescList '";'];
    end
    
else 
    sqlTail = ['FROM Files, ElecGps, Cells WHERE Files.FileID=ElecGps.FileID '...
            'AND ElecGps.ElecGpID=Cells.ElecGpID;'];
end
[FileBase, Description, sType, xg.FileID, xg.nCh, xg.nBits, xg.SampleRate, xg.ElecGpID, xg.GpNo, xg.CellID, xg.BigCluNo, xg.SmallCluNo, xg.eDist, xg.bRat, xg.fRate, xg.EquivClass] = ...
mysql([sqlHead sqlTail], 'extra', '%s %s %s %f %f %f %f %f %f %f %f %f %f %f %f %f');

% now run query on CellInfo table
MyIDs = sprintf(',%d', xg.CellID); MyIDs = MyIDs(2:end);
isql = sprintf('SELECT * FROM CellInfo WHERE CellID IN (%s) ORDER BY CellID', MyIDs); 
InfoOut = mysql(isql, 'extra');
fn = fieldnames(InfoOut);
for i=1:length(fn)
    if strcmp(fn{i},'CellID'), continue; end;
    xg = setfield(xg, fn{i}, str2double(getfield(InfoOut,fn{i})));
end

% get locations (needs a separate query because can contain spaces)
lsql = sprintf('SELECT Location FROM ElecGps, Cells WHERE ElecGps.ElecGpID = Cells.ElecGpID AND CellID IN (%s) ORDER BY CellID', MyIDs); 
LocOut = mysql(lsql, 'extra');
xg.Location = zeros(size(xg.CellID)); % set to zeros first - this is default (unknown)
xg.Location(find(strcmp(LocOut.Location, '1'))) = 1; % specific values
xg.Location(find(strcmp(LocOut.Location, '3'))) = 3;
xg.Location(find(strcmp(LocOut.Location, '3 a'))) = 3.1;
xg.Location(find(strcmp(LocOut.Location, '3 b'))) = 3.2;
xg.Location(find(strcmp(LocOut.Location, '3 c'))) = 3.3;
xg.Location(find(strcmp(LocOut.Location, 'h'))) = 5;

% remove all from last but one / from FileBase
for i=1:length(FileBase)
    Sorted = sort(find(FileBase{i}=='/'));
    if length(Sorted)>=2
        Pos = Sorted(length(Sorted)-1)+1;
    else
        Pos = 1;
    end
    Name{i,1} = FileBase{i}(Pos:end);
end

% Convert location to number

Label = strcat(Description, ':', Name, '.', num2str(xg.BigCluNo));
Type = 3*ones(length(sType),1);
Type(find(strcmp(sType, 'p')))=1;
Type(find(strcmp(sType, 'b')))=2;

if nargout==0
    xgobi(xg, Type, [], Label);
end

return;

% this is what you call
[xg Type Labels] = CellInfo('Run');
Good = (xg.eDist>20 & xg.bSpace>0 & xg.nThSpk>100 & Type==1 & xg.FileID>3);
xg.gain = xg.bBoth25 - xg.bSpace;
xg2 = StructArray(xg);
xgSub = StructArray(xg2(find(Good)));
xgSub.MeanThPh = mod(xgSub.MeanThPh,2*pi)*180/pi;
xgobi(xgSub);
%xgobi(xg, Type, 31-Good*5, Labels);

[xgJ TypeJ LabelsJ] = CellInfo('Josef');
xgJ2 = rmfield(xgJ, {'bSpace', 'bPop25', 'bBoth25', 'bPeakPop', 'tPeakPop', 'bPeakBoth', 'tPeakBoth'});
xgobi(xgJ2, TypeJ, [], LabelsJ); 
% compute animal ID
LabelsChar = char(LabelsJ);
[dummy dummy Animal] = unique(LabelsChar(:,1:9), 'rows');
Labels

[xgS TypeS LabelsS] = CellInfo('%Sleep%');
xgS2 = rmfield(xgS, {'bSpace', 'bPop25', 'bBoth25', 'bPeakPop', 'tPeakPop', 'bPeakBoth', 'tPeakBoth'});
xgS2.MeanThPh = mod(xgS.MeanThPh,2*pi)*180/pi;
GoodS = (xgS.eDist>20 & xgS.nThSpk>100 & TypeS==1);
xgobi(xgS2, TypeS, 31-5*GoodS, LabelsS); 

% find familiar vs. novel
CharLabelsS = char(LabelsS); xgS.Novel = (CharLabelsS(:,15)=='n');
ColorScatter([xgS.ElecGpID(GoodS), xgS.MeanThPh(GoodS)], xgS.GpNo(GoodS));
CircAnova(xgS.MeanThPh(GoodS), xgS.ElecGpID(GoodS))

Descs = {'Run', 'George', 'Wheel', 'Sleep%', 'Josef', 'CA3%'};
for i=1:6
    [xgi Typei] = CellInfo(Descs{i});
    xgstow{i} = xgi;
    Typestow{i} = Typei;
end

for i=1:6
    clear xgi Typei;
    xgi = xgstow{i}; Typei = Typestow{i};
	Bins = 0:20:360;
	subplot(2,3,i)
	hist(mod(xgi.MeanThPh(find(Typei==1 & xgi.pTh<.05 & xgi.eDist>20))*180/pi,360), Bins);
	title(Descs{i});
	xlim([0 360]);
    set(gca, 'xtick', 0:90:360);
    drawnow
end

subplot(1,3,2)
hist(mod(xgS.MeanThPh(find(TypeS==1 & xgS.pTh<.05 & xgS.eDist>20))*180/pi,360), Bins);
title('Sleep');
xlim([0 360])

subplot(1,3,3)
hist(mod(xgJ.MeanThPh(find(TypeJ==1 & xgJ.pTh<.05 & xgJ.eDist>20))*180/pi,360), Bins);
title('Josef CA1');
xlim([0 360])
