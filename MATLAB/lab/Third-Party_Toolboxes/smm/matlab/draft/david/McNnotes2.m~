speedThresh = 1;
freqRange = [5 11];

eegName = 'theta';
cscNum = '1';

eegName = 'ripple';
cscNum = '1';


eval(['!mkdir control'])
eval(['!mkdir drug'])
eval(['!cp CSC' cscNum '_' eegName 'M1.whl CSC' cscNum '_' eegName 'M1_1250Hz.whl'])
eval(['!cp CSC' cscNum '_' eegName 'M2.whl CSC' cscNum '_' eegName 'M2_1250Hz.whl'])
eval(['!mv CSC' cscNum '_' eegName 'M1_1250Hz* control'])
eval(['!mv CSC' cscNum '_' eegName 'M2_1250Hz* drug'])

cntWhl = load(['control/CSC' cscNum '_' eegName 'M1_1250Hz.whl']);
drugWhl = load(['drug/CSC' cscNum '_' eegName 'M2_1250Hz.whl']);
figure
whlSamp =  423/121.5;
[speed accel] = MazeSpeedAccel(cntWhl,whlSamp);
plot(cntWhl(speed>speedThresh,1),cntWhl(speed>speedThresh,2),'k.')  
[speed accel] = MazeSpeedAccel(drugWhl,whlSamp);
hold on  
%outliers = speed>100 | abs(accel)>150;
%plot(drugWhl(~outliers,1),drugWhl(~outliers,2),'g.'])
plot(drugWhl(speed>speedThresh,1),drugWhl(speed>speedThresh,2),'g.')


skipWhl = 2000;
whl = load(['control/CSC' cscNum '_' eegName 'M1_1250Hz.whl']);
whl(1:1+skipWhl,1) = -1;
whl(1:1+skipWhl,2) = -1;
whl(end-skipWhl:end,1) = -1;
whl(end-skipWhl:end,2) = -1;
msave(['control/CSC' cscNum '_' eegName 'M1_1250Hz.whl'],whl)
skipWhl = 500;
whl = load(['drug/CSC' cscNum '_' eegName 'M2_1250Hz.whl']);
whl(1:1+skipWhl,1) = -1;
whl(1:1+skipWhl,2) = -1;
whl(end-skipWhl:end,1) = -1;
whl(end-skipWhl:end,2) = -1;
msave(['drug/CSC' cscNum '_' eegName 'M2_1250Hz.whl'],whl)


%clf
%plot(speed(~outliers),'.'])
%hold on;
%plot(accel(~outliers),'r.'])


cd control
CalcPowSpeedAccel(['CSC' cscNum '_' eegName 'M1_1250Hz'],1,1,1250,1250,0,1.5)
cd ..
cd drug
CalcPowSpeedAccel(['CSC' cscNum '_' eegName 'M2_1250Hz'],1,1,1250,1250,0,1.5)
cd ..
alterFiles = ['CSC' cscNum '_' eegName 'M1_1250Hz'];
save('control/Files.mat','alterFiles');
alterFiles = ['CSC' cscNum '_' eegName 'M2_1250Hz'];
save('drug/Files.mat','alterFiles');

controlDir = [pwd '/control'];
drugDir = [pwd '/drug'];
close all
PlotPowSpeedOverlay2(controlDir,drugDir,'Files',speedThresh,1250,1.5,freqRange(1),freqRange(2))


SMPrint([1:4],1)

SpeedPowAncova(controlDir,drugDir,'Files',1,speedThresh,1250,1.5,freqRange(1),freqRange(2))

