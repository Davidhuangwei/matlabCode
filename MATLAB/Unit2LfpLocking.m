function [rtf f]= Unit2LfpLocking(eeg, Res, varargin)

[Clu, FreqRange, WithShifts] = DefaultArgs(varargin,{ones(size(Res)), [1 200], 0});

% defines logarythmic freq. grid
bs=2;
n=21;
d1 = log(FreqRange(1))/log(bs);
d2 = log(FreqRange(2))/log(bs);
y = (bs).^ [d1+(0:n-2)*(d2-d1)/(floor(n)-1), d2];
Freqs(:,1) = ((y(1:end-1)+y(2:end))/2)'; %center freq
Freqs(:,2) = diff(y(:)); % width of the freq. bin

MaxShift = 40; ShiftStep =5;


nChannels = size(eeg,2);
for ii=1:nChannels
    for jj=1:size(Freqs,1)
        myFreqRange = Freqs(jj,1)+[-0.5 0.5]*Freqs(jj,2);
        feeg = ButFilter(eeg(:,ii),2,myFreqRange/625,'bandpass');
        hlb = hilbert(feeg);
        ph = angle(hlb);
        
        if ~WithShifts
           rt = RayleighTest(ph(Res),Clu,max(Clu));
            %rtf.rt(ii,jj).logZ = rt.logZ;
            %rtf.rt(ii,jj).n = rt.n;
            rtf.th0(ii,jj,:) = rt.th0;
            rtf.r(ii,jj,:) = rtf.r;
        else
            for kk=1:max(Clu)
                if sum(Clu==kk)
                    [p, lag, th0, r, logZ] = ShiftPhase(ph,Res(Clu==kk),MaxShift, ShiftStep);
                    rtf.th0(ii,jj,kk,:) = th0;
                    rtf.r(ii,jj,kk,:) = r;
                end
            end
        end
    end
end
f = Freqs(:,1);