
%%% Split .sts %%%
SplitStsEpochs(fileBaseCell,'ec014.192_204',{'.sts.RUN','.sts.REM'})
save('FileInfo/AllFiles',SaveAsV6,'fileBaseCell')
allFiles = fileBaseCell;
mazeFiles = {};
remFiles = {};
for j=1:length(allFiles)
    temp = load([allFiles{j} '/' allFiles{j} '.sts.REM']);
    if ~isempty(temp)
        remFiles = cat(1,remFiles,allFiles(j));
    end
    temp = load([allFiles{j} '/' allFiles{j} '.sts.RUN']);
    if ~isempty(temp)
        mazeFiles = cat(1,mazeFiles,allFiles(j));
    end
end
fileBaseCell = mazeFiles
save('FileInfo/MazeFiles.mat',SaveAsV6,'fileBaseCell')
fileBaseCell = remFiles
save('FileInfo/RemFiles.mat',SaveAsV6,'fileBaseCell')
    
    


%%% make dirs %%%
fromDir = '/jags1/kenji/ec014.17/'
toDir = './'
fileBaseCell = dir([fromDir 'ec*'])
fileBaseCell = {fileBaseCell.name}'
for j=1:length(fileBaseCell)
    mkdir([toDir fileBaseCell{j}]);
end

%%% file linking %%%
fileBaseCell = dir('ec*')
fileBaseCell = {fileBaseCell.name}'
baseDir = '/jags1/kenji/ec014.17/'
for j=1:length(fileBaseCell)
    cd(fileBaseCell{j})
    evalText = ['!ln -s ' baseDir fileBaseCell{j} '/* .'];
    fprintf('%s\n',evalText)
    eval(evalText)
    cd ..
end

%%% rm * links %%
fileBaseCell = dir('ec*')
fileBaseCell = {fileBaseCell.name}'
for j=1:length(fileBaseCell)
    evalText = ['!rm ' fileBaseCell{j} '/"*"'];
    EvalPrint(evalText);
end


%%% file copying %%%
fileBaseCell = dir('ec*')
fileBaseCell = {fileBaseCell.name}'
fileBaseCell(2) = [] 
baseDir = '/unit2/ec013.46/';
for j=1:length(fileBaseCell)
    toFile = [fileBaseCell{j} '/' fileBaseCell{j} '.eeg'];
    fromFile = [baseDir toFile];
    CpFile(fromFile,toFile,1)
    
    toFile = [fileBaseCell{j} '/' fileBaseCell{j} '.whl'];
    fromFile = [baseDir toFile];
    CpFile(fromFile,toFile,1)
end

%%%%% CSD chanCell %%%%
ecChanCell = {};
for k=0:8:8
    for j=1:8
        ecChanCell = cat(2,ecChanCell,[j+k:8:j+k+16]);
    end
end
dgChanCell = {};
for j=34:8:59
    for k=0:2
    dgChanCell = cat(2,dgChanCell,j+k:2:j+k+4);
    end
end
chanCell = cat(2,ecChanCell,dgChanCell)

ecChanCell = {};
for k=64:8:72
    for j=1:8
        ecChanCell = cat(2,ecChanCell,{[j+k:8:j+k+16]});
    end
end
dgChanCell = {};
for j=2:8:63
    for k=0:2
    dgChanCell = cat(2,dgChanCell,{[j+k:2:j+k+4]});
    end
end
chanCell = cat(2,dgChanCell,ecChanCell)

nChan = 99;
 FileCSD_sm(fileBaseCell,'.eeg',nChan,chanCell,[1]);
 
%%% CSD ChanMat %%%
chanMat = flipud(cat(2,[25:32]',[33:40]',[24,24,24,1,2,3,24,24]',[24,24,24,4,5,6,24,24]',...
    [24,24,24,7,8,9,24,24]',[24,24,24,10,11,12,24,24]',...
    [24,24,24,13,14,15,24,24]',[24,24,24,16,17,18,24,24]',...
    [24,24,24,19,20,21,24,24]',[24,24,24,22,23,24,24,24]'))
    
save('ChanInfo/ChanMat.csd1.mat',SaveAsV6,'chanMat')                              

badChan = [9 26 28];
badChan = [24];
msave('ChanInfo/BadChan.csd1.txt',badChan)

selChan.ECsm = 2;
selChan.ECdm = 10;
selChan.DGg = 20;
selChan.CA1p = 20;
save('ChanInfo/SelChan.csd1.mat',SaveAsV6,'selChan')

offset = [0 0];
msave('ChanInfo/Offset.csd1.txt',offset)

nChan = 28;
msave('ChanInfo/NChan.csd1.txt',nChan)

FileCSD_sm(allFiles,'.eeg',65,chanCell,[1])

multVect = repmat(1/((0.2^2)/(0.1^2)),[16,1])
multVect = repmat(1/((0.02^2)/(0.1^2)),[16,1])

%%%% CSD Spect linking  %%%%
analDirs = {...
    '/BEEF03/smm/drugs/DrugsAnal/sm9608_448-455/analysis/',...
    '/BEEF03/smm/drugs/DrugsAnal/sm9614_564-575/analysis/',...
    '/BEEF03/smm/drugs/DrugsAnal/sm9614_544-557/analysis/',...
    '/BEEF03/smm/KenjiData/ec013.50/analysis/'
    '/BEEF03/smm/KenjiData/ec013.46/analysis/'
    '/BEEF03/smm/KenjiData/ec014.27/analysis/'...
    '/BEEF03/smm/KenjiData/ec014_Analysis/ec014.16/analysis'...
    '/BEEF03/smm/KenjiData/ec014_Analysis/ec014.17/analysis'...
    }


addpath /u12/smm/matlab/bats/
oldFileExt = '.eeg'
newFileExt = '.csd1'
mazeFiles = LoadVar('FileInfo/MazeFiles')
remFiles = LoadVar('FileInfo/RemFiles')
analName = 'RemVsRun04_allTheta_MinSpeed0wavParam6Win1250';
remAnalName = 'CalcRemSpectra06_allTimes_wavParam6Win1250';
runAnalName = 'CalcRunningSpectra15_allTheta_MinSpeed0wavParam6Win1250';
MkSpectAnalDirsBat(mazeFiles,[runAnalName newFileExt])
MkSpectAnalDirsBat(remFiles,[remAnalName newFileExt])
 fileExtCell = {...
                  '.eeg',...
                 '_LinNearCSD121.csd',...
                 '.csd1',...
                 '.csd111',...
%                   '_NearAveCSD1.csd',...
                }
MakeRemVsRunLinks(analDirs, fileExtCell,analName,remAnalName,runAnalName)

            
CpSpectAnalFilesBat({[pwd '/']},{'RemFiles','MazeFiles'},[analName oldFileExt],...
    [analName newFileExt],'infoStruct*')
CpSpectAnalFilesBat({[pwd '/']},{'RemFiles','MazeFiles'},[analName oldFileExt],...
    [analName newFileExt],'time*')
CpSpectAnalFilesBat({[pwd '/']},{'RemFiles','MazeFiles'},[analName oldFileExt],...
    [analName newFileExt],'eegSegTime*')
CpSpectAnalFilesBat({[pwd '/']},{'RemFiles','MazeFiles'},[analName oldFileExt],...
    [analName newFileExt],'allEegSegTime*')
CpSpectAnalFilesBat({[pwd '/']},{'RemFiles','MazeFiles'},[analName oldFileExt],...
    [analName newFileExt],'keptTime*')


%%% CSD111 Stuff %%
chanAveCell

FileChanAve(allFiles,'.csd1','.csd111',40,chanAveCell)
chanMat = flipud(cat(2,[1:8]',[9:16]',[28,28,28,17,18,19,28,28]',[28,28,28,20,21,22,28,28]',...
    [28,28,28,23,24,25,28,28]',[28,28,28,26,27,28,28,28]'))

chanCell = {}
for j=1:16
    chanCell{j} = j;
end
chanCell = cat(2,chanCell,[17:19],[20:22],[23:25],[26:28])

chanMat = flipud(cat(2,[1:8]',[9:16]',[20,20,20,20,17,20,20,20]',[20,20,20,20,18,20,20,20]',...
    [20,20,20,20,19,20,20,20]',[20,20,20,20,20,20,20,20]'))
save('ChanInfo/ChanMat.csd111.mat',SaveAsV6,'chanMat')                              

badChan = [9 20];
msave('ChanInfo/BadChan.csd111.txt',badChan)

selChan.ECsm = 2;
selChan.ECdm = 10;
selChan.DGg = 20;
selChan.CA1p = 18;
save('ChanInfo/SelChan.csd111.mat',SaveAsV6,'selChan')

offset = [0 0];
msave('ChanInfo/Offset.csd111.txt',offset)

nChan = 20;
msave('ChanInfo/NChan.csd111.txt',nChan)


%%% Extra Junk %%%
csd21 = readMulti('ec013.819/ec013.819.csd1',28,21);
csdAve202122 = mean([csd20'; csd21'; csd22']);


clf 
hold on
plot(csd20*4+2000,'m')
plot(csdAve202122*4+2000,'g')
plot(csd2+2000,'c')   
plot(eeg44,'r')       
plot(eeg2,'b')            
PlotVertLines(eegSegTime+1250,[-2000 -1000],'color','k')
PlotVertLines(eegSegTime,[-2000 -1000],'color','g')     
set(gca,'xlim',[0 1250]+eegSegTime(2))
set(gca,'ylim',[-2000 4000])       


plot(csdAve202122*4+2000,'k')


selChan = Struct2CellArray(LoadVar('ChanInfo/SelChan.eeg.mat'))
for j=1:size(selChan,1)
subplot(size(selChan,1),1,j)
% [out xbins ybins] = hist2([speed.p0 thetaPowIntg(:,selChan{j,2})],10,10);
% pcolor(xbins(1:end-1),ybins(1:end-1),out);
% pcolor(out);
% shading interp
semilogx(speed.p0,thetaPowIntg(:,selChan{j,2}),'.')
ylabel({selChan{j,1} ,'thetaPowIntg4-12Hz'})
end
xlabel('running speed')
set(gcf,'name','ThetaPowVsRunningSpeedScat')

