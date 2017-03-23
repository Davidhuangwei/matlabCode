function cancelFlag=setsigpref(newPropList,newValueList,diskFlag)
%SETSIGPREF Set user preference for Signal Processing Toolbox.
%   SETSIGPREF(prop, val) adds the property value pair (prop, val) to the list 
%   of preferences associated with the Signal Processing Toolbox. If a property
%   with the given tag already exists, its value is overwritten. prop and val 
%   can be cell arrays of the same size. The preferences are saved in a global
%   variable named SIGPREFS.
%
%   SETSIGPREF(prop, val, diskFlag) is the same as above except that when
%   diskFlag = 1 it saves the information to disk.
%   If sigprefs.mat is not found on the path or in the current directory,
%   SETSIGPREF will put up a dialog asking you for a directory name.   
%   sigprefs.mat will be saved in the directory you specify.   If this 
%   operation is canceled by the user SETSIGPREF returns a 1.
%
%
%   Be careful to get the field names correct, as any typos will add new 
%   fields by mistake.
%
%   See also GETSIGPREF.

%   Ned Gulley, 9-11-95
%   Adapted for Signal, Tom Krauss, 3-22-96
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%       $Revision: 1.1 $

global SIGPREFS

cancelFlag = 0;

if ~iscell(newPropList), newPropList=cellstr(newPropList); end
if ~iscell(newValueList), newValueList={newValueList}; end
for count=1:length(newPropList),
    prop=newPropList{count};
    val=newValueList{count};
    SIGPREFS=setfield(SIGPREFS,prop,val);
end

if nargin < 3
    diskFlag = 0;
end

if diskFlag
    fileName='sigprefs.mat';
    fullPathName=which(fileName);
    if isempty(fullPathName)
        % Need to create the prefs file since it doesn't exist.
        prompt = {'Please select a directory in which to save the'...
                'sigprefs.mat preferences file.  This MAT-file'...
                'remembers certain Signal Processing Toolbox'...
                'settings for you between MATLAB sessions.  You' ...
                'should save this file either on your path or in'...
                'your working directory so the Toolbox can find it later.'};
        cptr = computer;
        if ~isempty(findstr(cptr,'MAC')) | ~isempty(findstr(cptr,'PCWIN'))
            prompt = {prompt{:} ...
                    'I recommend saving the file in your toolbox\signal' ...
                    'directory.'};
        end
        
        waitfor(msgbox(prompt,'Preferences MAT-file','none','modal'))
        
        [f,p]=uiputfile('sigprefs.mat','Save Preferences File');
        while ~isempty(f) & length(f>1) & isstr(f) & ~strcmp(f,'sigprefs.mat')
            waitfor(msgbox('Sorry, the filename must be ''sigprefs.mat''.',...
                'Can''t Change Name',...
                'error','modal'))
            [f,p]=uiputfile('sigprefs.mat','Save Preferences File');
        end
        
        if ~isequal(f,0)
            fullPathName = fullfile(p,'sigprefs.mat');
            createFlag = 1;
        else
            cancelFlag = 1;
            return
        end
    else
        % The prefs file does exist already
        % If SIGPREFS has not been loaded yet, its size will be 0-by-0
        if (size(SIGPREFS,1)==0),
            load(fileName)
        end
        createFlag = 0;
    end
    
    save(fullPathName,'SIGPREFS');
    
    if createFlag
        % work around for geck 18848; need to rebuild path cache so 'sigprefs.mat'
        % is found next time.
        exist('sigprefs.mat');  % exist rebuilds the path cache; which does not
    end
end

function c = strsep(s,sep)
%STRSEP Separate string into cell string.
%   STRSEP(s,sep) is a cell array containing the strings in s that are
%   separated with the character sep.
%
%   For example, c = strsep(path,pathsep);  contains each directory
%   on the path in its elements.

k = findstr(s,sep);
c = cell(length(k)+1,1);
k = [0 k length(s)+1];

for i = 1:length(k)-1
    c{i} = s( (k(i)+1) : (k(i+1)-1) );
end

