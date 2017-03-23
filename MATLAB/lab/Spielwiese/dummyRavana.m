function dummyRavana(FileBase)

load([FileBase '.sp.mat'],'-MAT')

%% prefered theta phase - overall
indx = find(spike.good);
PhH = myPhaseOfTrain(spike.ph(indx),spike.ind(indx),[],[],[],[],max(spike.ind));

save([FileBase '.phasestat'],'PhH')
