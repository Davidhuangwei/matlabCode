analDirs = {...
            '/BEEF02/smm/sm9614_Analysis/analysis02/',...
            '/BEEF02/smm/sm9608_Analysis/analysis02',...
            '/BEEF01/smm/sm9601_Analysis/analysis03/',...
            '/BEEF01/smm/sm9603_Analysis/analysis04/',...
            }
 fileExtCell = {...
                '.eeg',...
                '_LinNear.eeg',...
                '_LinNearCSD121.csd',...
                }
for j=1:length(analDirs)
    cd(analDirs{j})
    CalcRunningSpectra8_2_CalcRunningSpectra9(LoadVar('MazeFiles'));
    RecalcThetaGammaRange(LoadVar('MazeFiles'),fileExtCell,[],[60 120]);
end



cd /BEEF02/smm/sm9608_Analysis/analysis02
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'.eeg',97,626,1,[6 12],[60 120])
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_LinNear.eeg',97,626,1,[6 12],[60 120])
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_LinNearCSD121.csd',72,626,1,[6 12],[60 120])

cd /BEEF02/smm/sm9614_Analysis/analysis02/
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_LinNearCSD121.csd',72,626,1,[6 12],[60 120])


cd /BEEF02/smm/sm9614_Analysis/analysis02/
FileInterpCSDInterp(LoadVar('RemFiles'),97,'LinNear',[1 2 1],1)
cd /BEEF01/smm/sm9603_Analysis/analysis04/
FileInterpCSDInterp(LoadVar('RemFiles'),97,'LinNear',[1 2 1],1)
cd /BEEF02/smm/sm9608_Analysis/analysis02
FileInterpCSDInterp(LoadVar('RemFiles'),97,'LinNear',[1 2 1],0)
cd /BEEF01/smm/sm9601_Analysis/analysis03/
FileInterpCSDInterp(LoadVar('RemFiles'),81,'LinNear',[1 2 1],0)

cd /BEEF02/smm/sm9614_Analysis/analysis02/
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'.eeg',97,1250,0,[4 12],[60 120])
CalcRemSpectra02('allTimes',LoadVar('RemFiles'),'.eeg',97,1250,[4 12],[60 120])
%CalcRemSpectra02('allTimes',LoadVar('RemFiles'),'_LinNear.eeg',97,626,[6 12],[60 120])
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_LinNearCSD121.csd',72,1250,0,[4 12],[60 120])
CalcRemSpectra02('allTimes',LoadVar('RemFiles'),'_LinNearCSD121.csd',72,1250,[4 12],[60 120])
cd /BEEF01/smm/sm9603_Analysis/analysis04/
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'.eeg',97,1250,0,[4 12],[60 120])
CalcRemSpectra02('allTimes',LoadVar('RemFiles'),'.eeg',97,1250,[4 12],[60 120])
%CalcRemSpectra02('allTimes',LoadVar('RemFiles'),'_LinNear.eeg',97,626,[6 12],[60 120])
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_LinNearCSD121.csd',72,1250,0,[4 12],[60 120])
CalcRemSpectra02('allTimes',LoadVar('RemFiles'),'_LinNearCSD121.csd',72,1250,[4 12],[60 120])
cd /BEEF02/smm/sm9608_Analysis/analysis02
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'.eeg',97,1250,0,[4 12],[60 120])
CalcRemSpectra02('allTimes',LoadVar('RemFiles'),'.eeg',97,1250,[4 12],[60 120])
%CalcRemSpectra02('allTimes',LoadVar('RemFiles'),'_LinNear.eeg',97,626,[6 12],[60 120])
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_LinNearCSD121.csd',72,1250,0,[4 12],[60 120])
CalcRemSpectra02('allTimes',LoadVar('RemFiles'),'_LinNearCSD121.csd',72,1250,[4 12],[60 120])
cd /BEEF01/smm/sm9601_Analysis/analysis03/
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'.eeg',81,1250,0,[4 12],[60 120])
CalcRemSpectra02('allTimes',LoadVar('RemFiles'),'.eeg',81,1250,[4 12],[60 120])
%CalcRemSpectra02('allTimes',LoadVar('RemFiles'),'_LinNear.eeg',97,626,[6 12],[60 120])
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_LinNearCSD121.csd',72,1250,0,[4 12],[60 120])
CalcRemSpectra02('allTimes',LoadVar('RemFiles'),'_LinNearCSD121.csd',72,1250,[4 12],[60 120])


cd /BEEF01/smm/sm9601_Analysis/analysis03/
FileInterpCSDInterp([LoadVar('RemFiles');LoadVar('MazeFiles')],81,'NearAve',[1],0)

cd /BEEF01/smm/sm9601_Analysis/analysis03/
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_NearAveCSD1.csd',84,1250,0,[4 12],[60 120])
CalcRemSpectra02('allTimes',LoadVar('RemFiles'),'_NearAveCSD1.csd',84,1250,[4 12],[60 120])
cd /BEEF01/smm/sm9603_Analysis/analysis04/
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_NearAveCSD1.csd',84,1250,0,[4 12],[60 120])
CalcRemSpectra02('allTimes',LoadVar('RemFiles'),'_NearAveCSD1.csd',84,1250,[4 12],[60 120])

cd /BEEF02/smm/sm9608_Analysis/analysis02
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_NearAveCSD1.csd',84,1250,0,[4 12],[60 120])
CalcRemSpectra02('allTimes',LoadVar('RemFiles'),'_NearAveCSD1.csd',84,1250,[4 12],[60 120])
cd /BEEF02/smm/sm9614_Analysis/analysis02/
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_NearAveCSD1.csd',84,1250,0,[4 12],[60 120])
CalcRemSpectra02('allTimes',LoadVar('RemFiles'),'_NearAveCSD1.csd',84,1250,[4 12],[60 120])

cd /BEEF02/smm/sm9614_Analysis/analysis02/
CalcRemSpectra02('allTimes','sm9614_387','_NearAveCSD1.csd',84,1250,[4 12],[60 120])




cd /BEEF01/smm/sm9601_Analysis/analysis03
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_LinNearCSD121.csd',72,626,1,[6 12],[60 120])
cd /BEEF01/smm/sm9603_Analysis/analysis04
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_LinNearCSD121.csd',72,626,1,[6 12],[60 120])
cd /BEEF01/smm/sm9601_Analysis/analysis03
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'.eeg',81,626,1,[6 12],[60 120])
cd /BEEF01/smm/sm9603_Analysis/analysis04
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'.eeg',97,626,1,[6 12],[60 120])
cd /BEEF01/smm/sm9601_Analysis/analysis03
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_NearAveCSD1.csd',84,626,1,[6 12],[60 120])
cd /BEEF01/smm/sm9603_Analysis/analysis04
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_NearAveCSD1.csd',84,626,1,[6 12],[60 120])



cd /BEEF02/smm/sm9608_Analysis/analysis02
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_LinNearCSD121.csd',72,626,1,[6 12],[60 120])
cd /BEEF02/smm/sm9614_Analysis/analysis02
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_LinNearCSD121.csd',72,626,1,[6 12],[60 120])
cd /BEEF02/smm/sm9608_Analysis/analysis02
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'.eeg',97,626,1,[6 12],[60 120])
cd /BEEF02/smm/sm9614_Analysis/analysis02
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'.eeg',97,626,1,[6 12],[60 120])
cd /BEEF02/smm/sm9608_Analysis/analysis02
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_NearAveCSD1.csd',84,626,1,[6 12],[60 120])
cd /BEEF02/smm/sm9614_Analysis/analysis02
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_NearAveCSD1.csd',84,626,1,[6 12],[60 120])

