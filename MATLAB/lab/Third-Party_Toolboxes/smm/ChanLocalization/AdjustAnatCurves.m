function AdjustAnatCurves()

chanInfoDir = 'ChanInfo/';
eegChanMat = LoadVar([chanInfoDir 'ChanMat.eeg.mat']);
while 1
    anatCurves = LoadVar([chanInfoDir 'AnatCurves.mat']);
    offset = load([chanInfoDir 'Offset.eeg.txt']);
    rehash
    PlotChanLocTools04(0)
    change = 0;
    while ~change
    in = input(['What do you want to do?\n',...
        'adjust AnatCurves X offset [xo]\n',...
        'adjust AnatCurves Y offset [yo]\n',...
        'adjust AnatCurves X Scaling [xs]\n',...
        'adjust AnatCurves Y Scaling [ys]\n'], 's');
%         'adjust X Offset [xo]\n',...
%         'adjust Y Offset [yo]\n',...
        switch in
%             case 'xo'
%                 newXOffset = [];
%                 while isempty(newXOffset)
%                     newXOffset = input('enter X offset adjustment: ');
%                 end
%                 offset(2)  = offset(2) + newXOffset;
%                 change = 1;
%             case 'yo'
%                 newYOffset = [];
%                 while isempty(newYOffset)
%                     newYOffset = input('enter Y offset adjustment: ');
%                 end
%                 offset(1)  = offset(1) + newYOffset;
%                 change = 1;
            case 'xo'
                newXoffset = [];
                while isempty(newXoffset)
                    newXoffset = input('Enter AnatCurves X offset: ');
                end
                for m=1:size(anatCurves,1)
                    anatCurves{m,1} = (anatCurves{m,1}*size(eegChanMat,2)-newXoffset)...
                        /size(eegChanMat,2);
                end
            case 'yo'
                newYoffset = [];
                while isempty(newYoffset)
                    newYoffset = input('Enter AnatCurves Y offset: ');
                end
                for m=1:size(anatCurves,1)
                    anatCurves{m,2} = (anatCurves{m,2}*size(eegChanMat,1)-newYoffset)...
                        /size(eegChanMat,1);
                end
            case 'xs'
                fprintf('Click on X scaling center point\n')
                scaleCenter = abs([ginput(1)]);
                scaleFactor = [];
                while isempty(scaleFactor)
                    scaleFactor = input('Enter AnatCurves X scaling factor: ');
                end
                for m=1:size(anatCurves,1)
                    anatCurves{m,1} = ((anatCurves{m,1}*size(eegChanMat,2)-scaleCenter(1))...
                        *scaleFactor+scaleCenter(1))/size(eegChanMat,2);
                end
            case 'ys'
                fprintf('Click on Y scaling center point\n')
                scaleCenter= abs([ginput(1)]);
                scaleFactor = [];
                while isempty(scaleFactor)
                    scaleFactor = input('EnterAnatCurves  Y scaling factor: ');
                end
                for m=1:size(anatCurves,1)
                anatCurves{m,2} = ((anatCurves{m,2}*size(eegChanMat,1)-scaleCenter(2))...
                    *scaleFactor+scaleCenter(2))/size(eegChanMat,1);
                end
            otherwise
                quitVar = input('Do you want to quit? y/[n]: ','s');
                if strcmp(quitVar,'y')
                    figNums = input('Enter fig nums to report (e.g. [1 2 4]): ');
                    if ~isempty(figNums)
                        ReportFigSM(figNums,['NewFigs/ChannelLocalization/'],repmat({date},size(figNums)),[10 8],repmat({{'GCFNAME'}},size(figNums)));
                    end
                    return
                end
        end
        saveVar = input('do yo want to save? [y]/n: ','s');
        if isempty(saveVar) | strcmp(saveVar,'y')
            fNum = 1;
            if ~exist([chanInfoDir 'Old/'],'dir')
                mkdir([chanInfoDir 'Old/'])
            end
            while exist([chanInfoDir 'Old/AnatCurves.mat.old.' num2str(fNum)],'file')...
                    | exist([chanInfoDir 'Old/Offset.eeg.txt.old.' num2str(fNum)],'file')
                fNum = fNum+1;
            end
            eval(['!cp ' chanInfoDir 'AnatCurves.mat ' chanInfoDir 'Old/AnatCurves.mat.old.' num2str(fNum)]);
            eval(['!cp ' chanInfoDir 'Offset.eeg.txt ' chanInfoDir 'Old/Offset.eeg.txt.old.' num2str(fNum)]);
            eval(['!cp ' chanInfoDir 'Offset.dat.txt ' chanInfoDir 'Old/Offset.dat.txt.old.' num2str(fNum)]);
            eval(['!cp ' chanInfoDir 'Offset_LinNear.eeg.txt ' chanInfoDir 'Old/Offset_LinNear.eeg.txt.old.' num2str(fNum)]);
            eval(['!cp ' chanInfoDir 'Offset_NearAveCSD1.csd.txt ' chanInfoDir 'Old/Offset_NearAveCSD1.csd.txt.old.' num2str(fNum)]);
            eval(['!cp ' chanInfoDir 'Offset_LinNearCSD121.csd.txt ' chanInfoDir 'Old/Offset_LinNearCSD121.csd.txt.old.' num2str(fNum)]);

            save([chanInfoDir 'AnatCurves.mat'],SaveAsV6,'anatCurves');
            save([chanInfoDir 'Offset.eeg.txt'],'-ascii','offset');
            save([chanInfoDir 'Offset_LinNear.eeg.txt'],'-ascii','offset');
            save([chanInfoDir 'Offset.dat.txt'],'-ascii','offset');
            offset(1) = offset(1)+1;
            save([chanInfoDir 'Offset_NearAveCSD1.csd.txt'],'-ascii','offset');
            offset(1) = offset(1)+1;
            save([chanInfoDir 'Offset_LinNearCSD121.csd.txt'],'-ascii','offset');
            change = 1;
        end
    end
    quitVar = input('do yo want to quit? y/[n]: ','s');
    if strcmp(quitVar,'y')
        if ~isempty(figNums)
            ReportFigSM(figNums,['NewFigs/ChannelLocalization/'],repmat({date},size(figNums)),[10 8],repmat({{'GCFNAME'}},size(figNums)));
        end
        return
    end
end
return
