ssh basket
addpath  /u12/antsiro/matlab/General/
addpath /u12/antsiro/matlab/draft
addpath /u12/smm/matlab/Ant

fileBase = 'sm9601_120-140'
fileBase = 'sm9603_228-297'
Spikes2Spikes(fileBase)
NeuronQuality(fileBase)
ClusterLocation(fileBase,[],1)
NeuroClass(fileBase)
spikeDir = '/BEEF2/smm/SpikeData/sm9601/2-16-04/sm9601_120-140/';
spikeDir = '/BEEF2/smm/SpikeData/sm9603/3-21-04/sm9603_228-297/';
AssignCellLayer01(spikeDir,fileBase)

%files to copy
fileExts = {...
'.clu.*'...
'.cellLayer'...
'.cluloc'...
'.NeuronQuality.mat'...
'.s2s'...
'.type'...
'.statelabels.mat'...
'.nclass'...
'.ei'...
'.AnatomicalProfile.mat'...
}
temp = dir('sm9601m*')
for k=1:length(temp)
    if temp(k).isdir
        for j=1:length(fileExts)
            evalText = ['!cp ' fileBase '/' fileBase fileExts{j} ' ' temp(k).name '/' temp(k).name fileExts{j}];
            EvalPrint(evalText,0)
        end
    end
end


temp = dir('merge*')
for j=1:length(temp)
    evalText = ['!mv ' temp(j).name ' ' fileBase temp(j).name(6:end)];
    EvalPrint(evalText,0);
end

cwd = pwd;
spikeBaseDir = '/BEEF2/smm/SpikeData/sm9601/2-16-04/'
spikeBaseDir = '/BEEF2/smm/SpikeData/sm9603/3-21-04/'
spikeBaseDir = '/BEEF2/smm/SpikeData/sm9608/7-17-04/'
spikeBaseDir = '/BEEF2/smm/SpikeData/sm9614/4-17-05/'

spikeBaseDir = '../../processed/'

for j=1:length(fileBaseCell)
    cd(fileBaseCell{j})
    evalText = ['!ln -fs ' spikeBaseDir fileBaseCell{j} '/* .'];
    EvalPrint(evalText,0)
    cd(cwd)
end

for j=1:length(fileBaseCell)
    cd(fileBaseCell{j})
    evalText = ['rm ' fileBaseCell{j} '/];
    EvalPrint(evalText,1)    
    evalText = ['!ln -s ' spikeBaseDir fileBaseCell{j} '/* .'];
    EvalPrint(evalText,1)
    cd(cwd)
end
