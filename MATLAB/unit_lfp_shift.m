out = struct([]);
for fi = 1:length(freq)
    fprintf('%f\n',freq(fi));
    fr = freq(fi)+[-5 5];
    flfp = ButFilter(lfp,2,fr/625,'bandpass');
    ph = angle(hilbert(flfp));
    for gii=1:9
        myres = res(clu==gi(gii));
        for k=1:93
            [out.p(k,fi,gii,:), lag, out.th0(k,fi,gii,:), out.r(k,fi,gii,:)] = ...
                ShiftPhase(ph(:,k),myres,63,1);
        end
    end
end