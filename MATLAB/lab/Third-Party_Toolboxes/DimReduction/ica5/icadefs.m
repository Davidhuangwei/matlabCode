%
% icadefs - file of default filenames and constants to source in the ICA /ERP
%               package functions.  Insert local dir reference below. 

% 05-20-97   Scott Makeig, CNL / Salk Institute, La Jolla CA

if isunix
 ICADIR = [ '/home/scott/matlab/' ];  % INSERT your Unix Matlab ICA dirname here!
else
 ICADIR = [ 'f:\scott\matlab\' ];  % INSERT your PC matlab ICA dirname here!
end

ENVCOLORS  = [ ICADIR 'envproj.col' ]; % default color-order
%                                        filename for envproj.m here.

PROJCOLORS = [ ICADIR 'white1st.col' ]; % default color-order
%                                         filename for plotproj.m here.
BACKCOLOR  = [0.7 0.7 0.7]; % background color for plotting

MAXENVPLOTCHANS   = 256;   % maximum number of channels to plot in envproj()
MAXPLOTDATACHANS  = 256;  % maximum number of channels to plot in dataplot()
                          %         and functions that use it.
MAXPLOTDATAEPOCHS = 256;   % maximum number of epochs to plot in dataplot()
MAXEEGPLOTCHANS   = 256;  % maximum number of channels to plot in eegplot()
MAXTOPOPLOTCHANS  = 256;  % maximum number of channels to plot in topoplot()
DEFAULT_ELOC  = 'chan_file'; % default electrode location file for topoplot()
DEFAULT_SRATE = 256;      % default sampling rate
DEFAULT_EPOCH = 10;       % default max epoch width to plot in eegplot(s)()

if strcmp(ICADIR,'XXX/')
    fprintf('===============================================\n');
    fprintf('You have not set the ICADIR variable in icadefs.m\n');
    fprintf('===============================================\n');
    return
end

