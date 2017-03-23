betaClimCell = {[0.2 0.8],[-3.5e-3 3.5e-3],[-7.5e-4 7.5e-4],[-0.07 0.07],[-0.07 0.07],[-0.07 0.07],[-0.07 0.07]}
betaClimCell = {[0.2 0.8],[-3.5e-3 3.5e-3],[-7.5e-4 7.5e-4],[-0.05 0.05],[-0.05 0.05]}
betaClimCell = {[0.2 0.8],[-0.04 0.04],[-0.04 0.04]}
nonSigSat = 1;
nonSigVal = 1;
nextFig = 3;

print('-dpsc',['/u12/smm/public_html/NewFigs/MazePaper/New01/CohPVal' analRoutine '_01.ps'])

nonSigSatMat = [0.3 0.4 0.5 0.6 1];
for aa=1:length(nonSigSatMat)
    nonSigSat = nonSigSatMat(aa);
    nonSigVal = nonSigSatMat(aa);

    plotData = dataStruct.coeffs;
    titlesExt = 'transBeta';
    colorLimits = [betaClimCell];
    [mu stDev pVal] = GlmResultsCalcMuStdP(plotData);
    transMu = GlmResultsUnTransform(mu,depVarType);
    mu = GlmResultsAddConst(transMu,-0.5);
    mu.Constant = transMu.Constant;
    LocalImageHelper(nextFig,mu,betaPval,fileName,titlesExt,anatNames,selChanNames,colorLimits,statAlpha,nonSigSat,nonSigVal);
    print('-dpsc',['/u12/smm/public_html/NewFigs/MazePaper/New01/CohBeta' analRoutine num2str(nonSigSatMat(aa)) '_01.ps'])
end

