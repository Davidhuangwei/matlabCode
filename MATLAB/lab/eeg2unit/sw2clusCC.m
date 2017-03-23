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
if nargin<7 | isempty(printname)
    printname=' ';
end

if nargin<8 | isempty(repnum)
    repnum=10;
end
fn=[pwd '/' filename ];
clu=load([fn '.clu.' num2str(elind)]);
clunum=clu(1);
clu=clu(2:end);
res=load([fn '.res.' num2str(elind)]);
spk=res(find(clu~=1));
CCHistograms = cell(clunum,1);
    %elseif curfigh~=111 
   % figure
par=LoadPar([filename '.par');
   
SampleRate = 1e6/par.SampleTime;

if swtype=='h'
    sw=load([fn '.swa']);
    sw=sw(:,2);
elseif swtype=='j'
    sw=load([fn '.sw']);
    sw=sw(:,2);
elseif ~isstr(swtype)
    sw=load(fn '.sw' num2str(swtype)]);
    sw=sw(:,2);
else
    sw=swtype;
end
%sw=sw(:,2);

if SampleRate~=20000
    sw=floor(sw/2);
end

PointCorrel(sw,spk,tbin*20,halfbinnum,0,SampleRate,'scale');

for ii=2:clunum
   spk=res(find(clu==ii));
   PointCorrel(sw,spk,tbin*20,halfbinnum,0,SampleRate,'scale');
end 

	if ifprint==1
        
              
        %plotshuffCC(CCHistograms);
%        if (exist('eps')~=7)
%            mkdir('eps');
%        end
        %tbinstr=[num2str(tbin) '-' num2str(halfbinnum) 'shshort'];
        %cur=pwd;
        %whereto=[tbinstr];
        %cd(whereto);
        letterlayoutl;
        pictname = ['/u12/antsiro/mice/eps/' filename '-' num2str(elind) '-sw']; 
	    print ('-f','-depsc',pictname); 
        %cd(cur);
        close
    
	end


