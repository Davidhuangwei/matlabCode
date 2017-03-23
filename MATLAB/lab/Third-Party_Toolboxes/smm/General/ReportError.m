function ReportError(varargin)
%function ReportError(varargin)
%[errorText,err2screenBool,logFile,prevError] = DefaultArgs(varargin,{'',0,LoadVar('DefaultErrorLog.mat'),lasterror});
[errorText,err2screenBool,logFile,prevError] = DefaultArgs(varargin,{'',0,LoadVar('DefaultErrorLog.mat'),lasterror});
if err2screenBool
    rethrow(prevError)
else
    try
        fid = fopen(logFile,'a');
        fprintf(fid,'%s',errorText);
        fprintf(fid,[prevError.message '\n']);
        for j=1:length(prevError.stack)
            fprintf(fid,[prevError.stack(j).name '  line=']);
            fprintf(fid,[num2str(prevError.stack(j).line) '\n']);
        end

        fprintf(fid,'\n');
        fclose(fid);
    catch
        rethrow(prevError)
    end
end
