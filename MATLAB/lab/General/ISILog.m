%function ISILog(Filename,ElecId,Depth,SampleRate)
% plots Log of ISI in time and histograms for each cluster
% Depth sets the maximum number of spikes to skip for ISI caclulation
function ISILog(Filename,ElecId,Depth,SampleRate)

if nargin<3 |isempty(Depth) Depth=1; end
if nargin<4 |isempty(SampleRate) SampleRate =20000; end
spk = readunitbyel(Filename,ElecId);
clunum = length(spk);
ISI=cell(clunum,1);ISIt=cell(clunum,1);
for c=2:clunum
    for d=1:Depth
        ISI{c} = [ISI{c};  diff(spk{c}(1:d:end))*1000/SampleRate];
        ISIt{c} = [ISIt{c}; spk{c}(1:d:end-d)/SampleRate];
    end
end

figure
for c=2:clunum
    Col = rand(1,3);
%     subplotfit(c,clunum);
    semilogy(ISIt{c},ISI{c},'.', ...
        'MarkerEdgeColor', Col, 'MarkerFaceColor', Col, 'Color', Col);
    %'MarkerSize', 5
    hold on
end

figure
for c=2:clunum
    subplotfit(c,clunum);
    hist(log(ISI{c}),100);
end