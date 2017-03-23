%
%function WebPrint(FigHandleMat, FileNameCell, plotSize, Preview, Comment, Resolution)
% This is a quick and simple function to generate an HTML
% page containing the figure and comments on it. Figures entered
% under the same filename (or on the same day) will be added to the same
% page. The html file and directory with figures are stored in
% homedir/mrep. Both jpeg and matlab .fig are stored.
% FigHandleMat  (default = gcf)
% FileName  - (default = current date) just name, no path
% Preview (default = 0) if 1 - launches browser to preview the page
% Comment - to put below, default - Figure #
function WebPrint(FigHandleMat, FileNameCell, plotSize, Preview, Comment, Resolution)

%TodayDate = date;

if ~exist('FigHandleMat','var') | isempty(FigHandleMat)
    FigHandleMat = gcf;
end
if ~exist('FileNameCell','var') | isempty(FileNameCell)
    happy=1;
    for i=1:length(FigHandleMat)
        FileNameCell{i} = [get(FigHandleMat(i),'name') '_' date];
    end
end
if ~exist('Preview','var') | isempty(Preview)
    Preview = 0;
end
if ~exist('Comment','var') | isempty(Comment)
    Comment = [];
end
if ~exist('Resolution','var') | isempty(Resolution)
    Resolution = 100;
end

%[FileName, Preview,Comment,Resolution] = DefaultArgs(varargin,{DefFileName,0,[],100});
for j=1:length(FigHandleMat)
    FileName = FileNameCell{j};
    UserPath = '/u12/smm/public_html/MatlabPrint/';
    LongFileName = [UserPath  FileName '.html'];
    DirName = [UserPath  FileName];
    %if exist([UserPath ])~=7
    %    mkdir(UserPath,);
    %end
    if FileExists(LongFileName)
        fprintf('adding to existing report\n');
        DirCont = dir(DirName);
        DirCont = DirCont(3:end);
        maxindex=1;
        for i=1:length(DirCont)
            [d1,name,ext] = fileparts(DirCont(i).name);
            digind = strfind(name,'-')+1;
            digind = digind(end);
            maxindex = max(maxindex, str2num(name(digind:end)));
        end
        FigIndex = maxindex+1;
        %	keyboard
    else
        mkdir([UserPath ],FileName);
        FigIndex = 1;
    end
    LongFigName = [DirName '/' FileName '-' num2str(FigIndex)];
    FigName = [FileName '-' num2str(FigIndex)];
    fPointer=fopen(LongFileName,'at+');
    if fPointer<3
        error('Can''t open html file');
    end
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
        set(FigHandleMat(j),'PaperPosition',get(FigHandleMat(j),'PaperPosition'));
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
        fprintf(fPointer,'<br>%s<hr>',Comment);
    else
        fprintf(fPointer,'<br><hr>');
    end


    fprintf(fPointer,'</body>\n</html>\n\n');
    fclose(fPointer);

    if Preview
        web(LongFileName,'-browser');
    end
end
