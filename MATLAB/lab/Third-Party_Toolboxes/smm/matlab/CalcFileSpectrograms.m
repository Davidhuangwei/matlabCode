function CalcFileSpectrograms(fileBaseCell,fileExt,nChan,winLength,Fs,nFFT,nOverlap,NW,varargin)
spectDir = DefaultArgs(varargin,{'spectrograms/'});
%spectDir = 'spectrograms/';

for i=1:length(fileBaseCell)    
    for j=1:nChan
        
        data = readmulti([fileBaseCell{i} '/' fileBaseCell{i} fileExt],nChan,j);
        
        [yo, fo, to] = mtpsg(data',nFFT,Fs,winLength,nOverlap,NW);
        
        outDir = [fileBaseCell{i} '/' spectDir];
        if ~exist(outDir,'dir')
            mkdir(outDir);
        end
        outName = [outDir fileBaseCell{i} fileExt 'Win' ...
            num2str(winLength) 'Ovrlp' num2str(nOverlap) 'NW' num2str(NW) ...
            '_mtpsg_' num2str(j) '.mat'];
        %
        %outName = ['junk_samp_Chan' num2str(j) '_MTPSG.mat'];
        %outNameCell = cat(1, outNameCell, {outName});
        fprintf('Saving: %s\n',outName);
        save(outName,SaveAsV6,'yo','fo','to','winLength','Fs','nFFT','nOverlap','NW');
%         matlabVersion = version;
%         if str2num(matlabVersion(1)) > 6
%             save(outName,'-V6','yo','fo','to','winLength','Fs','nFFT','nOverlap','NW');
%         else
%             save(outName,'yo','fo','to','winLength','Fs','nFFT','nOverlap','NW');
%         end
    end
end


return


yo2 = [];
load junk_samp0-20000_MTPSG.mat
yo2 = cat(2,yo2,yo);
load junk_samp19354-39354_MTPSG.mat
yo2 = cat(2,yo2,yo);
load junk_samp38708-58708_MTPSG.mat
yo2 = cat(2,yo2,yo);               
load junk_samp58062-78062_MTPSG.mat
yo2 = cat(2,yo2,yo);               
load junk_samp77416-97416_MTPSG.mat
yo2 = cat(2,yo2,yo);               
load junk_samp96770-100000_MTPSG.mat
yo2 = cat(2,yo2,yo);


load junk_samp0-100000_MTPSG.mat
