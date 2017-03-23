function plotMazeRegionSpectrum(tasktype,fileBaseMat,fileext,fileNameFormat,chanMat,badChannels,NW,includePortsBool,percentageBool,samescale,dbscale,removeexp)

if ~exist('samescale','var') | isempty(samescale)
    samescale = 1;
end
if ~exist('badChannels','var') | isempty(badChannels)
   badChannels  = 0;
end
if ~exist('dbscale','var') | isempty(dbscale)
    dbscale = 0;
end
if ~exist('removeexp','var') | isempty(removeexp)
    removeexp = 0;
end
if ~exist('includePortsBool','var') | isempty(includePortsBool)
    includePortsBool = 0;
end
if ~exist('percentageBool','var') | isempty(percentageBool)
    percentageBool = 0;
end

if fileNameFormat == 2,
    fileName = [tasktype '_' fileBaseMat(1,:) '-' fileBaseMat(end,8:10) ...
        fileext '_PowerSpectrumsWindowNW' num2str(NW) '.mat'];
end

if exist(fileName,'file')
    load(fileName)
else
    YOU_NEED_TO_RUN_calcMazeRegionSpectrum
end

if percentageBool,
    if ~includePortsBool,
        cpY = cpY./allNoPortsY;
        caY = caY./allNoPortsY;
        rewY = rewY./allNoPortsY;
        retY = retY./allNoPortsY;
        xpY = xpY./allNoPortsY;
        wpY = wpY./allNoPortsY;
        dpY = dpY./allNoPortsY;
    else
        cpY = cpY./allY;
        caY = caY./allY;
        rewY = rewY./allY;
        retY = retY./allY;
        xpY = xpY./allY;
        wpY = wpY./allY;
        dpY = dpY./allY;
    end
end


figure(1);
clf;
figure(2);
clf;
lineWidth = 0.01;

color = [0 1 0];
plotchanspectrum(F,cpY,chanMat,badChannels,samescale,dbscale,removeexp,color)

color = [.5 .5 .5];
plotchanspectrum(F,rewY,chanMat,badChannels,samescale,dbscale,removeexp,color)

color = [0 0 1];
plotchanspectrum(F,retY,chanMat,badChannels,samescale,dbscale,removeexp,color)

color = [1 0 0];
plotchanspectrum(F,caY,chanMat,badChannels,samescale,dbscale,removeexp,color)

if includePortsBool
    color = [1 0 1]; %pink
    plotchanspectrum(F,xpY,chanMat,badChannels,samescale,dbscale,removeexp,color)

    color = [0.85 0.85 0]; %gold
    plotchanspectrum(F,wpY,chanMat,badChannels,samescale,dbscale,removeexp,color)

    color = [0 1 1]; %cyan
    plotchanspectrum(F,dpY,chanMat,badChannels,samescale,dbscale,removeexp,color)
end

    color = [0.5 1 0.5]; %light orange
    color = [0.5 0.5 1]; %light purple

    color = [1 0.5 0.5]; %light green
    color = [0.5 1 1]; %cyan
    color = [1 0.5 1]; %pink
    color = [1 1 0.5]; %yellow
    color = [0.75 0.75 0]; %gold

return
