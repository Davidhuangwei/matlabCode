function H = entropy(wt,U,V,Ss,St,a,b,pltfun)

% Evaluate entropy.

global s_factor t_factor wmin hmin K ncall st;

ncall=ncall+1;

% fprintf('entropy ...\n');
% Remake Wt.
[P K]=size(V);

Wt = reshape(wt,K,K);

% -------------------------------------------------------
% Get SPATIAL entropy.
% Find spatial un-mixing matrix Ws.
Ws = Wt'; % Wt2Ws(Wt);

% Find spatial ICs.
% ICs = Ws*U'; % Rows of ICs are ind spatial components.

sentropy = entropy1(Ws,U',Ss,a,b,pltfun);
% -------------------------------------------------------
% Get TEMPORAL entropy.
% Find temporal ICs.
% ICt = Wt*V'; 		
% Rows of ICt are ind. temporal components.

tentropy = entropy1(Wt,V',St,a,b,pltfun);
% -------------------------------------------------------

a = s_factor;
b = t_factor;

%H = a*sentropy  + b*tentropy;

st='st';
if st=='st' H = (sentropy + tentropy);end;
if st=='t'  H = (tentropy); end;
if st=='s'  H = (sentropy); end;

% Remember minimum
if H < hmin 
   wmin = wt;
   hmin = H;
end

% wmin=rand(size(wmin));
if rem(ncall,10)==0 | ncall==1
fprintf('sentropy=%.3f tentropy=%.3f tot=%.3f\n',sentropy,tentropy,sentropy+tentropy);
end;

% hplt_st;

