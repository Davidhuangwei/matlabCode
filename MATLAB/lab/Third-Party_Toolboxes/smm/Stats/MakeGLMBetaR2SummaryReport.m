function MakeGLMBetaR2SummaryReport(analRoutine,analRoutineExt,spectAnalBaseCell,fileExtCell,depVarCell,plotTypeCell,figNums)

cwd = pwd;
for k=1:length(spectAnalBaseCell)
    for m=1:length(fileExtCell)
        outDir = ['SummaryPage/' spectAnalBaseCell{k} Dot2Underscore(fileExtCell{m}) ];
        fprintf('outDir = %s\n',outDir);
        if ~exist(outDir,'dir')
            mkdir(outDir);
        end
        for n=1:length(depVarCell)
            fprintf('depVar = %s\n',depVarCell{n});
            for p=1:length(plotTypeCell)
                LongFileName = [outDir '/' depVarCell{n} plotTypeCell{p} '.html'];
                fPointer=fopen(LongFileName,'w+');
                if fPointer<3
                    error('Can''t open html file');
                else
                    fprintf(['Opening: ' LongFileName '\n'])
                end
                for j=1:length(analRoutine)
                    fprintf('Adding: %s\n',analRoutine{j});
                    for r=1:length(figNums)
                        FigIndex = (j-1)*length(figNums)+r;
                        if r == 1
                            fprintf(fPointer,'<html>\n<head>\n<title>%s </title>\n</head>\n<body>\n<h2>%s</h2>\n',analRoutine{j},analRoutine{j});
%                         else
%                             fprintf(fPointer,'<html>\n<body>\n',analRoutine{j});
                        end
                        %                         % now generate link to image
                        %   fprintf(fPointer, '<img src="%s" alt="Figure %d">\n<br><br>\n',[FileName '/' FigName '.jpg'],FigIndex);
                        inDir = [ analRoutine{j} analRoutineExt '/' spectAnalBaseCell{k} Dot2Underscore(fileExtCell{m}) '/'];
                        [inDir depVarCell{n} plotTypeCell{p} '*.html']
                        files = dir([inDir depVarCell{n} plotTypeCell{p} '*.html']);
                        fprintf('%s\n',[analRoutine{j} analRoutineExt]);
%                         keyboard
                        try 
                            inFile = ['../../' inDir files(end).name(1:end-5) '/' files(end).name(1:end-5) '-' num2str(figNums(r)) '.png'];
                        catch
                            junk = lasterror;
                            files
                            rethrow(error)
                        end
                        %fprintf(fPointer, '<img src="%s">',inFile);
                        fprintf(fPointer, '<img src="%s" alt="Figure %d">',inFile,FigIndex);
                        %                             fprintf(fPointer, '<img src="%s" alt="Figure %d">',[inFile],FigIndex);
                        if r==length(figNums)
                            fprintf(fPointer,'<br><hr>');
                        else
                            fprintf(fPointer,'<br>');
                        end
                        fprintf(fPointer,'</body>\n</html>\n\n');
                    end

                end

                fclose(fPointer);

%                 if Preview
%                     web(LongFileName,'-browser');
%                 end
            end
        end
    end
end
return
    if FigIndex == 1
        fprintf(fPointer,'<html>\n<head>\n<title>Matlab report %s </title>\n</head>\n<body>\n<h2>Matlab Report Page : %s</h2>\n',FileName,FileName);

    else
        fprintf(fPointer,'<html>\n<body>\n',FileName);
    end
    %now let's print figure
    if exist('plotSize','var') & ~isempty(plotSize)
        set(FigHandleMat(j),'PaperPosition',[(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)]);
        set(FigHandleMat(j), 'Units', 'inches')
        set(FigHandleMat(j), 'Position', [(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)])
    else
        set(FigHandleMat(j), 'Units', 'inches')
        set(FigHandleMat(j),'PaperPosition',get(FigHandleMat(j),'Position'));
        %get(FigHandleMat(j), 'Position')
        set(FigHandleMat(j), 'Position', get(FigHandleMat(j), 'Position'));
    end
    %resol = ['-r' num2str(Resolution)];
    %keyboard
    %print(FigHandleMat(j), '-djpeg100', [LongFigName '.jpg'],resol);
    resol = ['-r' num2str(Resolution)];
    print(FigHandleMat(j), '-dpng', [LongFigName '.png'],resol);
    % and save figure
    %saveas(FigHandleMat(j), [LongFigName '.fig'], 'fig');

    % now generate link to image
 %   fprintf(fPointer, '<img src="%s" alt="Figure %d">\n<br><br>\n',[FileName '/' FigName '.jpg'],FigIndex);
    fprintf(fPointer, '<img src="%s" alt="Figure %d">',[FileName '/' FigName '.png'],FigIndex);

    %if isempty(Comment)
        % obtain comment
        %prompt = ['Enter comments for figure' num2str(FigIndex)];

        %Text = inputdlg(prompt, 'Commnents dialog', 1, {['Figure ' num2str(FigIndex)]});
        %Comment = Text{1};
        %Comment =['Figure ' num2str(FigIndex)];
   % end

    %put comment in the html file
    %fprintf(fPointer,'<p>%s</p>\n<br>\n<hr>\n<br>\n',Comment);
    if ~isempty(Comment)
        for k=1:length(Comment{j})
            if strcmp(Comment{j}{k},'GCFNAME')
                fprintf(fPointer,'<br>%s',get(FigHandleMat(j),'name'));
            else
                fprintf(fPointer,'<br>%s',Comment{j}{k});
            end
        end
    end
        fprintf(fPointer,'<br><hr>');
    


    fprintf(fPointer,'</body>\n</html>\n\n');
    fclose(fPointer);


    