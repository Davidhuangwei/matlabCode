% PlaceFieldStabilityView(FileBase, nParts, ...)
%
% divides the session into nParts parts, and plots a
% place field for each one.  Trailing arguments are passed
% to NuPlaceField

function PlaceFieldStabilityView(FileBase, nParts, varargin)

Res = load([FileBase '.res']);
Clu = LoadClu([FileBase '.clu']);
Whl = load([FileBase '.whl']);
Par = LoadPar([FileBase '.par']);

if nargin<2
	nParts = 2;
end

% make sure nWhl divides nParts
nWhl = size(Whl,1);

nWhl = nWhl-mod(nWhl,nParts);
Whl = Whl(1:nWhl,:);

ResBlock = nWhl*512/nParts;
WhlBlock = nWhl/nParts;

c = 1;
while 1
	i = input('Cluster number? (return for next)');
	if isempty(i)
		c = c+1;
        if (c>max(Clu)) break; end
        fprintf('Cluster %d\n', c);            
	else
		c = i;
	end

	for p=1:nParts
		MyRes = Res(find(Clu==c & Res>=(p-1)*ResBlock & Res<p*ResBlock))-(p-1)*ResBlock;
        MyWhl = Whl(1+(p-1)*WhlBlock:p*WhlBlock,:);
        [PF(:,:,p) OcMap(:,:,p)] = NuPlaceField(MyRes, MyWhl, varargin{:});
	end

    % put on a common scale
    TopRate = max(PF(find(OcMap>1)));
    for p=1:nParts
		subplot(nParts, 1, p);
        PFPlot(PF(:,:,p), OcMap(:,:,p), TopRate);
    end        
end
