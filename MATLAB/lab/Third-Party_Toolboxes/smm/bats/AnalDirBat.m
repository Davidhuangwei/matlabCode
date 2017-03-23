% function AnalDirBat(analDirs,filesNameCell,funcHandle,varargin)
function AnalDirBat(analDirs,filesNameCell,funcHandle,varargin)

% varargout = cell(nargout,1)
cwd = pwd;
for j=1:length(analDirs)
    cd(analDirs{j})
    fprintf([analDirs{j} '\n'])
    fileBaseCell = {};
    if isempty(filesNameCell)
        funcHandle(varargin{:});
    else
        for k=1:length(filesNameCell)
            fileBaseCell = cat(1,fileBaseCell,LoadVar(['FileInfo/' filesNameCell{k}]));
        end

        %     if ~nargout
        %         varargout(:) = funcHandle(fileBaseCell,varargin{:});
        %     else
        funcHandle(fileBaseCell,varargin{:});
        %     end
    end
end
cd(cwd);
return