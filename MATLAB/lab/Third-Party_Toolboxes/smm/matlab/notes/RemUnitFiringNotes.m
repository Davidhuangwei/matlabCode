
newSamp = 4
filt = gausswin(newSamp*2);
sumRes = [];
count = [];
temp = dir('sm9603m2_232_s1_276.eeg');
nSamp = temp.bytes/97/2/1250*newSamp
types = LoadCellTypes('sm9603m2_232_s1_276.type');
layers = LoadCellLayers('sm9603m2_232_s1_276.cellLayer');
for j=1:size(types,1)
    res = load(['sm9603m2_232_s1_276.res.' num2str(types{j,1})]);
    clu = load(['sm9603m2_232_s1_276.clu.' num2str(types{j,1})]);
    res = res(clu(2:end)==types{j,2});
    res = round(res/20000*newSamp);
    resBin = hist(res,nSamp);
    if isstruct(sumRes) & IsBranch(sumRes,layers{j,3},types{j,3})
        sumRes.(layers{j,3}).(types{j,3}) = sumRes.(layers{j,3}).(types{j,3}) + ConvTrim(resBin,filt);
        count.(layers{j,3}).(types{j,3}) = count.(layers{j,3}).(types{j,3}) + 1;
    else
        sumRes.(layers{j,3}).(types{j,3}) = ConvTrim(resBin,filt);
        count.(layers{j,3}).(types{j,3}) = 1;
    end
end

sumResCell = Struct2CellArray(sumRes,[],1);
countCell = Struct2CellArray(count,[],1);
for j=1:length(sumResCell)
    subplot(length(sumResCell)+1,1,j);
    plot([1:length(sumResCell{j,end})]/newSamp,sumResCell{j,end});
    ylabel({[sumResCell{j,1} ', ' sumResCell{j,2}], ['n=' num2str(countCell{j,end})]});
    set(gca,'xlim',remTime)
    set(gca,'xtick',round([remTime(1):10:remTime(2)]))
    grid on
end
load('sm9603m2_232_s1_276SelChanWPSpec.eeg.mat');
subplot(length(sumResCell)+1,1,length(sumResCell)+1);
imagesc(t,f,10*log10(y(:,:,5))');
    set(gca,'xlim',remTime)
    set(gca,'xtick',round([remTime(1):10:remTime(2)]))
grid on

