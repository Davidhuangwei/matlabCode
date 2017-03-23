
analDirs = {...
    '/BEEF01/smm/sm9601_Analysis/2-13-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-14-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-15-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-16-04/analysis/',...
    '/BEEF01/smm/sm9603_Analysis/3-20-04/analysis/',...
    '/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-15-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-16-04/analysis/',...
    '/BEEF02/smm/sm9614_Analysis/4-16-05/analysis/',...
    '/BEEF02/smm/sm9614_Analysis/4-17-05/analysis/',...
    }

files = cat(1,LoadVar('FileInfo/MazeFiles'),LoadVar('FileInfo/RemFiles'))
files = {...
    'sm9601m3_084_s1_139',...
    'sm9601m3_101_s1_159',...
    'sm9601m3_124_s1_187',...
    'sm9601m3_138_s1_204',...
    'sm9601m3_077_s1_132',...
    }
fileExts = {...
    '.eeg',81;...
    }

for j=1:length(analDirs)
    cd(analDirs{j})
    mazeFiles = intersect(files,LoadVar('FileInfo/MazeFiles'))
    remFiles = intersect(files,LoadVar('FileInfo/RemFiles'))
    for k=1:size(fileExts,1)
        CalcRunningSpectra11('noExp',mazeFiles,fileExts{k,1},fileExts{k,2},1250,0,[4 12],[40 100])
        CalcRemSpectra03('allTimes',remFiles,fileExts{k,1},fileExts{k,2},1250,[4 12],[40 100])
    end
end

%%% processes %%%%%%%%%
Dir Missing: /BEEF01/smm/sm9601_Analysis/2-16-04/analysis/sm9601m3_128_s1_192/CalcRunningSpectra11_noExp_MinSpeed0Win1250.eeg
running scan complete
Dir Missing: /BEEF02/smm/sm9608_Analysis/7-16-04/analysis/sm9608_319/CalcRemSpectra03_allTimes_Win1250.eeg
Dir Missing: /BEEF02/smm/sm9614_Analysis/4-16-05/analysis/sm9614_368/CalcRemSpectra03_allTimes_Win1250.eeg
Dir Missing: /BEEF02/smm/sm9614_Analysis/4-17-05/analysis/sm9614_387/CalcRemSpectra03_allTimes_Win1250_LinNearCSD121.csd
Dir Missing: /BEEF01/smm/sm9601_Analysis/2-15-04/analysis/sm9601m3_101_s1_159/CalcRemSpectra03_allTimes_Win1250_LinNearCSD121.csd
BADNCHAN: /BEEF01/smm/sm9601_Analysis/2-15-04/analysis/sm9601m3_107_s1_165/CalcRunningSpectra11_noExp_MinSpeed0Win1250.eeg/rawTrace.mat == 97
BADNCHAN: /BEEF01/smm/sm9601_Analysis/2-15-04/analysis/sm9601m3_109_s1_168/CalcRunningSpectra11_noExp_MinSpeed0Win1250.eeg/rawTrace.mat == 97
BADNCHAN: /BEEF01/smm/sm9601_Analysis/2-16-04/analysis/sm9601m3_130_s1_194/CalcRunningSpectra11_noExp_MinSpeed0Win1250.eeg/rawTrace.mat == 97
BADNCHAN: /BEEF01/smm/sm9601_Analysis/2-16-04/analysis/sm9601m3_132_s1_197/CalcRunningSpectra11_noExp_MinSpeed0Win1250.eeg/rawTrace.mat == 97

222 /BEEF01/smm/sm9601_Analysis/2-15-04/analysis/sm9601m3_107_s1_165/CalcRunningSpectra11_noExp_MinSpeed0Win1250_LinNearCSD121.csd/rawTrace.mat
177 /BEEF01/smm/sm9601_Analysis/2-15-04/analysis/sm9601m3_109_s1_168/CalcRunningSpectra11_noExp_MinSpeed0Win1250_LinNearCSD121.csd/rawTrace.mat
224 /BEEF01/smm/sm9601_Analysis/2-16-04/analysis/sm9601m3_128_s1_192/CalcRunningSpectra11_noExp_MinSpeed0Win1250_LinNearCSD121.csd/rawTrace.mat
342 /BEEF01/smm/sm9601_Analysis/2-16-04/analysis/sm9601m3_130_s1_194/CalcRunningSpectra11_noExp_MinSpeed0Win1250_LinNearCSD121.csd/rawTrace.mat
226 /BEEF01/smm/sm9601_Analysis/2-16-04/analysis/sm9601m3_132_s1_197/CalcRunningSpectra11_noExp_MinSpeed0Win1250_LinNearCSD121.csd/rawTrace.mat
161 /BEEF02/smm/sm9608_Analysis/7-16-04/analysis/sm9608_319/CalcRemSpectra03_allTimes_Win1250_LinNearCSD121.csd/rawTrace.mat
182 /BEEF02/smm/sm9614_Analysis/4-16-05/analysis/sm9614_368/CalcRemSpectra03_allTimes_Win1250_LinNearCSD121.csd/rawTrace.mat
143 /BEEF01/smm/sm9601_Analysis/2-15-04/analysis/sm9601m3_101_s1_159/CalcRemSpectra03_allTimes_Win1250.eeg/rawTrace.mat
remaining: '.eeg'
files = {...
    'sm9601m3_107_s1_165',...
    'sm9601m3_109_s1_168',...
    'sm9601m3_128_s1_192',...
    'sm9601m3_130_s1_194',...
    'sm9601m3_132_s1_197',...
    }
remaining: '_LinNearCSD121.csd'
files = {...
    'sm9614_387',...
    }

basket1:  '.eeg' 
files = {...
    'sm9601m3_070_s1_125',...
    'sm9601m3_084_s1_139',...
    'sm9601m3_087_s1_142',...
    'sm9601m3_088_s1_143',...
    'sm9601m3_104_s1_162',...
    }

basket2: '_LinNearCSD121.csd'
    'sm9608_319',...
    'sm9614_368',...
'sm9601m3_084_s1_139' 'sm9601m3_077_s1_132' 'sm9601m3_124_s1_187'    'sm9601m3_138_s1_204'

urethane: '.eeg'
files = {...
    'sm9601m3_101_s1_159',...
    'sm9601m3_106_s1_164',...
    'sm9601m3_108_s1_167',...
    'sm9601m3_111_s1_170',...
    'sm9601m3_129_s1_193',...
    }

ravana1: '.eeg'
'sm9601m3_084_s1_139'    'sm9601m3_101_s1_159'    'sm9601m3_124_s1_187'    'sm9601m3_138_s1_204'

ravana2: '.eeg'
'sm9614_377'    'sm9614_387'


analDirs = {...
    '/BEEF01/smm/sm9601_Analysis/2-13-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-14-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-15-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-16-04/analysis/',...
}
for j=1:length(analDirs)
    cd(analDirs{j})
    CalcRunningSpectra11('noExp',LoadVar('FileInfo/MazeFiles'),'.eeg',81,1250,0,[4 12],[40 100])
    CalcRunningSpectra11('noExp',LoadVar('FileInfo/MazeFiles'),'_LinNearCSD121.csd',72,1250,0,[4 12],[40 100])
    CalcRemSpectra03('allTimes',LoadVar('FileInfo/RemFiles'),'.eeg',81,1250,[4 12],[40 100])
    CalcRemSpectra03('allTimes',LoadVar('FileInfo/RemFiles'),'_LinNearCSD121.csd',72,1250,[4 12],[40 100])
end




cd /BEEF02/smm/sm9614_Analysis/analysis02/
CalcRunningSpectra11('noExp',LoadVar('FileInfo/MazeFiles'),'.eeg',97,626,1,[4 12],[60 120])


CalcRunningSpectra11('noExp',LoadVar('FileInfo/MazeFiles'),'.eeg',97,1250,0,[4 12],[60 120])
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
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'.eeg',81,626,1,[6 12],[60 120])
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_NearAveCSD1.csd',84,626,1,[6 12],[60 120])
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_LinNearCSD121.csd',72,626,1,[6 12],[60 120])

cd /BEEF01/smm/sm9603_Analysis/analysis04/
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'.eeg',97,626,1,[6 12],[60 120])
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_NearAveCSD1.csd',84,626,1,[6 12],[60 120])
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_LinNearCSD121.csd',72,626,1,[6 12],[60 120])

cd /BEEF02/smm/sm9608_Analysis/analysis02
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'.eeg',97,626,1,[6 12],[60 120])
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_NearAveCSD1.csd',84,626,1,[6 12],[60 120])
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_LinNearCSD121.csd',72,626,1,[6 12],[60 120])

cd /BEEF02/smm/sm9614_Analysis/analysis02/
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'.eeg',97,626,1,[6 12],[60 120])
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_NearAveCSD1.csd',84,626,1,[6 12],[60 120])
CalcRunningSpectra9('noExp',LoadVar('MazeFiles'),'_LinNearCSD121.csd',72,626,1,[6 12],[60 120])

