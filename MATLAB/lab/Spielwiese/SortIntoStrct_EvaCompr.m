function SortIntoStrct_EvaCompr
% function SortIntoStrct_EvaCompr(xx)
%
% dist/time:
%
% bipolar:/bp02/groupStat/compressionIndex_distTimeCCGpeakLoc_altern_rat123_maxDi
% stVal0.5_mazeSection13_trialType1_PFdetDeval0.88063.mat
%    ===>>> EvaCompressdat1.mat
%
%time/time:
%
%bipolar:/bp02/groupStat/compressionIndex_timeTimeCCGpeakLoc_altern_rat123_maxDi
%stVal0.5_mazeSection13_trialType1_PFdetDeval0.88063.mat
%    ===>>> EvaCompressdat2.mat
%
%structure:
%
%Nanimal Nfile cell1ID cell2ID dist(cm)/time(msec) time(msec) X X
%
%Nanimal
%2: g01
%3: h01
%
%Nfile
%g01:
%1 - g01_maze14_MS.003
%2 - g01_maze14_MS.004
%
%h01
%1 - h01_maze16_MS.002
%2 - h01_maze16_MS.003
%3 - h01_maze23_MS.001

nf{1} = [];
nf{2} = {'g01_maze14_MS.003' 'g01_maze14_MS.004'};
nf{3} = {'h01_maze16_MS.002' 'h01_maze16_MS.003' 'h01_maze23_MS.001'};

LD = load('EvaCompressdat1.mat','-MAT');
ALD = [[LD.comprFact.RL ones(size(LD.comprFact.RL,1),1)]; [LD.comprFact.LR ones(size(LD.comprFact.LR,1),1)*2]];
LT = load('EvaCompressdat2.mat','-MAT');
ALT = [[LT.comprFact.RL ones(size(LT.comprFact.RL,1),1)]; [LT.comprFact.LR ones(size(LT.comprFact.LR,1),1)*2]];

for n=[2 3]
  for m=1:length(nf{n})
    % Distance
    ix = find(ALD(:,1)==n & ALD(:,2)==m); 
    compr.Dtheta = ALD(ix,6);
    compr.Ddist  = ALD(ix,5);
    compr.Drunt  = [];
    compr.Dx1  = ALD(ix,7);
    compr.Dx2 =  ALD(ix,8);
    compr.Ddir  = ALD(ix,9);
    compr.Dclu1 = ALD(ix,3);
    compr.Dclu2 = ALD(ix,4);
    
    % Time
    ix = find(ALT(:,1)==n & ALT(:,2)==m); 
    compr.Ttheta = ALT(ix,6);
    compr.Tdist  = [];
    compr.Trunt  = ALT(ix,5);
    compr.Tx1  = ALT(ix,7);
    compr.Tx2 =  ALT(ix,8);
    compr.Tdir  = ALT(ix,9);
    compr.Tclu1 = ALT(ix,3);
    compr.Tclu2 = ALT(ix,4);
    
    figure(3475);clf;
    subplot(321)
    plot(compr.Ddist,compr.Dtheta,'.')
    title(nf{n}{m})
    subplot(322)
    plot(compr.Trunt,compr.Ttheta,'.')
    subplot(323)
    hist(compr.Dx1)
    subplot(325)
    hist(compr.Dx2)
    subplot(324)
    hist(compr.Tx1)
    subplot(326)
    hist(compr.Tx2)
    
    save([nf{n}{m} '/' nf{n}{m} '.seqcompr'],'compr')
    
    %WaitForButtonpress
  end
end



return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    compr.theta = xx(1,indx);
    compr.dist  = xx(2,indx);
    compr.runt  = xx(3,indx);
    compr.pos1  = xx(4,indx);
    compr.pos2 =  xx(5,indx);
    compr.dir  =  xx(8,indx);
    compr.shank1 = xx(9,indx);
    compr.clu1 = xx(10,indx);
    compr.shank2 = xx(11,indx);
    compr.clu2 = xx(12,indx);
    compr.fccg = xx(13,indx);
    compr.region1 = xx(14,indx);
    compr.region2 = xx(15,indx);
