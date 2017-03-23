function regressStruct = CalcSpeedAccelPowRegress(taskType,minSpeed,winLength,NW,varargin)
%function regressStruct = CalcSpeedAccelPowRegress(taskType,mazeMeasStruct,channels,stdev)

%try
[channels, stdev] = DefaultArgs(varargin,{1:96,2.0});

inName = [taskType '_MazeMeas_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) 'NW' num2str(NW) '.mat'];
fprintf('Loading: %s\n',inName);
load(inName);

depVars = {'thetaPowPeak';'gammaPowIntg'};
indepVars = {'speed','accel'};
lags = fieldnames(eval(['mazeMeasStruct' '.' indepVars{1}]));
%junk = getfield(mazeMeasStruct,indepVars{1});
%lags = fieldnames(junk);
%[-2000 -1000 -500 -250 0 250 500 1000 2000];
regressStruct = [];

for i=1:length(indepVars)
    for j=1:length(lags)
        %if lags(j)<0
        %    lagName = ['n' num2str(abs(lags(j)))];
        %else
        %    lagName = ['p' num2str(abs(lags(j)))];
        %end
        xVar = getfield(mazeMeasStruct,indepVars{i},lags{j});
        xVar = xVar(:);
        notOutliers = find(xVar < mean(xVar)+stdev*std(xVar) & xVar > mean(xVar)-stdev*std(xVar));
        for k=1:length(channels)
            for l=1:length(depVars)

                yVar = getfield(mazeMeasStruct,depVars{l},{channels(k),1:length(xVar)});
                yVar = yVar(:);

                [b,bint,r,rint,stats] = regress(yVar(notOutliers), [ones(size(xVar(notOutliers))) xVar(notOutliers)], 0.01);

                regressStruct = setfield(regressStruct,indepVars{i},lags{j},depVars{l},'b',{channels(k),1:2},b);
                %regressStruct = setfield(regressStruct,indepVars{i},lags{j},depVars{l},'bint',{channels(k),1:2,1:2},bint);
                %regressStruct = setfield(regressStruct,indepVars{i},lags{j},depVars{l},'r',{channels(k),1:length(notOutliers)},r);
                %regressStruct = setfield(regressStruct,indepVars{i},lags{j},depVars{l},'rint',{channels(k),1:length(notOutliers),1:2},rint);
                regressStruct = setfield(regressStruct,indepVars{i},lags{j},depVars{l},'stats',{channels(k),1:3},stats);

                %regressStruct = setfield(regressStruct,indepVars{i},lagName,depVars{l},['chan' num2str(channels(k))],'b',b);
                %regressStruct = setfield(regressStruct,indepVars{i},lagName,['chan' num2str(channels(k))],depVars{l},'bint',bint);
                %regressStruct = setfield(regressStruct,indepVars{i},lagName,['chan' num2str(channels(k))],depVars{l},'r',r);
                %regressStruct = setfield(regressStruct,indepVars{i},lagName,['chan' num2str(channels(k))],depVars{l},'rint',rint);
                %regressStruct = setfield(regressStruct,indepVars{i},lagName,depVars{l},['chan' num2str(channels(k))],'stats',stats);


            end
        end
    end
end

outName = [taskType '_RegressPowSpeedAccel_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) 'NW' num2str(NW) '.mat'];
fprintf('Saving: %s\n',outName)

if isfield(mazeMeasStruct,'times');
    regressStruct = setfield(regressStruct,'times',getfield(mazeMeasStruct,'times'));
end
if isfield(mazeMeasStruct,'info');
    regressStruct = setfield(regressStruct,'info',getfield(mazeMeasStruct,'info'));
end

regressStruct = setfield(regressStruct,'info','channels',channels);
regressStruct = setfield(regressStruct,'info','fileName',outName);


save(outName, 'regressStruct');

return
%catch
keyboard
%end