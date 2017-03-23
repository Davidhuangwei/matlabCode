junk = MatStruct2StructMat(yNormPs);
fields = fieldnames(junk);
for i=1:length(fields)
subplot(1,length(fields),i);
imagesc(log10(Make2DPlotMat(junk.(fields{i}),MakeChanMat(6,16))));
set(gca,'clim',log10([.01 1]));
colorbar
end




1:numYvar

n2comb = nchoosek(1:numYvar,2)
for i=1:size(n2comb,1)
    if le
        

junk2 = [];
depDataSize = 36;
nGroups = 4;
for i=1:4
    junk{i} = depData(1+depDataSize*(i-1):depDataSize*i);
    junk{i} = junk{i} - median(junk{i});
    junkVar(i) = var(junk{i});
    junk2 = cat(1,junk2,junk{i});
end

sampVar =[];
sampVarVar = [];
for i=1:1000
    for j=1:nGroups
        sampVar(j) = var(randsample(junk2,depDataSize));
    end
    sampVarVar(i) = var(sampVar);
end
hist(sampVarVar)
length(find(sampVarVar<var(junkVar)))/length(sampVarVar)


sampVar =[];
for i=1:1000
        sampVar(i) = var(randsample(junk2,depDataSize));
end
hist(sampVar)
for i=1:nGroups
    z(i) = abs(mean(junkVar(i)-sampVar)/std(sampVar));
end
z


