%function out = CCGSignif(Res,Clu,BinSize,HalfBins,SampleRate,PairsToTest,Normalization,Randomiz,Width,Periods)
% all CCG parameters are usual
% INPUT: 
%   PairsToTest - specifies the cluster numbers of pairs (per and post) to test
%   Randomiz - structure that contains infromation about randomization
%      procedure with fields Type, nRand, and other params needed for the
%        procedure
%   Type - 'shuffle' (to shuffle isi's of spike train) or 'jitter' (default)
%   nRand - number of randomizations
%   Width - if not 0 will do smooth (kernel) estimates of the CCGs where
%   Width is the kernel length in samples
%
% OUTPUT:
%    out.AvShufCCG

function out = myCCGSignif(Res,Clu,BinSize,HalfBins,SampleRate,PairsToTest,Normalization,varargin)
defRandomiz = struct('Type','shuffle','nRand',100);
[Randomiz, Width, Periods] = DefaultArgs(varargin,{defRandomiz,0,[]});
nPeriods = size(Periods,1);
nPairs = size(PairsToTest,1);

out.AvShufCCG = zeros(HalfBins*2+1,nPairs);
out.StdShufCCG = zeros(HalfBins*2+1,nPairs);
out.PvalShufCCG = zeros(HalfBins*2+1,nPairs);
out.CCG = zeros(HalfBins*2+1,nPairs);
out.smCCG = zeros(HalfBins*2+1,nPairs);

for p=1:nPairs
    Res1 = Res(Clu==PairsToTest(p,1));
    Res2 = Res(Clu==PairsToTest(p,2));
    nRes2 = length(Res2);
    if Width==0
        [T,G] = CatTrains({Res1,Res2},{1,2},Periods,1);
        [ccg out.tbin] = CCG(T,G,BinSize,HalfBins,SampleRate,[1 2],Normalization);
        smccg = sq(ccg(:,1,2));
        out.smCCG(:,p) = smccg(:);
    else
        [smccg ccg out.tbin Width] = sCCG(Res1,Res2,BinSize,HalfBins,SampleRate,Normalization,Width);
        out.smCCG(:,p) = smccg(:);
    end
    out.CCG(:,p) = sq(ccg(:,1,2));

    %now we keep Res1 fixed and randomize Res2
    for s=1:Randomiz.nRand
        switch Randomiz.Type
            case 'shuffle'
                if isempty(Periods) %easier case
                    isi = [0;diff(Res2)];
                    sRes2 = Res2(1)+cumsum(isi(randperm(nRes2)));
                else
                    %no time to vectorize - can be done
                    sRes2 =[];
                    for i=1:nPeriods
                        myres = Res2(Res2>Periods(i,1) & Res2<Periods(i,2));
                        if ~isempty(myres)
                            isi = [0;diff(myres)];
                            sRes2 = [sRes2; myres(1)+cumsum(isi(randperm(length(isi))))];
                        end
                    end
                end
            case 'jitter'
                ResShift = round(2*(rand(size(Res2))-0.5)*Randomiz.Tau);
                sRes2 = Res2+ResShift;
                ResShift = round(2*(rand(size(Res1))-0.5)*Randomiz.Tau);
                sRes1 = Res1+ResShift;
                
        end
        if Width==0
            [sT,sG] = CatTrains({sRes1,sRes2},{1,2},Periods,1);
            smccgr = CCG(sT,sG,BinSize,HalfBins,SampleRate,[1 2],Normalization);
            smccgr = sq(smccgr(:,1,2));
        else
            [smccgr sccg tbin] = sCCG(sRes1,sRes2,BinSize,HalfBins,SampleRate,Normalization,Width);
        end

        out.AvShufCCG(:,p) = out.AvShufCCG(:,p) + sq(smccgr(:));
        out.StdShufCCG(:,p) = out.StdShufCCG(:,p) + sq(smccgr(:)).^2;
        out.PvalShufCCG(:,p) = out.PvalShufCCG(:,p) + (smccgr(:)>smccg(:));

    end % end of shuffling loop

end

out.AvShufCCG = out.AvShufCCG ./ Randomiz.nRand;
out.StdShufCCG = out.StdShufCCG ./ Randomiz.nRand - out.AvShufCCG.^2;
out.PvalShufCCG = out.PvalShufCCG / Randomiz.nRand;
out.ZScore = (out.smCCG - out.AvShufCCG) ./ out.StdShufCCG;

