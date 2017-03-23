% ISIhistogram = sw2clusCC(filename,elind,ifprint,tbin,halfbinnum,swtype,printname)
% plots ISI histrograms of cells during SPW  
% or outputs the cell array of historgram values and x-axis for all/each clusters
% tbin - isi bin in msecs,halfbinnum - number of bins
% swtype ='h' for Haj's swa files, 'j' -Josefs, vector for yours
function CCHistograms = ISIinSW(filename,elind,ifprint,tbin,halfbinnum,swtype,printname)

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

fn=[pwd '/' filename '/' filename];
clu=load([fn '.clu.' num2str(elind)]);
clunum=clu(1);
clu=clu(2:end);
if nargout==1
    CCHistograms = cell(clunum,1);
else
    figure
end

if swtype=='h'
    sw=load([fn '.swa']);
elseif swtype=='j'
    sw=load([fn '.sw']);
else
    sw=swtype;
end


res=load([fn '.res.' num2str(elind)]);
clu=load([fn '.clu.' num2str(elind)]);
clu=clu(2:end);

spk=res(find(clu~=1));
%corection to sw period

sw(:,1)=sw(:,2)-300*20;
sw(:,3)=sw(:,2)+300*20;

% diff spk in swin/swout time periods

dspkin=[];
spkinall=[];
for i=1:size(sw,1)
    spkin=spk(find(spk<sw(i,3) & spk>sw(i,1)));     
    spkinall=[spkinall;spkin];
    dspkin=[dspkin;diff(spkin)];
end
dspkout=[];
spkoutall=[];
for i=1:size(sw,1)-1
    spkout=spk(find(spk>sw(i,3) & spk<sw(i+1,1)));    
    spkoutall=[spkoutall;spkout];
    dspkout=[dspkout;diff(spkout)];
end

dspkin=dspkin(:)/20; %in msec
dspkout=dspkout(:)/20; %in msec
isirange=[0:tbin:halfbinnum*tbin];


if nargout==0
    subplotfit(1,clunum);
    if (~isempty(dspkin)& ~isempty(dspkout))
        [nin, bin] = histc(dspkin,isirange);
        [nout, bin] = histc(dspkout,isirange);
        bar(isirange, nout/sum(nout),'g');
        hold on
        bar(isirange,nin/sum(nin),'r');
    end
    tit=[filename '.' num2str(elind) '.all'];
    title(tit);
    %dbstop

else
    ISIin{1}=histc([dspkin,dspkout],isirange);
end

for ii=2:clunum
    spk=res(find(clu==ii));
    
    dspkin=[];
	for i=1:size(sw,1)
        spkin=spk(find(spk<sw(i,3) & spk>sw(i,1)));     
        dspkin=[dspkin;diff(spkin)];
	end
	dspkout=[];
	for i=1:size(sw,1)-1
        spkout=[spkout;spk(find(spk>sw(i,3) & spk<sw(i+1,1)))];    
        dspkout=[dspkout;diff(spkout)];
	end
	
	dspkin=dspkin/20; %in msec
	dspkout=dspkout/20; %in msec
    if nargout==0
               
        subplotfit(ii,clunum);
        if (~isempty(dspkin) & ~isempty(dspkout))
            [nin, bin] = histc(dspkin,isirange);
            [nout, bin] = histc(dspkout,isirange);
            bar(isirange, nout/sum(nout),'g');
            hold on
            bar(isirange,nin/sum(nin),'r');
        end
        tit=[filename '.' num2str(elind) '.' num2str(ii) ' - ' num2str(ceil(20000/mean(diff(spk)))) ' Hz'];
    	title(tit);       
    else
        CCHistograms{ii}=histc([dspkin,dspkout],isirange);
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



