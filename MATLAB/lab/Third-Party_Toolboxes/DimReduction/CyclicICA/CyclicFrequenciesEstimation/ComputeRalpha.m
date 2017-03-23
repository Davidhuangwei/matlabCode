function [ Freq,D ] = ComputeRalpha(y,M)

% Calcul de la correlation à l'instant M
tau = -M:M;

D = 0;

for (iy = 1:size(y,1))
    yi = y(iy,:);
    for (itau=1:length(tau))
        if (tau(itau)>0)
            z = yi(1+tau(itau):length(y)).*conj(yi(1:(length(y)-tau(itau))));
        else
            z = conj(yi(1-tau(itau):length(y))).*yi(1:(length(y)+tau(itau)));
        end
        Tz = fft(z,2^11);
        R(itau,:) = fftshift(Tz);
    end
    D = D+R;
end

D = sum(abs(D).^2,1);
Freq = (0:(length(D)-1))/length(D)-1/2;
