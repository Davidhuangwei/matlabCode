
!mkdir control
!mkdir drug
!cp CSC1_rippleM1.whl CSC1_rippleM1_1250Hz.whl
!cp CSC1_rippleM2.whl CSC1_rippleM2_1250Hz.whl
!mv CSC1_rippleM1_1250Hz* control
!mv CSC1_rippleM2_1250Hz* drug


skipWhl = 2500;
whl = load('control/CSC1_rippleM1_1250Hz.whl');
whl(1:1+skipWhl,1) = -1;
whl(1:1+skipWhl,2) = -1;
whl(end-skipWhl:end,1) = -1;
whl(end-skipWhl:end,2) = -1;
msave('control/CSC1_rippleM1_1250Hz.whl',whl)
skipWhl = 200;
whl = load('drug/CSC1_rippleM2_1250Hz.whl');
whl(1:1+skipWhl,1) = -1;
whl(1:1+skipWhl,2) = -1;
whl(end-skipWhl:end,1) = -1;
whl(end-skipWhl:end,2) = -1;
msave('drug/CSC1_rippleM2_1250Hz.whl',whl)

speedThresh = 1;
cntWhl = load('control/CSC1_rippleM1_1250Hz.whl');
drugWhl = load('drug/CSC1_rippleM2_1250Hz.whl');
figure
whlSamp =  423/121.5;
[speed accel] = MazeSpeedAccel(cntWhl,whlSamp);
plot(cntWhl(speed>speedThresh,1),cntWhl(speed>speedThresh,2),'k.')  
[speed accel] = MazeSpeedAccel(drugWhl,whlSamp);
hold on  
%outliers = speed>100 | abs(accel)>150;
%plot(drugWhl(~outliers,1),drugWhl(~outliers,2),'g.')
plot(drugWhl(speed>speedThresh,1),drugWhl(speed>speedThresh,2),'g.')

%clf
%plot(speed(~outliers),'.')
%hold on;
%plot(accel(~outliers),'r.')


cd control
CalcPowSpeedAccel('CSC1_rippleM1_1250Hz',1,1,1250,1250,0,1.5)
cd ..
cd drug
CalcPowSpeedAccel('CSC1_rippleM2_1250Hz',1,1,1250,1250,0,1.5)
cd ..
alterFiles = 'CSC1_rippleM1_1250Hz';
save('control/Files.mat','alterFiles');
alterFiles = 'CSC1_rippleM2_1250Hz';
save('drug/Files.mat','alterFiles');

controlDir = [pwd '/control'];
drugDir = [pwd '/drug'];
close all
PlotPowSpeedOverlay2(controlDir,drugDir,'Files',speedThresh,1250,1.5,6,12)
SMPrint([1:4],1)

SpeedPowAncova(controlDir,drugDir,'Files',1,speedThresh,1250,1.5,6,12)

