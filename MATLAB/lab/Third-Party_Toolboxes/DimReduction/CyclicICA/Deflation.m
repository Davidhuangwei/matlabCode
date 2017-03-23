function [Source,Contribution] = Deflation(y,Param,FreqCycl)

% [Source,Contribution] = Deflation(x,Param,FreqCycl)
%
% Input parameters :
% ------------------
%
% x containts the mixture
% Param contains the algorithm parameters (see below)
% FreqCycl is an array that containt the cyclic frequencies >0 (see below)
%
% Output :
% --------
%
% Source : array containing a filtered version of the source signals. 
% Contribution : an (Nb_Source x NbSensor x ?) array containing the
% contribution of each source signal on each sensor.
%
% Algorithm :
% -----------
%
% The algorithm perform an estimation of the number of source signals
% contributing to the mixture.
%
% Works for :
%
% - instantaneous mixture of stationnary sources
% - convolutive mixtures of stationnary sources
% - Some instantaneous mixture of cyclostationnary sources (see below)
% - Some convolutive mixtures of cyclo-stationnary sources (see below)
%
% About the Param structure :
% ---------------------------
%
% The algorithm is piloted with a Param structure:
%
% Use function GenerateParamaters to help filling the structure
% with a form or functions InstantaneousMixtureParameters and
% ConvolutiveMixtureParameters to do it quickly:
%
% For example, you can call the function with:
%
% [Source,Contribution] = Deflation(x,InstantaneousMixtureParameters)
% [Source,Contribution] = Deflation(x,ConvolutiveMixtureParameters)
% [Source,Contribution] = Deflation(x,MyParameters) (see function GenerateParamaters) 
% [Source,Contribution] = Deflation(x)
%
% About the cyclic frequencies :
% ------------------------------
%
% see http://www-syscom.univ-mlv.fr/~jallon/toolbox.php for more
% information.
%
% If you don't know what to do, we recommend you to not pass a third argument.
%
%
% Author information :
% ---------------------
%
% Author : Pierre JALLON
% Contact : pierre.jallon@univ-mlv.fr
%
% Date of creation : 04/22/2005
% Date of last modification : 04/25/20005
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters test and initialization :
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (nargin==0)
    disp('You need to pass the mixture as a parameter');
    exit;    
end

if (nargin==1)
    Param = GenerateParamaters;
    FreqCycl = [];
end

if (nargin==2)
    FreqCycl = [];
end


if (size(y,1)>size(y,2))
    y = y.';    
end

% Source signals have to be centered !
for (iy=1:size(y,1))
    y(iy,:) = y(iy,:) - mean(y(iy,:));
end

addpath(sprintf('%s/SourceExtraction/',pwd));
addpath(sprintf('%s/SourceSubstraction/',pwd));

StillSource = true;
iExtractedSource = 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Deflation procedure :
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MixturePower = sum(sum(abs(y).^2));
iDetectedSource = 1;

% Variables for conguate gradient algorithm
Direction = 0;
OldGradNorm = 1;

while(StillSource)    
    
    fprintf('Extracting source %d...\n',iDetectedSource);
    
    % SISO Filter initialization
    g = zeros(Param.LFilter,size(y,1));
    g(iExtractedSource,size(y,1)) = 1;
    
    % Extracting one source signal :
    Newg = zeros(Param.LFilter,size(y,1));
    Newg(iExtractedSource,1) = 1;
    
    clear J;
    
    iIteration = 1;
    while (and(iIteration<floor(Param.NbIterationMax),sqrt(sum(sum(abs(Newg-g).^2))/ sum(sum(abs(g).^2)))>Param.Seuil ))
    %while (iIteration<floor(Param.NbIterationMax))
        g = Newg;
	    r = ComputeSignal(g,y);
	    g = g./sqrt(mean(abs(r).^2));
	
	    if (isreal(y)==1)
            % Gradient algorithm    
            [grad] = ComputeGradientR(g,y,FreqCycl);
            [Step] = ComputeOptimalStepR(ComputeSignal(g,y),ComputeSignal(grad,y),FreqCycl);
            Newg = g+Step*grad;                
        else
            % Gradient algorithm    
            [grad] = ComputeGradient(g,y,FreqCycl);
            [Step] = ComputeOptimalStep(ComputeSignal(g,y),ComputeSignal(grad,y),FreqCycl);
            Newg = g+Step*grad;
        end    
        iIteration = iIteration+1;
    end
    
    fprintf('Cancelling its contribution ...\n');
    % Cancelling the extracted source contribution :
    [ContributionEst,FiltreExtTemp] = SubstractSource(y,ComputeSignal(g,y),Param.LSubstractFiltreAC,Param.LSubstractFiltreC);
    %ContributionEst = permute(ContributionEst,[2,1]);
 
    % Save Extracted Source:
    Source(iDetectedSource,:) = ComputeSignal(g,y);
    Contribution(iDetectedSource,:,:) = permute(ContributionEst,[3 1 2]);
    
    % Updating mixture
    y = y-ContributionEst;

   
    % Still source ?
    NewMixturePower = sum(sum(abs(y).^2));
        
    if (NewMixturePower/MixturePower<Param.SeuilStopAlgo) 
        StillSource = false;
    elseif (iDetectedSource==(size(y,1)-1))
        StillSource = false;
        Contribution(size(y,1),:,:) = permute(y,[3 1 2]);
        Source(size(y,1),:) = y(1,:);
    else
        iDetectedSource = iDetectedSource+1;
    end
    
    if (iDetectedSource>size(y,1))
        StillSource = false;
    end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cleaning : 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rmpath(sprintf('%s/SourceExtraction/',pwd));
rmpath(sprintf('%s/SourceSubstraction/',pwd));

