function [Symboles] = SymbolesGenerator(Source)

% Génére une suite de symbole pour la modulation utilisée

% Initialisation si modulation pas trouvée.
Valeur = 0;
if (strcmp(Source.Constellation,'QPSK')==1)
    u=0:3;
    Valeur = [exp(2*i*pi*((2*u+1)/8))];
elseif (strcmp(Source.Constellation,'8-PSK')==1)
    u=0:7;
    Valeur = [exp(2*i*pi*((2*u+1)/16))];
elseif (strcmp(Source.Constellation,'16-PSK')==1)
    u=0:15;
    Valeur = [exp(2*i*pi*((2*u+1)/32))];
elseif (strcmp(Source.Constellation,'4-QAM')==1)
    Valeur = [-1-i -1+i 1-i 1+i];
    Valeur = Valeur(:);
elseif (strcmp(Source.Constellation,'16-QAM')==1)
    N = sqrt(16);
    ValeurX = ones(N,N);
    ValeurY = ones(N,N);
    for (k=1:N)
        ValeurX(k,:) = (-N+1):2:(N-1);
        ValeurY(:,k) = ((-N+1):2:(N-1))';
    end
    Valeur = ValeurX+i*ValeurY;
    Valeur = Valeur(:);
elseif (strcmp(Source.Constellation,'64-QAM')==1)
    N = sqrt(64);
    ValeurX = ones(N,N);
    ValeurY = ones(N,N);
    for (k=1:N)
        ValeurX(k,:) = (-N+1):2:(N-1);
        ValeurY(:,k) = ((-N+1):2:(N-1))';
    end
    Valeur = ValeurX+i*ValeurY;
    Valeur = Valeur(:);
elseif (strcmp(Source.Constellation,'256-QAM')==1)
    N = sqrt(256);
    ValeurX = ones(N,N);
    ValeurY = ones(N,N);
    for (k=1:N)
        ValeurX(k,:) = (-N+1):2:(N-1);
        ValeurY(:,k) = ((-N+1):2:(N-1))';
    end
    Valeur = ValeurX+i*ValeurY;
    Valeur = Valeur(:);
elseif (strcmp(Source.Constellation,'1024-QAM')==1)
    N = sqrt(1024);
    ValeurX = ones(N,N);
    ValeurY = ones(N,N);
    for (k=1:N)
        ValeurX(k,:) = (-N+1):2:(N-1);
        ValeurY(:,k) = ((-N+1):2:(N-1))';
    end
    Valeur = ValeurX+i*ValeurY;
    Valeur = Valeur(:);
elseif (strcmp(Source.Constellation,'4096-QAM')==1)
    N = sqrt(4096);
    ValeurX = ones(N,N);
    ValeurY = ones(N,N);
    for (k=1:N)
        ValeurX(k,:) = (-N+1):2:(N-1);
        ValeurY(:,k) = ((-N+1):2:(N-1))';
    end
    Valeur = ValeurX+i*ValeurY;
    Valeur = Valeur(:);
elseif (strcmp(Source.Constellation,'BPSK')==1)
   Valeur = [-1 1];
elseif (strcmp(Source.Constellation,'4-PAM')==1)
    u=0:3;
    Valeur = (2*u-3);
elseif (strcmp(Source.Constellation,'6-PAM')==1)
    u=0:5;
    Valeur = (2*u-5);
elseif (strcmp(Source.Constellation,'x-PAM')==1)
   Valeur = [-1 1 -10 10 -30 30];
   b = Valeur(ceil(length(Valeur)*rand(1,NbSymbole)));
elseif (strcmp(Source.Constellation,'CPM')==1)
   Valeur = [-1 1];
end
Symboles = Valeur(ceil(length(Valeur)*rand(1,Source.NbSymbole)));

