function interpolated = interpolatebadchan(filebase,saveinterpfile)

if ~exist('saveinterpfile')
    saveinterpfile = 0;
end

interpolated = bload([filebase '.eeg'],[97 inf],0,'int16');

interpolated(16,:) = interpolated(15,:);
interpolated(81,:) = interpolated(82,:);

bscnoe =  [21 23 25 27 29 31 55 69 71 73 86 93]; % bad single channels not on end of shank

for i=1:length(bscnoe)
    interpolated(bscnoe(i),:) = (interpolated(bscnoe(i)-1,:) + interpolated(bscnoe(i)+1,:))/2;
end

tempchan = (interpolated(74,:) + interpolated(77,:))/2;
interpolated(75,:) = (tempchan + interpolated(74,:))/2;
interpolated(76,:) = (tempchan + interpolated(77,:))/2;

i == 'y'
if (saveinterpfile == 0)
    while 1,
        i = input('Save to disk (yes/no)? ', 's');
        if strcmp(i,'yes') | strcmp(i,'no'), break; end
    end
end
if i(1) == 'n'
    return;
else
    outname = [filebase '_linintp.eeg'];
    fprintf('Saving %s\n', outname);
    bsave(outname,interpolated,'int16');
end    

