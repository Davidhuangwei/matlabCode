%
% timtopo() - plot a data epoch and map its scalp topography at given times
%
% Usage:
%  >> timtopo(data,'chan_locs',[limits],[plottimes]','title',[plotchans],[voffsets]);
% Inputs:
%
%  data       = EEG/ERP data epoch (chans,frames)
% 'chan_locs' = channel location file, See >> topoplot('example') {def|0 -> 'chan_file'}
%  [limits]   = [xmin xmax ymin ymax]  (x's in ms) {def|0 or both y's 0 -> data limits}
%  plottimes  = vector of times to topoplot {default|0 -> frame of max(var())}
% 'title'     = plot title {default|0 -> none}
%  plotchans  = data channels to plot {default|0 -> all}
%  voffsets   = vertical lines extend above the data this much (plot units){def -> 0}
%

% 1-10-98 from compplot.m Scott Makeig, CNL / Salk Institute, La Jolla

function M = timtopo(data,chan_file,limits,plottimes,titl,plotchans,voffsets)

MAPLIMITS = 'maxmin'; % 'absmax' % topomap color limits, absmax is default

if nargin < 1
   help timtopo
   return
end

[chans,frames] = size(data);
icadefs;   

if nargin < 7
  voffsets = zeros(1,32);
end
if nargin < 6
   plotchans = 0;
end
if plotchans==0
   plotchans = 1:chans;
end

if nargin < 5,
   titl = '';     % DEFAULT TITLE
end

plottimes_set=1;   % flag variable
if nargin < 4
    plottimes_set = 0;
end

limitset = 0;
if nargin < 3,
    limits = 0;
elseif length(limits)>1
    limitset = 1;
end

if nargin < 2
    chan_file = 'chan_file';  % DEFAULT CHAN_FILE
end
if chan_file == 0,
    chan_file = 'chan_file';  % DEFAULT CHAN_FILE
end

%
%%%%%%%%%%%%%%%%%%%%%%% Read and adjust limits %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
  if limits==0,      % == 0 or [0 0 0 0]
    xmin=0;
    xmax=frames-1;
    ymin=min(min(data));
    ymax=max(max(data));
  else
    if length(limits)~=4,
      fprintf( ...
       'timtopo: limits should be 0 or an array [xmin xmax ymin ymax].\n');
      return
    end;
    xmin = limits(1);
    xmax = limits(2);
    ymin = limits(3);
    ymax = limits(4);
  end;

  if xmax == 0 & xmin == 0,
    x = (0:1:frames-1);
    xmin = 0;
    xmax = frames-1;
  else
    dx = (xmax-xmin)/(frames-1);
    x=xmin*ones(1,frames)+dx*(0:frames-1); % compute x-values
    xmax = xmax*frames/frames;
  end;
  if xmax<=xmin,
      fprintf('timtopo() - xmax must be > xmin.\n')
      return
  end

  if ymax == 0 & ymin == 0,
      ymax=max(max(data));
      ymin=min(min(data));
  end
  if ymax<=ymin,
      fprintf('timtopo() - ymax must be > ymin.\n')
      return
  end

sampint = (xmax-xmin)/(frames-1); % sampling interval = 1000/srate;
x = xmin:sampint:xmax;   % make vector of x-values

%
%%%%%%%%%%%%%%% Compute plotframes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

if plottimes_set == 1
  ntopos = length(plottimes);
  if ntopos > 32
    fprintf('timtopo(): too many plottimes!\n');
    return
  end
  if max(plottimes) > xmax | min(plottimes)< xmin
    fprintf('timtopo(): plottimes out of range - cannot plot.\n');
    return
  end
  if sort(plottimes) ~= plottimes
    fprintf('timtopo(): plottimes out of order - lines would cross.\n');
    return
  end
  xshift = [x(2:frames) xmax];
  plotframes = ones(size(plottimes));
  for t = 1:ntopos
    time = plottimes(t);
    plotframes(t) = find(time>=x & time < xshift);
  end
else
  [mx plotframes] = max(sum(data.*data)); 
                  % default plotting frame has max variance
  plottimes = x(plotframes);
  ntopos=1;
end

vlen = length(voffsets); % extend voffsets if necessary
i=1;
while vlen< ntopos
        voffsets = [voffsets voffsets(i)];
        i=i+1;
        vlen=vlen+1;
end

topowidth = 0.76/(ntopos+(ntopos-1)/5); % width of each topoplot
if topowidth*1.2 + 0.68 > 0.90    % adjust for maximum height
    topowidth = (0.90-0.68)/1.2;
end
if ntopos == 2
   topoleft = 0.32;
elseif ntopos == 1
   topoleft = (1-(0.94-0.68)/1.2)/2; % center single topomap
else
   topoleft = 0.12;
end
if max(plotframes) > frames
    fprintf('Plot frame %d is > frames in data (%d)\n',max(plotframes),frames);
    return
end
if min(plotframes) < 1
    fprintf('Plot frame %d is < 1\n',min(plotframes));
    return
end

%
%%%%%%%%%%%%%%%%%%%% Print times and frames %%%%%%%%%%%%%%%%%%%%%%%%%%
%

fprintf('Topo maps will show times: ');
for t=1:ntopos
  fprintf('%4.0f ',plottimes(t));
end
fprintf('\n');
fprintf('                   frames: ');
for t=1:ntopos
  fprintf('%4d ',plotframes(t));
end
fprintf('\n');

%
%%%%%%%%%%%%%%%%%%%%%%% Plot the data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
clf % clear the current figure
set(gcf,'Color',BACKCOLOR); % set the background color

% site the plot at bottom of the figure
axe = axes('Units','Normalized','Position',[.12 .12 .76 .44],'FontSize',16);
set(gca,'Color',BACKCOLOR);

limits = get(axe,'Ylim');
set(axe,'GridLineStyle',':')
set(axe,'Xgrid','off')
set(axe,'Ygrid','on')
axes(axe)
axcolor = get(gcf,'Color');
set(axe,'Color',BACKCOLOR);
plot(x,data(plotchans,:))    % plot the data

l= xlabel('Time (ms)');
set(l,'FontSize',14);
l=ylabel('Potential (uV)');
set(l,'FontSize',14);
axis([xmin xmax ymin ymax]);

%
%%%%%%%%%%%%%%%%%%%%%%%%% Draw vertical lines %%%%%%%%%%%%%%%%%%%%%%%%%%
%
width  = xmax-xmin;
height = ymax-ymin;

hold on
for t=1:ntopos % dfraw vertical lines through the data at topoplot frames
  l1 = plot([plottimes(t) plottimes(t)],...
    [min(data(plotchans,plotframes(t))) ...
     voffsets(t) + max(data(plotchans,plotframes(t)))],'b');
end
%
%%%%%%%%%%%%%%%%%%%%%%%%% Draw oblique lines %%%%%%%%%%%%%%%%%%%%%%%%%%
%
axall = axes('Units','Normalized','Position',[0 0 1 1],...
             'Visible','Off','Fontsize',16);    % whole-figure invisible axes
axes(axall)
set(axall,'Color',BACKCOLOR);
axis([0 1 0 1])

for t=1:ntopos % dfraw oblique lines through to the topoplots 
  axes(axall)
  axis([0 1 0 1]);
  set(gca,'Visible','off');

  l1 = plot(...
     [0.12+0.76*(plottimes(t)-xmin)/width  ...
      topoleft+(t-1)*6*topowidth/5+topowidth/2],...
      [0.44*(voffsets(t)/height) ...
            + 0.12+(max(data(plotchans,plotframes(t)))-ymin)/height*0.44 ...
      0.70],'b');
  hold on
  set(gca,'Visible','off');
  axis([0 1 0 1]);
end

%
%%%%%%%%%%%%%%%%%%%%%%%%% Plot the topoplots %%%%%%%%%%%%%%%%%%%%%%%%%%
%

for t=1:ntopos
  axt = axes('Units','Normalized','Position',...
                 [topoleft+(t-1)*6*topowidth/5 0.68 topowidth topowidth*1.2]);

  axes(axt)                                           % topoplot axes
  cla
  % topoplot(data(:,plotframes(t)),chan_file,'style','both'); % make a topoplot
  topoplot(data(:,plotframes(t)),chan_file,'style','both','maplimits',MAPLIMITS);   % make a topoplot
  % headplot(data(:,plotframes(t)),'chan.spline'); % make a 3-d headplot
  timetext = num2str(plottimes(t),'%4.0f');
  text(0.00,0.70,timetext,'FontSize',14,'HorizontalAlignment','Center');
  axt = axes('Units','Normalized','Position',[0 0 1 1],...
               'Visible','Off','Fontsize',16);        % topoplot axes
  set(axt,'Color',BACKCOLOR);
end
axcopy(gcf);

%
%%%%%%%%%%%%%%%%%%%%%%%%% Make the colorbar %%%%%%%%%%%%%%%%%%%%%%%%%%
%

  axt = axes('Units','Normalized','Position',[.88 .58 .03 .10]); % colorbar axes
  h=colorbar(axt);  
  set(h,'Ytick',[]);

  axes(axall)
  set(axall,'Color',BACKCOLOR);
  text(0.50,0.96,titl,'FontSize',16,'HorizontalAlignment','Center');
  text(0.86,0.67,'+','FontSize',16,'HorizontalAlignment','Center');
  text(0.86,0.59,'-','FontSize',16,'HorizontalAlignment','Center');
