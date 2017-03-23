function plotmazeregions(filebasemat,trialtypesbool,mazelocationsbool)

xdimensions = [0 368];
ydimensions = [0 240];

if ~exist('trialtypesbool')
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                    %cr ir cl il crp irp clp ilp crb irb clb ilb xp
end
if ~exist('mazelocationsbool')
    mazelocationsbool = [0  0  0  1  1  1   1   1   1];
                       %rp lp dp cp ca rca lca rra lra
end
% [1 0 1 0 0 0 0 0 0 0 0 0 0]
% [0 0 0 1 1 1 1 1 1]

[numfiles n] = size(filebasemat);


for i=1:numfiles

    filebase = filebasemat(i,:);
    whldat = loadmazetrialtypes(filebase,trialtypesbool,mazelocationsbool);
    %plot(ydimensions(2)-whldat(end-200:end,2),xdimensions(2)-whldat(end-200:end,1),'.','markersize',10);
    %set(gca,'xlim',ydimensions,'ylim',xdimensions);
    hold on;
    plot(ydimensions(2)-whldat(find(whldat(:,1)~=-1),2),xdimensions(2)-whldat(find(whldat(:,1)~=-1),1),'.','markersize',10,'color',[0 0 1]);
    set(gca,'xlim',ydimensions,'ylim',xdimensions);

end
%[ncr, nir, ncl, nil, ncrp, nirp, nclp, nilp, ncrb, nirb, nclb, nilb, nxp] = counttrialtypes(filebasemat);

%fprintf('Total n=%d\n', ncr + nir + ncl + nil + ncrp + nirp + nclp + nilp + ncrb + nirb + nclb + nilb);
%fprintf('cr  = %d, cl  = %d, ir  = %d, il  = %d\n', ncr, ncl, nir, nil);
%fprintf('crp = %d, clp = %d, irp = %d, ilp = %d\n', ncrp, nclp, nirp, nilp);
%fprintf('crb = %d, clb = %d, irb = %d, ilb = %d\n', ncrb, nclb, nirb, nilb);

trialsmat = counttrialtypes(filebasemat);
fprintf('Total n=%d\n', sum(trialsmat(1:12)));
fprintf('cr  = %d, cl  = %d, ir  = %d, il  = %d\n', trialsmat(1),trialsmat(3),trialsmat(2),trialsmat(4));
fprintf('crp = %d, clp = %d, irp = %d, ilp = %d\n', trialsmat(5),trialsmat(7),trialsmat(6),trialsmat(8));
fprintf('crb = %d, clb = %d, irb = %d, ilb = %d\n', trialsmat(9),trialsmat(11),trialsmat(10),trialsmat(12));
