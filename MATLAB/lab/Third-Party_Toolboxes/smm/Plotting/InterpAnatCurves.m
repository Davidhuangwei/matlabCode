function InterpAnatCurves(sampResol)
%function InterpAnatCurves(sampResol)

if ~exist('sampResol','var') | isempty(sampResol)
    sampResol = 100;
end

load('AnatCurves.mat')
figure(1)
clf
hold on
for j=1:4
    newIndexes = 1:max(cumsum(round(cat(1,mean(sqrt(diff(anatCurves{j,1}).^2+diff(anatCurves{j,2}).^2)),...
        sqrt(diff(anatCurves{j,1}).^2+diff(anatCurves{j,2}).^2))*sampResol+1)));
    oldIndexes =       cumsum(round(cat(1,mean(sqrt(diff(anatCurves{j,1}).^2+diff(anatCurves{j,2}).^2)),...
        sqrt(diff(anatCurves{j,1}).^2+diff(anatCurves{j,2}).^2))*sampResol+1));

    newAnatCurves{j,1} = interp1(oldIndexes,anatCurves{j,1},newIndexes,'linear');
    newAnatCurves{j,2} = interp1(oldIndexes,anatCurves{j,2},newIndexes,'linear');
    
    plot(newAnatCurves{j,1}, newAnatCurves{j,2},'r.')
    plot(anatCurves{j,1},anatCurves{j,2},'.')

end
anatCurves = newAnatCurves;
in = input('Save AnatCurves.mat? y/n: ','s');
if strcmp(in,'y')
    save('AnatCurves.mat',SaveAsV6,'anatCurves');
end