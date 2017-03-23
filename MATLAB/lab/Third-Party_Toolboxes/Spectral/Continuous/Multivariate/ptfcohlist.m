function C_mat = ptfcohlist(X, tapers, sampling, dn, fk, pad, flag)



sX = size(X);
nt = sX(2);
nch = sX(1);

if nargin < 3 sampling = 1; end 
t = nt./sampling;
if nargin < 2 tapers = [t,5,9]; end 
if length(tapers) == 2
   n = tapers(1);
   w = tapers(2);
   p = n*w;
   k = floor(2*p-1);
   tapers = [n,p,k];
   disp(['Using ' num2str(k) ' tapers.']);
end
if length(tapers) == 3  
   tapers(1) = tapers(1).*sampling;  
   tapers = dpsschk(tapers); 
end
if nargin < 4 dn = n./10; end
if nargin < 5 fk = [0,sampling./2]; end
if length(fk) == 1
    fk = [0,fk];
end
if nargin < 6 pad = 2; end
if nargin < 7 flag = 0; end 

K = length(tapers(1,:)); 
N = length(tapers(:,1));
if N > nt error('Error: Tapers are longer than time series'); end

% Determine outputs
errorchk = 0;
if nargout > 3 errorchk = 1; end

dn = dn.*sampling;
nf = max(256, pad*2^nextpow2(N+1)); 
nfk = floor(fk./sampling.*nf);
nwin = floor((nt-N)./dn);           % calculate the number of windows
f = linspace(fk(1),fk(2),diff(nfk));

neid = PMI_Size;
eid = [1:neid];

id = 0; allsent = 0; iter = 1;
for ch1 = 2:nch  %  Looping across channels
    for ch2 = 1:ch1-1
        id = id+1;
        nodes(id,iter,:) = [ch1,ch2];
        % if status disp(['Node ' num2str(eid(id)) ' received command OK']); end
        if (ch1 == nch & ch2 == ch1-1)
            allsent = 1;
            neid = id;
        end
        %disp(['Allsent is ' num2str(allsent)]);
        if ((id == neid) | allsent)
            iter = iter + 1;
            id = 0;
        end
    end    
end

disp('Sending data and tapers to all nodes');
for id = 1:neid
    list = sq(nodes(id,:,:));
    status = PMI_Send2(eid(id),tapers);
    status = PMI_Send2(eid(id),X);
    status = PMI_Send2(eid(id),list);
end

dn = dn./sampling;

niter = size(nodes,2);
disp('Processing on nodes')
for id = 1:neid
    cmd = ['[cohtmp] = tfcohlist(X, list, tapers, ' num2str(sampling) ...
            ',' num2str(dn) ',[' num2str(fk(1)) ',' num2str(fk(2)) ...
            '],' num2str(pad) ',' num2str(flag) ');'];
    status = PMI_IEval(eid(id),cmd);
end

C_mat = zeros(nch,nch,nwin,diff(nfk));
        
disp('Collecting from nodes')
for Rid = 1:neid
    disp(['  Coherency list from Node ' num2str(Rid)]);
    [cohtmp] = PMI_Recv(eid(Rid),'cohtmp');
    whos cohtmp
    for n = 1:niter
        C_mat(nodes(Rid,n,1),nodes(Rid,n,2),:,:) = cohtmp(n,:,:);
        %C_mat(nodes(Rid,n,2),nodes(Rid,n,1),:) = conj(cohtemp(n,:));
    end
end

