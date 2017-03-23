datapath='/gpfs01/sirota/bach/homes/weiwei/workspace/connectomics/';
addpath(genpath(datapath))
cd([datapath, 'SampleCode/data'])
data=dlmread('fluorescence_mocktrain.txt');
figure
for k=1:10
    PlotTraces(data(((k-1)*1000+1):(k*10000),:)');
    pause
end

% let's say, if I want to use the GTE
