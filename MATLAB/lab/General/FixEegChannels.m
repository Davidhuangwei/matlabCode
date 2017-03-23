%function Eeg = FixEegChannels(Eeg, BadChannels, Method)
function Eeg = FixEegChannels(Eeg, BadChannels, Method)

if nargin<3 | isempty(nargin) Method ='spline'; end
   
nChannels = min(size(Eeg));
if (size(Eeg,1)>nChannels)
    Eeg = Eeg';
end
AllChannels = [1:nChannels];
GoodChannels = setdiff(AllChannels,BadChannels);

%Eeg = Eeg(GoodChannels,:);

Eeg(BadChannels,:) = interp1(GoodChannels(:), Eeg(GoodChannels,:),BadChannels(:), Method,'extrap');




    