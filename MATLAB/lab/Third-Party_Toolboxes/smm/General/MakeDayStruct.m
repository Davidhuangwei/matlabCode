function dayStruct = MakeDayStruct(daysCell,varargin)
%function dayStruct = MakeDayStruct(daysCell,varargin)
%saveBool = DefaultArgs(varargin,0)
% Makes a 'dayStruct' with each file as a field containing a text array
% designating the day on which the file was recorded.
% Requires '../dayCell{j}/processed/fileBase'


saveBool = DefaultArgs(varargin,0);
    
current = pwd;
for j=1:length(daysCell)
    cd(['../' daysCell{j} '/processed/']);
    infoStruct = dir;
    for k=3:length(infoStruct) % skip . & ..
        try dayStruct.(infoStruct(k).name) = daysCell{j};
        catch fprintf('\n**** ERROR: %s has invalid name',infoStruct(k).name);
        end
    end
    cd(current);
end

if saveBool
    save('DayStruct.mat',SaveAsV6,'dayStruct');
end