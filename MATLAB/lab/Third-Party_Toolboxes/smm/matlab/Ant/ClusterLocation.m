%function Channels = ClusterLocation(FileBase, Electrodes, Overwrite)
% gives the channels that have max amplitude of the spike in each cluster
% for given electrodes (all by default - gives cell array)
% NB! Channels are from 1
% Channels and concent of FileBase.cluloc file are have 3 columns:
% ElecInd CluInd Channel from where cluster come 
function Channels = ClusterLocation(FileBase, varargin)

nMaxSpks = 1000000; %load just some spikes
Par = LoadPar([FileBase '.xml']);

[Electrodes,Overwrite] = DefaultArgs(varargin,{[1:Par.nElecGps],0});
nEl = length(Electrodes);
Channels = [];
 
if FileExists([FileBase '.cluloc']) & ~Overwrite
	if FileLength([FileBase '.cluloc'])==0
    	Channels = [];
    else
        Channels = load([FileBase '.cluloc']);
        Channels = Channels(ismember(Channels(:,1),Electrodes),:);
    end
    
    if nargout<1
       figure(212111);clf
       Map = SiliconMap(FileBase,[],[1 1]);
       chstr = num2str(Channels(:,1:2)); 
       [dummy ChanInd] = ismember(Channels(:,3),Map.Channels);
       rn = rand(length(ChanInd),1)-0.5;
       jittx(rn>0) = (0.1+rn(rn>0))*0.4*Map.Step(1);
       jittx(rn<0) = (-0.1+rn(rn<0))*0.4*Map.Step(1);
       rn = rand(length(ChanInd),1)-0.5;
       jitty(rn>0) = (0.2+rn(rn>0))*0.5*Map.Step(2);
       jitty(rn<0) = (-0.2+rn(rn<0))*0.5*Map.Step(2);
       
       if FileExists([FileBase '.celllayer'])
           clayer = load([FileBase '.celllayer']);
       else
           clayer = zeros(size(Channels,1),1);
       end
       cols = {'k','b','g','r'};
       for i=0:4
           ci = find(clayer == i);
           if ~isempty(ci)
               h = text(Map.Coord(ChanInd(ci),1)+jittx(ci)', Map.Coord(ChanInd(ci),2)+jitty(ci)', chstr(ci,:));
               set(h,'FontSize',5);
               set(h,'Color',cols{i+1});
           end
       end
       maxc = max(Map.Coord);
       minc = min(Map.Coord);

%       axis equal
       xr = (maxc(1)-minc(1));
       yr = (maxc(2)-minc(2));
       axis([minc(1)-0.1*xr maxc(1)+0.1*xr minc(2)-0.1*yr maxc(2)+0.1*yr]);
       set(gca,'YDir','reverse')
       
    end
else
	for i=1:nEl
		
		El = Electrodes(i);
%		Par1 = LoadPar1([FileBase '.par.' num2str(El)]);
		myChans = Par.ElecGp{El};
		nChannels = length(myChans);
		
		Clu = load([FileBase '.clu.' num2str(El)]);
		
		
		if length(Clu)>nMaxSpks
			nSpks = nMaxSpks;
			Clu = Clu(2:nSpks+1);
		else
			nSpks = Inf;
			Clu = Clu(2:end);
		end
		nClu = max(unique(Clu));
		
		if nClu>1 % not only noise
		
		%Spk(Channel, Sample, Spike Number)
		%Spk loading takes too much memory!!! 
		%FreeMemory
		%Spk = LoadSpk([FileBase '.spk.' num2str(El)],nChannels,32,nSpks);
		%FreeMemory
		
		% let's use features instead
		Fet = LoadFet([FileBase '.fet.' num2str(El)]);
		nPCs = (size(Fet,2)-5)/length(Par.ElecGp{El});
		for j=2:nClu
	%  		keyboard
			myInd = find(Clu==j);
			if ~isempty(myInd)
			%	myMeanSpk = sq(mean(Spk(:,:,myInd),3));
			%	MaxAmp = max(abs(myMeanSpk),[],2);
			%	[dummy MaxChan] = max(MaxAmp);
				myFet = Fet(myInd,:);
				%myFet = myFet(:,1:Par1.nPCs:end-5);
				
				myFet = myFet(:,1:nPCs:end-5);
				MeanAmp = mean(abs(myFet));
				[dummy MaxChan] = max(MeanAmp);
				Channels(end+1,:) = [i j myChans(MaxChan)+1]; % NB make channels number go from 1
			end
		end
		clear Fet Clu
		end
	end
	msave([FileBase '.cluloc'],Channels,'w');
end
%  if nEl==1
%  Channels =Channels{1};
%  end

