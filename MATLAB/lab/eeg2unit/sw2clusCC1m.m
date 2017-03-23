% CCHistograms = sw2clusCC(filename,elind,ifprint,tbin,halfbinnum,swtype,printname)
% plots crosscorrelograms between SPW and all and each clusters in electrode 
% or outputs the cell array of historgram values and x-axis for all/each clusters
% tbin - hist bin in secs,
% swtype ='h' for Haj's swa files, 'j' -Josefs, vector for yours
function CCHistograms = sw2clusCC1(filename,elind,ifprint,tbin,halfbinnum,swtype,printname)

if nargin<3 
    tbin=0.05;
    halfbinnum=20;
    ifprint=0;
    swtype='h';
elseif nargin<4
    tbin=0.05;
    halfbinnum=20;
    swtype='h';
end

fn=[pwd '/' filename];
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
%sw=sw(:,2);

if nargout==0
    subplotfit(1,clunum);
    PointCorrelA(sw,spk,tbin*20000,halfbinnum,0,20000,'count');
    tit=[filename '.' num2str(elind) '.all'];
    title(tit);
    grid on
    ax=axis;
    %set(gca,'xtick',[ax(1):
    
else
    CCHistograms{1}=PointCorrelA(sw,spk,tbin*20000,halfbinnum,0,20000,'count');
end

for ii=2:clunum
    spk=res(find(clu==ii));
    if nargout==0
        subplotfit(ii,clunum);
        PointCorrelA(sw,spk,tbin*20000,halfbinnum,0,20000,'count');
        tit=[filename '.' num2str(elind) '.' num2str(ii) ' - ' num2str(ceil(20000/mean(diff(spk)))) ' Hz'];
    	title(tit);       
        grid on
    else
        CCHistograms{ii}=PointCorrelA(sw,spk,tbin*20000,halfbinnum,0,20000,'count');
    end
  
end 
if nargout==0
	
	letterlayoutl
	if ifprint==1
        pictname = ['eps1/' filename printname]; 
	    print ('-f','-depsc',pictname); 
        close
	end
end



