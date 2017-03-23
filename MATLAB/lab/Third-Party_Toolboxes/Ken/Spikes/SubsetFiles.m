% SubsetFiles(FileBase, Epochs, NewFileBase)
%
% given a set of .res.n, .clu.n, .spk.n, .fet.n, and .eeg files
%
% this function creates a subset of them, corresponding to spikes
% only in certain epochs.  It then runs spnmergeclub.  Epochs should
% be a nx2 array, giving start and end points, in .res samples.
% these should be divisible to the .eeg sample rate of 1250Hz.
% NB lower limit is inclusive, upper is exclusive, so [0 100]
% means 0<=sample<100.
%
% the times will be adjusted into one continuous .res file ... so
% if you have 2 epochs [0 100; 1000 1100], you will end up with
% all spikes in 0 to 200. 
%
% NB the .eeg files will be simply concatenated.  You probably wouldn't want
% to use this for restricting to theta periods, because there would be
% loads of jumps.  What i wrote it for was extracting those periods of a concatenated
% file for which there is tracking info.


function SubsetFiles(FileBase, Epochs, NewFileBase)

% load and copy .par file
Par = LoadPar([FileBase '.par']);
eval(['!cp ' FileBase '.par ' NewFileBase '.par']);

% calculate translated start point for each chunk
CumStart(1) = 0; % translated starting point for first chunk
for e=1:size(Epochs, 1)
	CumStart(e+1) = CumStart(e)+Epochs(e,2)-Epochs(e,1);
end

if 1

for i=1:Par.nElecGps
	% tetrode number in string format
	c = num2str(i);

	% load and copy .par.n file
	Par1 = LoadPar1([FileBase '.par.' num2str(i)]);
	eval(['!cp ' FileBase '.par.' c ' ' NewFileBase '.par.' c]);

	% don't forget .mm file (whatever it is for)
	eval(['!cp ' FileBase '.mm.' c ' ' NewFileBase '.mm.' c]);

	% load .res.n files etc.
    fprintf('Loading %s tet %d .', FileBase, i);
	Res = load([FileBase '.res.' c]);
    fprintf('.');
	Clu = LoadClu([FileBase '.clu.' c]);
    fprintf('.');
    Fet = LoadFet([FileBase '.fet.' c]);
    fprintf('.\n');
        
    % we now load in spikes on a subset basis (to save memory)
    %Spk = LoadSpk([FileBase '.spk.' c], Par1.nChannels, Par1.WaveSamples);
    
	% initialize new files
	NewRes = [];
	NewClu = [];
	NewFet = [];
	NewSpk = [];

	% go through epochs
	for e=1:size(Epochs, 1)
		Within = find(Res>=Epochs(e,1) & Res<Epochs(e,2));

        if any(diff(Within)~=1)
            error('something smells. .res.n file probably not sorted')
        end

		NewRes = [NewRes ; Res(Within)-Epochs(e,1)+CumStart(e)];
		NewClu = [NewClu ; Clu(Within)];
		NewFet = [NewFet ; Fet(Within, :)];
        SpkSamps = Par1.nSelectedChannels*Par1.WaveSamples;
        SpkWithin = bload([FileBase '.spk.' c], [SpkSamps length(Within)], ...
            (Within(1)-1)*SpkSamps*2, '*int16');
        NewSpk = cat(2, NewSpk, SpkWithin);

	end

	% save new files
	msave([NewFileBase '.res.' c], NewRes);
	SaveClu([NewFileBase '.clu.' c], NewClu);
	SaveFet([NewFileBase '.fet.' c], NewFet);
	SaveSpk([NewFileBase '.spk.' c], NewSpk);
end

% now do eeg ... find downsample multiplier
mult = 1e6/Par.SampleTime/1250;
if any(mod(Epochs(e,1),mult) | mod(Epochs(e,2),mult))
	error('Epochs is not not divisible to eeg frequency!');
end

%Eeg = bload([FileBase '.eeg'], [Par.nChannels inf]);

% make eeg
NewEeg = [];
for e=1:size(Epochs,1)
    EegChunk = bload([FileBase '.eeg'],[Par.nChannels (Epochs(e,2)-Epochs(e,1))/mult], ...
        Epochs(e,1)*Par.nChannels*2/mult, '*int16');
    
    NewEeg = [NewEeg , EegChunk];
end
bsave([NewFileBase '.eeg'], NewEeg);

end
% do .rem files etc
NewRem = [];
NewNonRem = [];
if FileExists([FileBase '.rem'])
    Rem = load([FileBase '.rem'])
    NonRem = load([FileBase '.nonrem'])
%     NonSw = load([FileBase '.nonsw'])
%     Sw = load([FileBase '.sw'])
%     Ssw = load([FileBase '.ssw']);
%     Nsw = load([FileBase '.nsw']);    

    for e=1:size(Epochs,1)
        NewRem = vertcat(NewRem, IntersectRanges(Rem, Epochs(e,:))-Epochs(e,1)+CumStart(e));
        NewNonRem = vertcat(NewNonRem, IntersectRanges(NonRem, Epochs(e,:))-Epochs(e,1)+CumStart(e));
    end

    msave([NewFileBase '.rem'], NewRem);
    msave([NewFileBase '.nonrem'], NewNonRem);
end

% make range array
% EegRange = [];
% for e=1:size(Epochs,1)
% 	EegRange = [EegRange (1+ Epochs(e,1)/mult):(Epochs(e,2)/mult)];
% end
% NewEeg = Eeg(:,EegRange);


% now run spnmergeclub
eval(['!spnmergeclub ' NewFileBase]);
