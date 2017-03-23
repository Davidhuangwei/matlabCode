% CCHistograms = sw2clusCC(filename,elind,ifprint,tbin,halfbinnum,swtype,printname)
% plots crosscorrelograms between SPW and all and each clusters in electrode 
% or outputs the cell array of historgram values and x-axis for all/each clusters
% tbin - hist bin in msecs,
% swtype ='h' for Haj's swa files, 'j' -Josefs, vector for yours
function CCHistograms = sw2clusCC(filename,elind,ifprint,tbin,halfbinnum,swtype,printname,repnum)

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
if nargin<8 | isempty(repnum)
    repnum=10;
end
fn=[pwd '/' filename '/' filename];
clu=load([fn '.clu.' num2str(elind)]);
clunum=clu(1);
clu=clu(2:end);
res=load([fn '.res.' num2str(elind)]);
spk=res(find(clu~=1));
%curfigh=gcf;
if nargout==1
    CCHistograms = cell(clunum,1);
    %elseif curfigh~=111 
   % figure
else 
    figure%(curfigh)
end

if swtype=='h'
    sw=load([fn '.swa']);
    sw=sw(:,2);
elseif swtype=='j'
    sw=load([fn '.sw']);
    sw=sw(:,2);
else
    sw=swtype;
end

[CCHistograms{1}(:,1) CCHistograms{1}(:,2) CCHistograms{1}(:,3)] = PointCorrelS(sw,spk,tbin*20,halfbinnum,0,20000,'count',repnum);
for ii=2:clunum
   spk=res(find(clu==ii));
   [CCHistograms{ii}(:,1) CCHistograms{ii}(:,2) CCHistograms{ii}(:,3)] =PointCorrelS(sw,spk,tbin*20,halfbinnum,0,20000,'count',repnum);
end 
  
end 

	if ifprint==1
        
        letterlayoutl
%        if (exist('eps')~=7)
%            mkdir('eps');
%        end
        tbinstr=[num2str(tbin) '-' num2str(halfbinnum) 'sh'];
        cur=pwd;
        whereto=[tbinstr];
        cd(whereto);

        pictname = [filename '-' num2str(elind) '-' printname]; 
	    print ('-f','-depsc',pictname); 
        cd(cur);
    
	end


