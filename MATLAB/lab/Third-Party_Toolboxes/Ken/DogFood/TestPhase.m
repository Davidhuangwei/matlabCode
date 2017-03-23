if 0
FileBase = '/u18/buhl/connexin_36/wt/36337/33707-33712/33707-33712';
Res = load([FileBase '.res']);
Clu = LoadClu([FileBase '.clu']);
Eeg = bload([FileBase '.eeg'], [8 inf]);
The = load([FileBase '.the.1']);
Gam = load([FileBase '.gam.1']);

[ThPhase] = ThetaPhase(Eeg(4,:));
[GamPhase] = ThetaPhase(Eeg(4,:), [40 100], 8, 20);
end


for c=1:max(Clu);
	MyRes = Res(find(Clu==c));
	TheRes = MyRes(find(WithinRanges(MyRes, The)));
	GamRes = MyRes(find(WithinRanges(MyRes, Gam(:,[1 3]))));
    RemRes = MyRes(find(WithinRanges(MyRes, [905 1140]*2e4)));

	%HilbThPh = ThPhase(1+floor(TheRes/16));
    HilbThPh = ThPhase(1+floor(RemRes/16));
	CycleThPh = PhaseFromCycles(TheRes, The(:,1), The(:,2));

	%HilbGamPh = GamPhase(1+floor(GamRes/16));
	HilbGamPh = GamPhase(1+floor(RemRes/16));
	CycleGamPh = PhaseFromCycles(GamRes, Gam(:,1), Gam(:,3));

	subplot(2,2,1)
	hist([HilbThPh+pi], 20);
    subplot(2,2,3)
    hist([CycleThPh], 20);
	subplot(2,2,2)
	hist([HilbGamPh+pi], 20);
    subplot(2,2,4);
    hist([CycleGamPh], 20);

	pause
end