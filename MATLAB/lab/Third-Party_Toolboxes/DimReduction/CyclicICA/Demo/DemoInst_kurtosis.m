function [] = DemoInst_kurtosis()

% [] = DemoInst()
%
% This script has been written to test the separation
% of instantaneous mixture of cyclostationnary sources.
%
% The generated mixture has:
% 3 source signals
% 5 sensors
%
% Author : Pierre JALLON
% Date of creation : 04/22/2005
% Date of last modification : 04/22/20005
%

while(1)
    
    disp('Computing instantaneous mixture...');
    if exist(sprintf('%s/MixtureGeneration/',pwd))
        addpath(sprintf('%s/MixtureGeneration/',pwd));
    end
    if exist(sprintf('%s/Demo/MixtureGeneration/',pwd))
        addpath(sprintf('%s/Demo/MixtureGeneration/',pwd));
    end
    
    [Obs,Contribution] = DoMixture(InstantaneousMixture);
    
    if exist(sprintf('%s/MixtureGeneration/',pwd))
        rmpath(sprintf('%s/MixtureGeneration/',pwd));
    end
    if exist(sprintf('%s/DemoMixtureGeneration/',pwd))
        rmpath(sprintf('%s/Demo/MixtureGeneration/',pwd));
    end
    
    disp('Performing source separation...');
    [Source,ContributionEst] = Deflation(Obs,InstantaneousMixtureParameters);
    
    fprintf('Detected number of source in the mixture %d\n',size(Source,1));
    
    if exist(sprintf('%s/EstimeSeparationPerfs/',pwd))
        addpath(sprintf('%s/EstimeSeparationPerfs/',pwd));
    end
    if exist(sprintf('%s/Demo/EstimeSeparationPerfs/',pwd))
        addpath(sprintf('%s/Demo/EstimeSeparationPerfs/',pwd));
    end
    
    for (iContribution = 1:size(Contribution,1))
        [iSourceExtraite,MSE(iContribution)] = CalculCritere(Contribution,permute(ContributionEst(iContribution,:,:),[2 3 1]));
    end
    if exist(sprintf('%s/Demo/EstimeSeparationPerfs/',pwd))
        rmpath(sprintf('%s/Demo/EstimeSeparationPerfs/',pwd));
    end
    if exist(sprintf('%s/EstimeSeparationPerfs/',pwd))
        rmpath(sprintf('%s/EstimeSeparationPerfs/',pwd));
    end
    fprintf('Mean of the mean square error between the contribution of each source and its estimated version %1.4f\n',mean(MSE));
    fprintf('\nStrike any key for a different mixture\n');pause;
    
end