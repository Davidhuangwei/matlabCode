function [pos_sum, speed_sum, accel_sum] = calcmazespeedbat(filebasemat,autosave,tasktype,shortfilename,smoothlen,trialtypesbool,mazelocationsbool)
% function [pos_sum, speed_sum, accel_sum] = calcmazespeed(filebasemat,smoothlen,trialtypesbool)
% 'filebasemat' has a list of filebase names in each row of a 2D matrix
% 'autosave' 1=automatically save variables, default=ask before save
% 'smoothlen' is the number of points from which to create a gausian smooth to smooth position over time.
%   default = 21
% 'trialtypesbool' is a matrix determining which trial types are analysed
%   default = [1  0  1  0  0   0   0   0   0   0   0   0  0  0  0  1];
%             cr ir cl il crp irp clp ilp crb irb clb ilb xp rp lp dp
%   trial types are designated using sortatertrialtypes.m or sortcircletrialtypes.m

videoxmax = 348;
videoymax = 240;

if ~exist('smoothlen','var'),
    smoothlen = 21; %default
end
if ~exist('shortfilename','var')
    shortfilename = 1;
end
            
if ~exist('trialtypesbool','var')
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                    %cr ir cl il crp irp clp ilp crb irb clb ilb xp
end
if ~exist('mazelocationsbool','var')
    mazelocationsbool = [0  0  0  1  1  1   1   1   1];
                       %rp lp dp cp ca rca lca rra lra
end

[numfiles n] = size(filebasemat);
pos_sum = zeros(ceil(videoxmax),ceil(videoymax));
speed_sum = zeros(ceil(videoxmax),ceil(videoymax));
accel_sum = zeros(ceil(videoxmax),ceil(videoymax));

for i=1:numfiles
    filebase = filebasemat(i,:);
    whldat = load([filebase '.whl']); 
    
    % calculate speed & accleration
    [speeddat acceldat] = mazespeedaccel(whldat,smoothlen);
    
    whldat = loadmazetrialtypes(filebase,trialtypesbool,mazelocationsbool);
     
    notminusones = find(whldat(:,1)~=-1);
    whldat = ceil(whldat); % bin size = 1 pixel
    
    accum_pos = Accumulate(whldat(notminusones,1:2), 1); % accumulate the number of frames spent in each position
    [fa fb] = find(accum_pos);
    pos_sum(fa,fb) = pos_sum(fa,fb) + accum_pos(fa,fb); 
    
    accum_speed = Accumulate(whldat(notminusones,1:2), speeddat(notminusones)); % accumulate speed at each position
    speed_sum(fa,fb) = speed_sum(fa,fb) + accum_speed(fa,fb);
    
    accum_accel = Accumulate(whldat(notminusones,1:2), acceldat(notminusones)); % accumulate accleration at each position
    accel_sum(fa,fb) = accel_sum(fa,fb) + accum_accel(fa,fb);
end 

i == 'y'
if (~exist('autosave') | autosave == 0)
    while 1,
        i = input('Save to disk (yes/no)? ', 's');
        if strcmp(i,'yes') | strcmp(i,'no'), break; end
    end
end
if i(1) == 'n'
    counttrialtypes(filebasemat,1,trialtypesbool);
    return;
else
    trialsmat = counttrialtypes(filebasemat,1,trialtypesbool);     
    if shortfilename,
        outname = [tasktype '_' filebasemat(1,1) filebasemat(1,2:4) filebasemat(1,5) filebasemat(1,6:8) ...
                '-' filebasemat(end,1) filebasemat(end,2:4) filebasemat(end,5) filebasemat(end,6:8)...
                '_pos_speed_accel_sum.mat'];
    else
        outname = [tasktype '_' filebasemat(1,7) filebasemat(1,10:12) filebasemat(1,14) filebasemat(1,17:19) ...
                '-' filebasemat(end,7) filebasemat(end,10:12) filebasemat(end,14) filebasemat(end,17:19)...
                '_pos_speed_accel_sum.mat'];
    end
    if shortfilename == 2,
        outname = [tasktype '_' filebasemat(1,:) '-' filebasemat(end,8:10) '_pos_speed_accel_sum.mat'];
    end

    fprintf('Saving %s\n', outname);
    save(outname,'pos_sum','speed_sum','accel_sum','trialsmat','filebasemat');
end   
return;