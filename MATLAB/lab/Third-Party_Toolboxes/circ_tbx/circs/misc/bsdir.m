% BSDIR             test directional data for significance.
%
%               algorithm is of Crammond & Kalaska 1996.
%               input structure is dir_peth (see PPPETH for details);
%               output structure is saved; output matrix
%               is returned (epochs x units).
%
%               see also MYSP, COMP_RS, DIR_MEAN.

% this function runs for all units x epochs
% RANKS = bsdir([1:64],[1 2],4000)

% 02-aug-02 ES
% 22-aug-02 modifications
% 30-aug-02 return structure modifications
% 09-sep-02 minor chnages (multiple epochs)
% 24,25-sep-02 dissimilar structures bug fixed
% 16-nov-02 first member dissmiliar structure bug fixed
% 11jul03 mode - psf, osf or msd  
% 24-dec-03 constrain mean to be of rows (case 1st comb has 1 trial only)

function RANKS = bsdir(units, epochs, REPS,mode)

global home_dir;
global day_path;
if isempty(home_dir) | isempty(day_path), error('run MYSP first'), end

% arguments
if nargin<4 | isempty(mode), mode = 'msd'; end 
if nargin<3 | isempty(REPS), REPS = 1000; end
if nargin<2 | isempty(epochs), epochs = 1; end
if nargin<1 | isempty(units), units = 1; end
%if find(units<=0) | find(units>=65), error('no such units exist'), end

CHOS = 1; % offset for psf "units"  
switch mode 
case 'msd',     
units = intersect(units,[1:64]);
fbuf = sprintf('%s\\%s\\peth\\peth_data',home_dir,day_path);
case 'psf', 
units = intersect(units,[0:15]);
fbuf = sprintf('%s\\%s\\psf\\structs\\peth_data',home_dir,day_path);
case 'osf', 
units = intersect(units,[1:208]);
fbuf = sprintf('%s\\%s\\osf\\structs\\peth_data',home_dir,day_path);
otherwise    
units = intersect(units,[1:64]);
fbuf = sprintf('%s\\%s\\peth\\peth_data',home_dir,day_path);
end 

% constants
theta = [1/6 0 5/6:-1/6:1/3]'*2*pi;
disp('loading data...')
load(fbuf);

% dir and pos are assumed to contain the same units
aunits = ustr2num({dir_peth(1,:).unit});    % available
[punits allcols] = intersect(aunits,units);

% determine size of SC (epochs)
%[rows aepochs] = size(dir_peth(1,1).SC);
aepochs = length(dir_peth(1,1).SC(1,:));

pepochs = intersect(1:aepochs,epochs);
    
u = 0; k = 0;
for col = allcols(:).'
    unit = ustr2num(dir_peth(1,col).unit); 
    disp(['    unit ' num2str(unit) ':']) 
    u = u + 1;
    e = 0;
    for epoch = pepochs
        e = e + 1;
        str = ['        epoch ' num2str(epoch) ': '];
        if any(isnan([dir_peth(:,col).frate])) | all([dir_peth(:,col).frate]==0)
            disp([str 'not enough data for this unit x epoch'])
            dir_resp(e,u).unit = dir_peth(1,col).unit;
            dir_resp(e,u).epoch = epoch;
            dir_resp(e,u).epoch_name = dir_peth(1,col).epoch_names(epoch);
            dir_resp(e,u).dir_fr = NaN*ones(1,6);
            dir_resp(e,u).pd = NaN;
            dir_resp(e,u).R = NaN;
            dir_resp(e,u).rank = NaN;
            dir_resp(e,u).reps = NaN;
            %                 ,'rank',NaN,'reps',NaN);
            %            dir_resp(e,u).epoch_name = dir_peth(i,col).epoch_names(epoch);
            %             
            %             dir_resp(e,u) = struct('unit',dir_peth(1,col).unit...
            %                 ,'epoch',epoch,'epoch_name',dir_peth(i,col).epoch_names(epoch)...
            %                 ,'dir_fr',NaN*ones(1,6),'pd',NaN,'R',NaN...
            %                 ,'rank',NaN,'reps',NaN);
        else
            % create database of firing rates
            SC = []; DIR = [];
            if e == 1, k = k + 1; end
            for i = 1:6
                SC = [SC; dir_peth(i,col).SC(:,epoch)];  % spike counts for tcs
            end
            N = [dir_peth(:,col).ntrials];
            CN = cumsum(N);
            % mix rates: make a sum(N) by REPS matrix; first column is not mixed
            INDS = [[1:CN(end)]' ceil(rand(CN(end),REPS)*CN(end))];
            MAT = SC(INDS);
            for i = 1:6
                if i==1, ROWS = 1:CN(i);
                else, ROWS = (CN(i-1)+1):CN(i);
                end
                DIR(i,:) = mean(MAT(ROWS,:),1);
            end
            % compute resultants and rank them
            Rs = comp_rs(theta,DIR);
            RANKS(e,u) = (length(find(Rs([2:end])<Rs(1)))+1)/length(Rs);
            [x0, S0, s0] = dir_mean(theta,DIR(:,1));
            dir_resp(e,u) = struct('unit',dir_peth(1,col).unit...
                ,'epoch',epoch,'epoch_name',dir_peth(i,col).epoch_names(epoch)...
                , 'dir_fr',DIR(:,1),'pd',x0,'R',1-S0...
                ,'rank',RANKS(e,u),'reps',REPS);
            disp([str ' rank ' num2str(RANKS(e,u)) '.'])
        end
    end
end


if strcmp(mode,'psf'),  
outf = sprintf('%s\\%s\\psf\\structs\\dir_data',home_dir,day_path);
elseif strcmp(mode,'osf'),  
outf = sprintf('%s\\%s\\osf\\structs\\dir_data',home_dir,day_path);
else 
outf = sprintf('%s\\%s\\peth\\dir_data',home_dir,day_path); end 
save(outf,'dir_resp','RANKS','punits')
disp('***************************************************************************')