CalcFileSpectrograms(alterFiles,'.eeg',97,626,1250,626*2,626/2,1.5,'spectrograms/');
CalcFileSpectrograms(forceFiles,'.eeg',97,626,1250,626*2,626/2,1.5,'spectrograms/');

CalcMazeSpectrogram('alter_correct',alterFiles,'.eeg',2,1:96,626,626/2,1.5,0,1);
CalcMazeSpectrogram('force_correct',forceFiles,'.eeg',2,1:96,626,626/2,1.5,0,1);

CalcRunningSpectra4('alter+force_noExp',cat(1,alterFiles,forceFiles),'.eeg',97,626,0,1,2,[5 11],4,[65 100],[1 1 1 1 1 1 1 1 1 1 1 1 0]);
CalcRunningSpectra4('alter+force_noExp',cat(1,alterFiles,forceFiles),'.eeg',97,626,0,0,2,[5 11],4,[65 100],[1 1 1 1 1 1 1 1 1 1 1 1 0]);

CalcPosPowSum2('alter_correct',alterFiles,'.eeg',2,1:96,626,626/2,1.5,[5 11],1,1);
CalcPosPowSum2('alter_correct',alterFiles,'.eeg',2,1:96,626,626/2,1.5,[65 100],0,1);
CalcPosPowSum2('force_correct',forceFiles,'.eeg',2,1:96,626,626/2,1.5,[5 11],1,1);
CalcPosPowSum2('force_correct',forceFiles,'.eeg',2,1:96,626,626/2,1.5,[65 100],0,1);



CalcFileSpectrograms(alterFiles,'.eeg',97,312,1250,312*2,312/2,1,'spectrograms/');
CalcFileSpectrograms(forceFiles,'.eeg',97,312,1250,312*2,312/2,1,'spectrograms/');

CalcMazeSpectrogram('alter_correct',alterFiles,'.eeg',2,1:96,312,312/2,1,0,1);
CalcMazeSpectrogram('force_correct',forceFiles,'.eeg',2,1:96,312,312/2,1,0,1);

CalcRunningSpectra3('alter+force_noExp',cat(1,alterFiles,forceFiles),'.eeg',97,312,0,1,1,[5 11],2.5,[65 100],[1 1 1 1 1 1 1 1 1 1 1 1 0]);
CalcRunningSpectra3('alter+force_noExp',cat(1,alterFiles,forceFiles),'.eeg',97,312,0,0,1,[5 11],2.5,[65 100],[1 1 1 1 1 1 1 1 1 1 1 1 0]);

CalcPosPowSum2('alter_correct',alterFiles,'.eeg',2,1:96,312,312/2,1,[5 11],1,1);
CalcPosPowSum2('alter_correct',alterFiles,'.eeg',2,1:96,312,312/2,1,[65 100],0,1);

CalcPosPowSum2('force_correct',forceFiles,'.eeg',2,1:96,312,312/2,1,[5 11],1,1);
CalcPosPowSum2('force_correct',forceFiles,'.eeg',2,1:96,312,312/2,1,[65 100],0,1);


CalcSpatialComodulation7('alter_correct',alterFiles,'.eeg',97,1:96,626,626/2,1.5,[5,11],[65,100],20,20)
CalcSpatialComodulation7('circle_correct',circleFiles,'.eeg',97,1:96,626,626/2,1.5,[5,11],[65,100],20,20)

CalcSpatialComodulation7('alter_correct',alterFiles,'.eeg',97,1:96,312,312/2,1.5,[5,11],[65,100],20,20)
CalcSpatialComodulation7('circle_correct',circleFiles,'.eeg',97,1:96,312,312/2,1,[5,11],[65,100],20,20)

%tonight
CalcRunningSpectra4('alter+Zmaze_good',cat(1,alterFiles,zMazeFiles),'.eeg',97,626,0,0,2,[5 11],4,[65 100],[1 1 1 1 0 0 0 0 0 0 0 0 0]);
CalcRunningSpectra4('alter+Zmaze_good',cat(1,alterFiles,zMazeFiles),'.eeg',97,312,0,0,1,[5 11],2.5,[65 100],[1 1 1 1 0 0 0 0 0 0 0 0 0]);

CalcRunningSpectra4('alter+circle_good',cat(1,alterFiles,circleFiles),'.eeg',81,626,0,0,2,[5 11],4,[65 100],[1 1 1 1 0 0 0 0 0 0 0 0 0]);
CalcRunningSpectra4('alter+circle_good',cat(1,alterFiles,circleFiles),'.eeg',81,312,0,0,1,[5 11],2.5,[65 100],[1 1 1 1 0 0 0 0 0 0 0 0 0]);

binInfo = [5,0;10,4;20,20;40,30];

binInfo = [5,0;10,4];
spectInfo = [626,626/2,1.5;312,312/2,1];
cd /BEEF4/smm/sm9608_analysis/analysis01/
load AlterFiles
load ForceFiles
for i=1:size(binInfo,1)
    for j=1:size(spectInfo,1)
        CalcSpatialComodulation7('alter_correct',alterFiles,'.eeg',97,1:96,spectInfo(j,1),spectInfo(j,2),spectInfo(j,3),[5,11],[65,100],binInfo(i,1),binInfo(i,2))
        CalcSpatialComodulation7('force_correct',forceFiles,'.eeg',97,1:96,spectInfo(j,1),spectInfo(j,2),spectInfo(j,3),[5,11],[65,100],binInfo(i,1),binInfo(i,2))
    end
end

cd /BEEF3/smm/sm9614_Analysis/analysis01
load AlterFiles
load ZMazeFiles
for i=1:size(binInfo,1)
    for j=1:size(spectInfo,1)
        CalcSpatialComodulation7('alter_correct',alterFiles,'.eeg',97,1:96,spectInfo(j,1),spectInfo(j,2),spectInfo(j,3),[5,11],[65,100],binInfo(i,1),binInfo(i,2))
        CalcSpatialComodulation7('Zmaze_LR',zMazeFiles,'.eeg',97,1:96,spectInfo(j,1),spectInfo(j,2),spectInfo(j,3),[5,11],[65,100],binInfo(i,1),binInfo(i,2),[1 0 0 0 0 0 0 0 0 0 0 0 0])
        CalcSpatialComodulation7('Zmaze_RL',zMazeFiles,'.eeg',97,1:96,spectInfo(j,1),spectInfo(j,2),spectInfo(j,3),[5,11],[65,100],binInfo(i,1),binInfo(i,2),[0 0 1 0 0 0 0 0 0 0 0 0 0])
    end
end


binInfo = [5,0;10,4];
spectInfo = [626,626/2,1.5;312,312/2,1];
cd /BEEF2/smm/sm9603_Analysis/analysis03
load AlterFiles
load CircleFiles
for i=1:size(binInfo,1)
    for j=1:size(spectInfo,1)
        CalcSpatialComodulation7('alter_correct',alterFiles,'.eeg',97,1:96,spectInfo(j,1),spectInfo(j,2),spectInfo(j,3),[5,11],[65,100],binInfo(i,1),binInfo(i,2))
        CalcSpatialComodulation7('circle_LR',circleFiles,'.eeg',97,1:96,spectInfo(j,1),spectInfo(j,2),spectInfo(j,3),[5,11],[65,100],binInfo(i,1),binInfo(i,2),[1 0 0 0 0 0 0 0 0 0 0 0 0])
        CalcSpatialComodulation7('circle_RL',circleFiles,'.eeg',97,1:96,spectInfo(j,1),spectInfo(j,2),spectInfo(j,3),[5,11],[65,100],binInfo(i,1),binInfo(i,2),[0 0 1 0 0 0 0 0 0 0 0 0 0])
    end
end

cd /BEEF2/smm/sm9601_Analysis/analysis02
spectInfo = [626,626/2,2;312,312/2,1];
load AlterFiles
load CircleFiles
for i=1:size(binInfo,1)
    for j=1:size(spectInfo,1)
        CalcSpatialComodulation7('alter_correct',alterFiles,'.eeg',81,1:80,spectInfo(j,1),spectInfo(j,2),spectInfo(j,3),[5,11],[65,100],binInfo(i,1),binInfo(i,2))
        CalcSpatialComodulation7('circle_LR',circleFiles,'.eeg',81,1:80,spectInfo(j,1),spectInfo(j,2),spectInfo(j,3),[5,11],[65,100],binInfo(i,1),binInfo(i,2),[1 0 0 0 0 0 0 0 0 0 0 0 0])
        CalcSpatialComodulation7('circle_RL',circleFiles,'.eeg',81,1:80,spectInfo(j,1),spectInfo(j,2),spectInfo(j,3),[5,11],[65,100],binInfo(i,1),binInfo(i,2),[0 0 1 0 0 0 0 0 0 0 0 0 0])
    end
end

