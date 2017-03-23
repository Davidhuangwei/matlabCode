% CCHistograms =hip2cxCC(filename,hipelind, cxelind,ifprint,tbin,halfbinnum,swtype,printname)
% plots crosscorrelograms between units on hipelind and cxelind (all clusters) in electrode 
% or outputs the cell array of historgram values and x-axis for all cells, in ripple/iout ripple
% tbin - hist bin in msecs,
% swtype ='h' for Haj's swa files, 'j' -Josefs, vector for yours
function CCHistograms = hip2cxCC(filename,hipelind, cxelind,ifprint,tbin,halfbinnum,swtype,printname)

if nargin<3 
    tbin=5;
    halfbinnum=100;
    ifprint=0;
    swtype='h';
elseif nargin<4
    tbin=5;
    halfbinnum=100;
    swtype='h';
end
if nargin<8
    printname='hip2cx';
end
fn=[pwd '/' filename '/' filename];
clucx=load([fn '.clu.' num2str(cxelind)]);
clunumcx=clucx(1);
clucx=clucx(2:end);
rescx=load([fn '.res.' num2str(cxelind)]);
spkcx=cell(3,clunumcx);
spkcx{1}=rescx(find(clucx~=1));
for ii=2:clunumcx
    spkcx{ii}=rescx(find(clucx==ii));
end
cluhip=load([fn '.clu.' num2str(hipelind)]);
clunumhip=cluhip(1);
cluhip=cluhip(2:end);
reship=load([fn '.res.' num2str(hipelind)]);
spkhip=reship(find(cluhip~=1));
CCHistograms = cell(3,clunumcx);
ErrBars=cell(3,1);
if swtype=='h'
    sw=load([fn '.swa']);
    sw=sw(:,2);
elseif swtype=='j'
    sw=load([fn '.sw']);
    sw=sw(:,2);
else
    sw=swtype;
    if size(sw,2)==1
        swl=size(sw,1);
        tlag=1000*20; %msec
        sw=[sw-ones(swl,1)*tlag;sw;sw+ones(swl,1)*tlag];
    end
end

if size(sw,2)==1
        m1=min(sw);m2=max(sw);
        swl=size(sw,1);
        tlag=100*20; %msec
        sw=[sw-ones(swl,1)*tlag, sw,sw+ones(swl,1)*tlag];
        %sw(find(sw>m2))=m2*ones(length(find(sw>m2)),1);
        %sw(find(sw<m1))=m1*ones(length(find(sw<m1)),1);
 end

 for ii=1:clunumcx   
    [CCHistograms{1,ii}(:,1) CCHistograms{1,ii}(:,2) CCHistograms{1,ii}(:,3)] =PointCorrelS(spkhip,spkcx{ii},tbin*20,halfbinnum,0,20000,'count');

    hipsw=spkinsw(spkhip,sw);
    cxsw =spkinsw(spkcx{ii},sw);
    [CCHistograms{2,ii}(:,1) CCHistograms{2,ii}(:,2) CCHistograms{2,ii}(:,3)] = PointCorrelS(hipsw{1},spkcx{ii},tbin*20,halfbinnum,0,20000,'count');
    [CCHistograms{3,ii}(:,1) CCHistograms{3,ii}(:,2)  CCHistograms{3,ii}(:,3)] =PointCorrelS(hipsw{2},cxsw{2},tbin*20,halfbinnum,0,20000,'count');
end

if ifprint==1
        
    tit=[filename '.' num2str(hipelind)  'vs'  num2str(cxelind) '.out'];

    plotshuffCC(CCHistograms,{'all','in','out'});
%    ForAllSubplots('grid on');
%        if (exist('eps')~=7)
%            mkdir('eps');
%        end
    title(tit);
    tbinstr=[num2str(tbin) '-' num2str(halfbinnum) 'shortnew'];
    cur=pwd;
    whereto=[tbinstr];
    cd(whereto);
    letterlayoutl
    pictname = [filename '-' num2str(hipelind) 'vs' num2str(cxelind) '-' printname]; 
    print ('-f','-depsc',pictname); 
    cd(cur);

end

