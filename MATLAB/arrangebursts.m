clear all
close all
sjn='/gpfs01/sirota/home/gerrit/data/';
FileBase='g09-20120330';
cd([sjn, FileBase])
load([FileBase, '.par.mat'])
load([FileBase, '.sts.RUN3'])
Period=g09_20120330_sts;
nP=length(Period);
clear g09_20120330_sts
load([FileBase, '-LayerLabels.mat'])
load('g09-20120330.spec[14-250].lfpinterp.11.mat','t')
SBsets=dir('g09-20120330.SelectBursts4.[14-250].lfpinterp.RUN3.*');
FS=Par.lfpSampleRate;
nsb=length(SBsets);
% mec3=cell2mat(Layers.Mec3);
% mec2=cell2mat(Layers.Mec2);
% mec1=cell2mat(Layers.Mec1);
% MECS1=load('g09-20120330.SelectBursts4.[14-250].lfpinterp.RUN3.1-16.mat');
% MECS2=load('g09-20120330.SelectBursts4.[14-250].lfpinterp.RUN3.17-32.mat');
AllBursts.BurstFreq=[];
AllBursts.BurstChan=[];
AllBursts.BurstTime=[];
for k=1:nsb
load(SBsets(k).name, 'BurstFreq','BurstChan','BurstTime')
AllBursts.BurstFreq=[AllBursts.BurstFreq;BurstFreq];
AllBursts.BurstChan=[AllBursts.BurstChan;BurstChan];
AllBursts.BurstTime=[AllBursts.BurstTime;BurstTime];
end
AllBursts.BurstTime=AllBursts.BurstTime*FS;
Bursts=AllBursts.BurstTime;
myBursts=false(size(Bursts));%|(MB.BurstChan>24 & MB.BurstChan<28) 
n=0;
for k=1:nP
    kk=find(Bursts<(Period(k,2)-200) & Bursts>(Period(k,1)+200));
    myBursts(kk)=true;
    Bursts(kk)=Bursts(kk)-Period(k,1)+n;
    n=n+Period(k,2)-Period(k,1)+1;
end
AllBursts.BurstTime=floor(Bursts(myBursts));
AllBursts.BurstFreq=AllBursts.BurstFreq(myBursts);
AllBursts.BurstChan=AllBursts.BurstChan(myBursts);
cd ~/data/g09_20120330/
save g09_20120330.RUN3.Burst4Info.[14-250].all.mat Par SBsets AllBursts Period Layers