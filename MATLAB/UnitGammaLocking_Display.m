function UnitGammaLocking_Display(FileBase)

if ~FileExists([FileBase '.UnitGammaLocking.mat'])
    FileBase = ResolvePath(FileBase);
end
% case {'display', 'select'}
load([FileBase '.UnitGammaLocking.mat']);
%  Map = MapSilicon(x,Channels,ChInShank)
par = LoadXml([FileBase '.xml']);
Channels = RepresentChan(par); %Out(1).Channels;
nChannels = length(Channels);
Map = SiliconMap(par);
ChMap = Map.GridCoord(ismember(Map.Channels,Channels),:);
CluLoc = ClusterLocation(FileBase);
nStates = length(Out);

%initial positions
Chi = 1; Fi=50; Ti = 10; 
for k=1:length(Out)
    if isempty(Out(k).Map)
        continue;
    end
    gState(k)=1;
end
Sti = find(gState,1, 'first');
Ui = Out(Sti).Map(1,1);


RType='Rhlb'; %1 -Ramp, 2- MI
getpos=0; % initially we do not wait for the click
pFilter=0; % no p-value threshold 
MaskNeuronShank=1;
myFig = figure(669);
set(myFig, 'WindowButtonDownFcn', @figupdate);
set(myFig, 'KeyPressFcn', @varupdate);
myh=[]; %array of axis handles
DoCsd=0;
figupdate();

    function figupdate(varargin)
       % global DoCsd;
        
        figure(myFig);
        
        % need to display:
        % ch x f      ch x tlag
        % tlag x f    map
        %myh
        if getpos
            [axN figN axH figH] = WhereIClicked;
            axN = find(myh==axH);
            whatbutton = get(gcf,'SelectionType');
            mousecoord = get(gca,'CurrentPoint');
            x=mousecoord(1,1); y = mousecoord(1,2);
            switch axN
                case {1,6,7} % ch x f
                    [~, Chi] = min(abs([1:nChannels]-round(y)));
                    [~, Fi] = min(abs(Out(Sti).f-x));
                    
                case 3 %t x ch
                    [~, Chi] = min(abs([1:nChannels]-round(y)));
                    [~, Ti] = min(abs(Out(Sti).t-x));
                    
                case {2,9} %f x t
                    [~, Ti] = min(abs(Out(Sti).t-y));
                    [~, Fi] = min(abs(Out(Sti).f-x));
                    
                case {4,5,8}  % Map for all channels at given freqs
                    [~, Chi] = min((ChMap(:,1)-x).^2+(ChMap(:,2)-y).^2);
                    fprintf('Current channel %d\n',Channels(Chi));
            end
        end
        
        
        %compute some vars used further
        Ci = find(ismember(Out(Sti).Map(:,2:3),CluLoc(Ui,1:2),'rows'));
    %    fprintf('Ui=%d, Ci=%d,\n', Ui, Ci);
    
        ChWithUnit = CluLoc(Ui,3);
        CellEl = CluLoc(Ui,1);
        CellStr = par.SpkGrps(CellEl);
        CellCh = CellStr.Channels+1;
        ShankChWithUnit = ismember(Channels, CellCh);
        
        CellPos = Map.GridCoord(CluLoc(Ui,3),:);
        
        DataString = [FileBase ' ' Out(Sti).State ' Electrode ' ...
            num2str(CluLoc(Ui,1)) ', Clu ' num2str(CluLoc(Ui,2)) ', n=' num2str(Out(Sti).nSpikes(Ci))];
        set(myFig,'NumberTitle','off','Name',['UnitGammaLocking : ' DataString]);
        
        
        mat = sq(Out(Sti).(RType)(:,:,:,Ci));
        
        if DoCsd 
            matcsd = nan(size(mat));
            for sh=1:6
                chi = find(ismember(Channels, [1:16]+(sh-1)*16));
                if isempty(chi) continue; end
                matcsd(chi(2:end-1),:,:) = diff(mat(chi,:,:),2)*i;
            end
            mat = matcsd;
        end
        p = r2pval(abs(mat),Out(Sti).nSpikes(Ci));
        MaskChannels = ShankChWithUnit & ismember(Channels, CluLoc(Ui,3)+[-3:3]');
        
        %mask bad channels from ChanInfo/BadChan.eeg.txt
        if FileExists('ChanInfo/BadChan.eeg.txt')
            BadCh = load('ChanInfo/BadChan.eeg.txt');
            MaskChannels = MaskChannels | ismember(Channels, BadCh);
        end
        
       % MaskNeuronShank
        if MaskNeuronShank
            mat(MaskChannels, :, :) = NaN;
        end
        mat(:,Out(Sti).f<25,:)=NaN;
        
        if pFilter
            % control for FDR
            Id2Test = find(~isnan(mat));
            q = 0.05;
            
            [ToReject crit_p] = fdr_bh(p(Id2Test),q,'pdep','no');
            mat(Id2Test(ToReject==0))=NaN;
            %mat(p>0.05)=NaN;    
        end
        
        
        %now do the plots
        nrow=3; ncol=3;
        
        clf
        myh(1) = subplot2(nrow,ncol,1,1); % 1: ch x f , for ti
        imagesc(Out(Sti).f,[1:nChannels], abs(sq(mat(:,:,Ti)))); axis xy; colorbar
        xlabel('f'); ylabel('Channels');
        hold on
        plot( Out(Sti).f(Fi),Chi,'ko');
        LineCross(Out(Sti).f(Fi),Chi,'w',[],2);
        title(RType);
        
        myh(2) =subplot2(nrow,ncol,2,1); % 2: t x f
        imagesc(Out(Sti).f,Out(Sti).t, abs(sq(mat(Chi,:,:)))'); axis xy; colorbar
        xlabel('f'); ylabel('time lag');
        hold on
        plot( Out(Sti).f(Fi), Out(Sti).t(Ti),'ko');
        LineCross(Out(Sti).f(Fi),Out(Sti).t(Ti),'w',[],2);
        title([RType ' Fi= ' num2str(Fi) ' ,Ti=' num2str(Ti)]);
        
        myh(3) =subplot2(nrow,ncol,1,2); % 3: ch x t
        imagesc(Out(Sti).t,[1:nChannels], abs(sq(mat(:,Fi,:)))); axis xy; colorbar
        xlabel('time lag'); ylabel('Channels');
        hold on
        plot(  Out(Sti).t(Ti),Chi, 'ko');
        LineCross(Out(Sti).t(Ti),Chi,'w',[],2);
        title(RType);
        
        myh(4) =subplot2(nrow,ncol,2,2); % 4: R map
        MapSilicon(abs(sq(mat(:,Fi, Ti))), [], par,[],0,[],0,[],1);
        xlabel('ML'); ylabel('DV');
        hold on
        plot(ChMap(Chi,1),ChMap(Chi,2),'ko');
        LineCross(ChMap(Chi,1),ChMap(Chi,2),'w',[],2);
        hpt = plot(CellPos(1), CellPos(2), 'ko','MarkerSize',20);
        title([RType ' Map , Chi = ' num2str(Chi)]);
        
        myh(5) =subplot2(nrow,ncol,2,3); % 5: phase map
        %         sigmask = double(sq(Out(Sti).thgam.Rpval(fi,:))>0.01);
        %         sigmask(sigmask==1)=NaN;
        %         sigmask(sigmask==0)=1;
        MapSilicon(angle(sq(mat(:,Fi,Ti)))*180/pi, [], par,[],0,[-180 180],1,[],1);
        xlabel('ML'); ylabel('DV');
        hold on
        plot(ChMap(Chi,1),ChMap(Chi,2),'ko');
        LineCross(ChMap(Chi,1),ChMap(Chi,2),'w',[],2);
        hpt = plot(CellPos(1), CellPos(2), 'ko','MarkerSize',20);
        title('phase shift Map');
        
        
        myh(6) =subplot2(nrow,ncol,1,3); %6: phase ch x f
        imagescnan({Out(Sti).f,[1:nChannels], angle(sq(mat(:,:,Ti)))*180/pi}, [-180 180], 1,1); axis xy
        xlabel('f'); ylabel('Channels');
        hold on
        plot( Out(Sti).f(Fi),Chi,'ko');
        LineCross(Out(Sti).f(Fi),Chi,'w',[],2);
        title('phase shift');
        
        try
        myh(7) =subplot2(nrow,ncol,3,1); %7: power ch x f
        imagesc(Out(Sti).f,[1:nChannels], sq(Out(Sti).AvPow(:,:,Ti,Ci))); 
        axis xy; colorbar
        xlabel('f'); ylabel('Channels');
        hold on
        plot( Out(Sti).f(Fi),Chi,'ko');
        LineCross(Out(Sti).f(Fi),Chi,'w',[],2);
        title('av. power');
        
        myh(8) =subplot2(nrow,ncol,3,2); %8: power map
        MapSilicon(sq(Out(Sti).AvPow(:,Fi,Ti,Ci)), [], par,[],0,[],0,[],1);
        xlabel('ML'); ylabel('DV');
        hold on
        plot(ChMap(Chi,1),ChMap(Chi,2),'ko');
        LineCross(ChMap(Chi,1),ChMap(Chi,2),'w',[],2);
        hpt = plot(CellPos(1), CellPos(2), 'ko','MarkerSize',20);
        title([ 'Power Map , Chi = ' num2str(Chi)]);
        
        
        myh(9) =subplot2(nrow,ncol,3,3); %9: power f x t
        imagesc(Out(Sti).f,Out(Sti).t, sq(Out(Sti).AvPow(Chi,:,:,Ci))'); axis xy; colorbar
        xlabel('f'); ylabel('time lag');
        hold on
        plot( Out(Sti).f(Fi), Out(Sti).t(Ti),'ko');
        LineCross(Out(Sti).f(Fi),Out(Sti).t(Ti),'w',[],2);
        title(['Power Fi= ' num2str(Fi) ' ,Ti=' num2str(Ti)]);
        end
        %% compute and plot maps of local minima in txf slices
        
%         for ch=1:nChannels
%            R =  abs(sq(mat(Chi,:,:))); %dim F x T
%            mins=[]; thr = 80;
%            while isempty(mins)
%             [mins minsv] = LocalMinimaN(-R, -prctile(R(:),thr), [5 5]);
%             thr = thr - 10;
%            end
%             % get closest to Ti, Fi
%            [~, CloseMinInd] = min(sum(bsxfun(@minus, mins, [Fi Ti]).^2,2));
%            MapMins(ch,:) = mins(CloseMinInd,:);
%            MapMinsVal(ch,:) = minsv(CloseMindInd);
%         end
%         
%         figure(889);clf
%         ny=1;nx=2;
%         subplot2(ny,nx,1,1);
%         
       % 
        
       if getpos==0; getpos=1; end
        %        fstepPow=1; fstepPh=1;
    end

    function varupdate(varargin)
        % fprintf('entering varupdate\n');
        whatkey = get(myFig,'CurrentCharacter');
        switch double(whatkey)
            case double('s')
                % change state value
                if nStates==1
                    fprintf('just one state');
                else
                    StiOld = Sti;
                    while 1
                        Sti = Sti+1;
                        if Sti>nStates Sti=1; end
                        if isempty(Out(Sti).Map) continue; end
                        % now check if the cell is active in this state
                        myCi = find(ismember(Out(Sti).Map(:,2:3),CluLoc(Ui,1:2),'rows'));
                        if isempty(myCi)
                            fprintf('State %s has not enough spikes of current cell %d %d\n', ...
                                Out(Sti).State, CluLoc(Ui,1), CluLoc(Ui,2));
                            continue;
                        else
                            break;
                        end
                    end
                    if Sti ~= StiOld
                        fprintf('Current state %s\n',Out(Sti).State);
                        getpos=0;
                        figupdate();
                    end
                end
            case double('d')
                %change display
                if strcmp(RType,'Rhlb')
                    RType = 'Rph';
                else
                    RType = 'Rhlb';
                end
                getpos=0;
                figupdate();
            case 29 % next cell
                %fi = min(fi+1,length(Out(1).f));
                while 1
                    Ui = min(Ui+1, size(CluLoc,1));
                    myCi = find(ismember(Out(Sti).Map(:,2:3),CluLoc(Ui,1:2),'rows'));
                    if isempty(myCi)
                        for w=1:nStates
                            if isempty(Out(w).Map) continue; end
                            myCi = find(ismember(Out(w).Map(:,2:3),CluLoc(Ui,1:2),'rows'));
                            if ~isempty(myCi)
                                Sti=w;
                                getpos=0;
                                figupdate();
                                return;
                            end
                        end
                    else
                        break;
                    end
                end
                getpos=0;
                figupdate();
            case 28
                while 1
                    Ui = max(1, Ui-1);
                    myCi = find(ismember(Out(Sti).Map(:,2:3),CluLoc(Ui,1:2),'rows'));
                    if isempty(myCi)
                        for w=1:nStates
                            myCi = find(ismember(Out(w).Map(:,2:3),CluLoc(Ui,1:2),'rows'));
                            if ~isempty(myCi)
                                Sti=w;
                                getpos=0;
                                figupdate();
                                return;
                            end
                        end
                    else
                        break;
                    end
                end
                getpos=0;
                figupdate();
                
                % fi = max(1,fi-1);figupdate();
                
            case double('p')
                %apply p-valaue threshold
                if ~exist('pFilter','var') | pFilter==0
                    pFilter=1;
                else
                    pFilter=0;
                end
                getpos=0;
                figupdate();
            
            case double('c')
              %  global DoCsd
                if DoCsd==0
                   DoCsd=1;
                else
                    DoCsd=0;
                end
                getpos=0;
                figupdate();   
                
            case double('m')
                %apply p-valaue threshold
                if ~exist('MaskNeuronShank','var') | MaskNeuronShank==0
                    MaskNeuronShank=1;
                else
                    MaskNeuronShank=0;
                end
                getpos=0;
                figupdate();
            
            case double('e') 
                %export
                prteps(['UnitGammaLocking - ' DataString ' ' datestr(now)]);
                
            case double('u')
                % update the plot (for debugging)
                getpos=0;
                figupdate();
                
            case double('g')
                ElClu=inputdlg('Enter El Clu pair to display','El Clu',1);
                ElClu = str2num(ElClu{1});
                Ui = find(CluLoc(:,1)==ElClu(1) & CluLoc(:,2)==ElClu(2));
                getpos=0;
                figupdate();
                
            case double('b')
                LoadgData(FileBase, Out(Sti).State);
                UGL_Bursts(Chi, Out(Sti).f(Fi), Out(Sti).t(Ti), CluLoc(Ui,1:2));
            
            case double('l')
                LoadgData(FileBase, Out(Sti).State);
                UGL_LowFreq(Chi, Out(Sti).f(Fi), Out(Sti).t(Ti), CluLoc(Ui,1:2));
            
                
            case double('q');
                return;
                
        end
    end
end







