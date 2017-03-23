%
% seemovie() - see an EEG movie produced by eegmovie()
%
% Usage:
%        >> seemovie(Movie,ntimes,Colormap)
%
%         Movie    = Movie matrix returned by eegmovie()
%         ntimes   = Number of times to display {0 -> -1000}
%                    If ntimes < 0, movie will play forward|backward
%         Colormap = Color map returned by eegmovie() {0 -> default}
%

% 6/3/97 Scott Makeig & Colin Humphries, CNL / Salk Institute, La Jolla CA
% 10-31-97 changed test for user-defined colormap -ch & sm
% 1-8-98 added '\n' at end, improved help msg -sm

function seemovie(Movie,ntimes,Colormap)

fps = 10;   % projetion speed (requested frames per second)

if nargin<1
   help seemovie
   return
end
if nargin<3
    Colormap = 0;
end
if nargin<2
	ntimes = -1000;    % default to playing foward|backward endlessly
end
if ntimes == 0
	ntimes = -1000;
end

clf
axes('Position',[0 0 1 1]);
if size(Colormap,2) == 3 % if colormap user-defined
	colormap(Colormap)
else
	colormap([jet(64);0 0 0]);    % set up the default topoplot color map
end

if ntimes > 0,
 fprintf('Movie will play slowly once, then %d times faster.\n',ntimes);
else 
 fprintf('Movie will play slowly once, then %d times faster forwards and backwards.\n',-ntimes);
end
if abs(ntimes) > 7
	fprintf('   Hit Cntrl-C to abort:  ');
end

%%%%%%%%%%%%%%%%%%%%%%%% Show the movie %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

movie(Movie,ntimes,fps);  

%%%%%%%%%%%%%%%%%%%%%%%%    The End     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if abs(ntimes) > 7
	fprintf('\n');
end
