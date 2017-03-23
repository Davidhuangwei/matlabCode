function calcAndSaveSpectrogram2(filebase,fileext,nchannels,channelNums,Fs,nFFT,WinLength,NW,trialsPerFile) 
 
nextStop = 0;
count = 0;

if ~exist('trialsPerFile', 'var') | isempty(trialsPerFile)                                                 
    trialsPerFile = 1000;                                                                                  
end                                                                                                        
                                                                                                           
bps = 2; % bytes per sample                                                                                
                                                                                                           
whldat = load([filebase '.whl']);                                                                          
[whlm n] = size(whldat);                                                                                   
                                                                                                           
infoStruct = dir([filebase fileext]);                                                                      
eegm = infoStruct.bytes/nchannels/bps;                                                                     
                                                                                                           
eegWhlFactor = eegm/whlm;                                                                                  
yData = [];                                                                                                
for i=1:whlm  
    count = count +1;
    fprintf('#%i:%i-%i,',count,max(0,round(eegWhlFactor*i-WinLength/2)),max(0,round(eegWhlFactor*i-WinLength/2))+WinLength);
    eegData = bload([filebase fileext],[nchannels WinLength],max(0,nchannels*round(eegWhlFactor*i-WinLength/2)*bps),'int16');
    if nextStop <= max(0,round(eegWhlFactor*i-WinLength/2)) 
        plot(eegData(33,:))
        keyboard
       yChan = [];                                                                                            
    for j=1:length(channelNums)                                                                            
        [y f] = mtcsd(eegData(channelNums(j),:),nFFT,Fs,WinLength,0,NW);                                   
        f = f(find(f<150));                                                                                
        y = y(1:length(f));                                                                                
        yChan = [yChan y];                                                                                 
    end                                                                                                    
    yData = cat(3,yData,yChan);                                                                            
    if mod(i,trialsPerFile) == 0;                                                                          
        outFileName = [filebase fileext '_SpectraPerPos'  num2str(i+1-trialsPerFile) '-' ...               
            num2str(i) '_Win' num2str(WinLength) '_NW' num2str(NW) '.mat'];                      
        fprintf('\nSaving %s', outFileName);         
        save(outFileName, 'yData', 'f', 'channelNums');                       
        yData = [];                                                                                        
    end  
    end
end                                                                                                        
outFileName = [filebase fileext '_SpectraPerPos'  num2str(whlm+1-mod(whlm,trialsPerFile)) '-' ...          
    num2str(whlm) '_Win' num2str(WinLength) '_NW' num2str(NW) '.mat'];                   
fprintf('\nSaving %s', outFileName);                   
save(outFileName, 'yData', 'f', 'channelNums');