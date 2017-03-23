function FileInterpCSDInterp(fileBaseCell,nChan,interpMethod,csdSmooth,extrapEegBool)
% function FileInterpCSDInterp(fileBaseCell,nChan,interpMethod,csdSmooth,extrapEegBool)
if ~exist('extrapEegBool') | isempty(extrapEegBool)
    extrapEegBool = 1;
end    

bps = 2; % bytes per sample
fileExt = '.eeg';
chanInfoDir = 'ChanInfo/';
chanMat = LoadVar([chanInfoDir 'ChanMat' fileExt '.mat'])
badChans = load([chanInfoDir 'BadChan' fileExt '.txt'])
if csdSmooth ~= 0
    csdChanMat = LoadVar([chanInfoDir 'ChanMat_' interpMethod 'CSD' RmTextSpaces(num2str(csdSmooth)) '.csd.mat'])
    csdBadChans = load([chanInfoDir 'BadChan_' interpMethod 'CSD' RmTextSpaces(num2str(csdSmooth)) '.csd.txt'])
end
% if csdSmooth == 1
%     csdBadChans = load([chanInfoDir 'BadChan_' interpMethod 'CSD' RmTextSpaces(num2str(csdSmooth)) '.csd.txt']);
% else
%     csdBadChans = [];
% end

for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j};
    fprintf('Processing: %s\n',fileBase);
    outDir = [fileBase '/'];
    eegFile = [fileBase '/' fileBase fileExt];

    interpFile = fopen([outDir fileBase '_' interpMethod fileExt],'w');
    if interpFile == -1,
        FILE_DIDNT_OPEN
    end
    
    if csdSmooth ~= 0
        csdFile = fopen([outDir fileBase '_' interpMethod 'CSD' RmTextSpaces(num2str(csdSmooth)) '.csd'],'w');
        if csdFile == -1,
            FILE_DIDNT_OPEN
        end
    end
    infoStruct = dir(eegFile);
    numSamples = infoStruct.bytes/nChan/bps;

    chunkSize = 2^floor(log2(6000000/nChan/bps)); % up to 60MB buffer (divisible by nchannels)
    for i=0:chunkSize:numSamples-1
        eegData = bload(eegFile,[nChan chunkSize],i*nChan*bps,'int16');

        switch interpMethod
            case 'NearAve'
                interpEEG = InterpNearAve1D(eegData,chanMat,badChans);
            case 'LinNear'
                
                interpEEG = InterpLinExtrapNear(eegData,chanMat,badChans,extrapEegBool);
            otherwise
                write_more_code
        end
        
        if csdSmooth ~= 0
            csdData = CSD1D(interpEEG,mat2cell(chanMat,size(chanMat,1),repmat(1,size(chanMat,2),1)),csdSmooth);

            switch interpMethod
                case 'NearAve'
                    interpCSD = InterpNearAve1D(csdData,csdChanMat,csdBadChans);
                case 'LinNear'
                    interpCSD = InterpLinExtrapNear(csdData,csdChanMat,csdBadChans);
                otherwise
                    write_more_code
            end
            fwrite(csdFile,interpCSD,'int16');
        end
        
        fwrite(interpFile,interpEEG,'int16');
    end

    if fclose(interpFile)
        FILE_DIDNT_CLOSE
    end
    if csdSmooth ~= 0
        if fclose(csdFile)
            FILE_DIDNT_CLOSE
        end
    end
end
return
