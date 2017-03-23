%
function OutArgs = GammaCompSFP(FileBase, varargin)
Par = LoadPar([FileBase '.xml']);
[Channels,IfTetrode, Info] = RepresentChan(FileBase); % use this in the

[fMode,States, FreqRange] = DefaultArgs(varargin,{'erppca',{'REM','RUN'},[20 200]});

switch fMode



case 'compute'
      %  GammaSpecs(FileBase,'compute');
        nPCA=20;
        if FileExists([FileBase '.' mfilename '.mat'])
            load([FileBase '.' mfilename '.mat']);
        end
%        [Channels,IfTetrode, Info] = RepresentChan(FileBase);
        wcnt=1;
        nCh = length(Channels);

        for w = 1:length(States) %loop through states
           if ~FileExists([FileBase '.sts.' States{w}]) continue; end
           
            SubSet = [3 3];
            [y,t,f]= LoadSpecs(FileBase,States{w},[],[],SubSet);     %CHANGE HERE
       
             load([FileBase '.thpar.mat'],'ThPh');
             ts = round(t*Par.lfpSampleRate);
             tph = ThPh(ts);
             [hst BinInd] = histcI(tph,linspace(-pi,pi,nPhBins+1));

            keybaord
            
            nf = length(f);
            y = reshape(y,size(y,1),[]);
            [LU, LR, FSr , VT] = erpPCA(y,nPCA,20,1e-2);
            %            keyboard
            OutArgs.erppca(wcnt).eigval = VT(1:nPCA,:);
            OutArgs.erppca(wcnt).FSr = FSr(:,1:nPCA);
            OutArgs.erppca(wcnt).eigvecu = reshape(LU(:,1:nPCA),[nf, nCh, nPCA]);
            OutArgs.erppca(wcnt).eigvecr = reshape(LR(:,1:nPCA),[nf, nCh, nPCA]);
            OutArgs.erppca(wcnt).f = f;
            OutArgs.erppca(wcnt).t = t;
            clear('LU','LR','FSr','VT');
            save([FileBase '.' mfilename '.mat'],'OutArgs');     
            wcnt=wcnt+1;
        end
       

end