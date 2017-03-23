function apr18bat(alterfiles, circlefiles)

for i=1:96
    eegchannels(i) = i;
end

calcpospowsum(alterfiles,'.eeg',97,eegchannels,6,14,600,601,'alter',1,1,1,1);
calcpospowsum(alterfiles,'.eeg',97,eegchannels,7,12,600,601,'alter',1,1,1,1);
calcpospowsum(alterfiles,'.eeg',97,eegchannels,15,22,600,601,'alter',1,1,1,1);
calcpospowsum(alterfiles,'.eeg',97,eegchannels,25,32,600,601,'alter',1,1,1,1);
calcpospowsum(alterfiles,'.eeg',97,eegchannels,34,40,600,601,'alter',1,1,1,1);
calcpospowsum(alterfiles,'.eeg',97,eegchannels,45,100,300,301,'alter',1,1,1,1);

calcpospowsum(circlefiles,'.eeg',97,eegchannels,6,14,600,601,'circle',1,1,1,1);
calcpospowsum(circlefiles,'.eeg',97,eegchannels,7,12,600,601,'circle',1,1,1,1);
calcpospowsum(circlefiles,'.eeg',97,eegchannels,15,22,600,601,'circle',1,1,1,1);
calcpospowsum(circlefiles,'.eeg',97,eegchannels,25,32,600,601,'circle',1,1,1,1);
calcpospowsum(circlefiles,'.eeg',97,eegchannels,34,40,600,601,'circle',1,1,1,1);
calcpospowsum(circlefiles,'.eeg',97,eegchannels,45,100,300,301,'circle',1,1,1,1);



for i=1:6
    for j=1:16
        chanmat(i,j) = (i-1)*16 + j;
    end
end
for i=1:6
    chancell{i} = chanmat(i,:);
end


[nfiles n] = size(alterfiles);
for i=1:nfiles
    interpolatebadchan(alterfiles(i,:),1);
    FileCSD([alterfiles(i,:) '_linintp'], 97, chancell, [1])
end


[nfiles n] = size(circlefiles);
for i=1:nfiles
    interpolatebadchan(circlefiles(i,:),1);
    FileCSD([circlefiles(i,:) '_linintp'], 97, chancell, [1])
end

for i=1:84
    csdchannels(i)=i;
end

calcpospowsum(alterfiles,'_linintp.csd',84,csdchannels,6,14,600,601,'alter',1,1,1,1);
calcpospowsum(alterfiles,'_linintp.csd',84,csdchannels,7,12,600,601,'alter',1,1,1,1);
calcpospowsum(alterfiles,'_linintp.csd',84,csdchannels,15,22,600,601,'alter',1,1,1,1);
calcpospowsum(alterfiles,'_linintp.csd',84,csdchannels,25,32,600,601,'alter',1,1,1,1);
calcpospowsum(alterfiles,'_linintp.csd',84,csdchannels,34,40,600,601,'alter',1,1,1,1);
calcpospowsum(alterfiles,'_linintp.csd',84,csdchannels,45,100,300,301,'alter',1,1,1,1);

calcpospowsum(circlefiles,'_linintp.csd',84,csdchannels,6,14,600,601,'circle',1,1,1,1);
calcpospowsum(circlefiles,'_linintp.csd',84,csdchannels,7,12,600,601,'circle',1,1,1,1);
calcpospowsum(circlefiles,'_linintp.csd',84,csdchannels,15,22,600,601,'circle',1,1,1,1);
calcpospowsum(circlefiles,'_linintp.csd',84,csdchannels,25,32,600,601,'circle',1,1,1,1);
calcpospowsum(circlefiles,'_linintp.csd',84,csdchannels,34,40,600,601,'circle',1,1,1,1);
calcpospowsum(circlefiles,'_linintp.csd',84,csdchannels,45,100,300,301,'circle',1,1,1,1);
