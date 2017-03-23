%
% compmap() - Plot multiple topoplot() maps of ICA component topographies
%             Click on an individual map to view separately. 
% Usage:
%       >> compmap (winv,'eloc_file',compnos,'title',rowscols,labels,printflag)
%
% winv       Inverse weight matrix = EEG scalp maps. Each column is a
%            map; the rows correspond to the electrode positions
%            defined in the eloc_file. Normally, winv = inv(weights*sphere).
%'eloc_file' Name of the eloctrode position file in the style defined
%            by >> topoplot('example') {default|0 ->'chan_file'}
% compnos    Vector telling which (order of) component maps to show
%            Indices <0 tell compmap to invert a map; = 0 leave blank subplot 
%            Example: [1 0 -2 3 0 -6] {default|0 -> 1:columns_in_winv}
%'title'     Title string for each page {default|0 -> 'ICA Component Maps'}
% rowscols   Vector of the form [m,n] where m is total vertical tiles and n 
%            is horizontal tiles per page. If the number of maps exceeds m*n,
%            multiple figures will be produced {def|0 -> one near-square page}.
% labels     Vector of numbers or a matrix of strings to use as labels for
%            each map, else ' ' -> no labels {default|0 -> 1:ncolumns_in_winv}
% printflag  0 = screen-plot colors {default}
%            1 = printer-plot colors
%
% This function calls topoplot(). Map scaling is to +/-max(abs(data); green = 0

% Colin Humphries, CNL / Salk Institute, Aug, 1996
%    03-97 revised -CH
% 11-05-97 revised for Matlab 5.0.0.4064; added negative compnnos option
%          improved help msg; added figure offsets -Scott Makeig & CH
% 11-13-97 fixed compnos<0 bug -sm
% 11-18-97 added test for labels=comps -sm 
% 12-08-97 added test for colorbar_tp() -sm
% 12-15-97 added axis('square'), see SQUARE below -sm
% 03-09-98 added test for eloc_file, fixed size checking for labels -sm
% 02-09-00 added test for ' ' for srclabels(1,1) -sm
% 02-23-00 added srclabels==' ' -> no labels -sm
% 03-16-00 added axcopy() -sm & tpj

% NOTE: 
% There is a minor problem with the Matlab function colorbar() called below.
% Write authors for further information.

function compmap(Winv,eloc_file,compnos,titleval,pagesize,srclabels,printlabel,caxis)


DEFAULT_TITLE = 'ICA Component Maps';
DEFAULT_EFILE = 'chan_file';
NUMCONTOUR = 5;     % topoplot() style settings
OUTPUT = 'screen';  % default: 'screen' for screen colors, 
                    %          'printer' for printer colors
STYLE = 'both';
INTERPLIMITS = 'head';
MAPLIMITS    = 'absmax';
SQUARE       = 1; % 1/0 flag making topoplot() asex square -> round heads
ELECTRODES   = 'off'; % 'on'; % default: 'on' or 'off'

if nargin<1
   help compmap
   return
end

% pos = get(pca,'Position');
% delete(gca);
% ax = axes('Position',pos);

[chans, frames] = size (Winv);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check inputs and set defaults
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin==8
  if caxis(1,1:2) == 'mi'
     MAPLIMITS = [min(min(Winv(:,compnos))) max(max(Winv(:,compnos)))];
  elseif caxis(1,1:2) == 'ab'
     absmax = max([abs(min(min(Winv(:,compnos)))) abs(max(max(Winv(:,compnos))))]);
     MAPLIMITS = [-absmax absmax];
  elseif size(caxis) == [1,2]
     MAPLIMITS = caxis;
  end % else default
end
if nargin < 7
   printlabel = 0;
end
if printlabel == 0
   printlabel = OUTPUT; % default set above
else
   printlabel = 'printer';
end

if nargin < 6
   srclabels = 0;
end
if nargin < 5
   pagesize = 0;  
end
if nargin < 4
   titleval = 0;
end
if nargin < 3
   compnos = 0;
end
if nargin < 2
   eloc_file = 0;
end

if srclabels == 0
  srclabels = [];
end
if titleval == 0;
   titleval = DEFAULT_TITLE;
end
if compnos == 0
   compnos = (1:frames);
end
if pagesize == 0
   numsources = length(compnos);
   DEFAULT_PAGE_SIZE = ...
[floor(sqrt(numsources)) ceil(numsources/floor(sqrt(numsources)))];
   m = DEFAULT_PAGE_SIZE(1);
   n = DEFAULT_PAGE_SIZE(2);
elseif length(pagesize) ==1
   help compmap
   return
else
   m = pagesize(1);
   n = pagesize(2);
end
if eloc_file == 0 
   eloc_file = DEFAULT_EFILE;
end

totalsources = length(compnos);
if ~isempty(srclabels) 
  if ~ischar(srclabels(1,1)) | srclabels(1,1)==' ' % if numbers
    if size(srclabels,1) == 1
       srclabels = srclabels';
    end
  end
  if size(srclabels,1)==1 & size(srclabels,2)==1 & srclabels==' ' 
     srclabels = repmat(srclabels,totalsources,1);
  end
  if size(srclabels,1) ~= totalsources,
     fprintf('compmap(): numbers of components and component labels do not agree.\n');
     return
  end
end
pages = ceil(totalsources/(m*n));		
if pages > 1
   fprintf('compmap(): will create %d figures of %d by %d maps: ',...
            pages,m,n);
end

pos = get(gca,'Position');
off = [ 25 -25 0 0];  % position offsets for multiple figures

fid = fopen(eloc_file);
if fid<1,
  fprintf('compmap()^G: cannot open eloc_file (%s).\n',eloc_file);
  return
end
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% plot the maps %%%%%%%%%%%%%%%%%%%%%%%

for i = (1:pages)
  if i > 1
    figure('Position',pos+(i-1)*off); % place figures in right-downward stack
  end
  set(gca,'Color','w') %CJH - set background color to white
  
  if (totalsources > i*m*n)
    sbreak = n*m;
  else 
    sbreak = totalsources - (i-1)*m*n;
  end

  for j = (1:sbreak) % maps on this page
    comp = j+(i-1)*m*n; % compno index
    if compnos(comp)~=0
      if compnos(comp)>0
       source_var = Winv(:,compnos(comp))';       % plot map
      elseif compnos(comp)<0
       source_var = -1*Winv(:,-1*compnos(comp))'; % invert map
      end

      subplot(m,n,j)
      % headplot(source_var,eloc_file,'electrodes','off');
       topoplot(source_var,eloc_file,...
        'style',STYLE,...
        'electrodes',ELECTRODES,...
        'numcontour',NUMCONTOUR,...
        'interplimits',INTERPLIMITS,...
        'maplimits',MAPLIMITS); % draw map
      if SQUARE,
         axis('square');
      end

      if isempty(srclabels)
        title(int2str(compnos(comp)))   
      else
        if isstr(srclabels)      
          title(srclabels(comp,:))
        else
	      title(num2str(srclabels(comp)))
        end
      end
      drawnow  % draw one map at a time
    end
  end

  ax = axes('Units','Normal','Position',[.5 .06 .32 .05],'Visible','Off');
  if exist('colorbar_tp') == 2
    colorbar_tp(ax)  % Slightly altered Matlab colorbar()
                     % Write authors for further information.
  else
    colorbar(ax)     % Note: there is a minor problem with this call.
  end
  axval = axis;
  Xlim = get(ax,'Xlim');
  set(ax,'XTick',(Xlim(2)+Xlim(1))/2)
  set(gca,'XTickLabel','0')
  set(gca,'XTickMode','manual')

  axbig = axes('Units','Normalized','Position',[0 0 1 1],'Visible','off');
  t1 = text(.25,.070,titleval,'HorizontalAlignment','center');
  if pages > 1
     fprintf('%d ',i);
  end
  axcopy(gcf); % allow popup window of single map with mouse click
end
if pages > 1
   fprintf('\n');
end
