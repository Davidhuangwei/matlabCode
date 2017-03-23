function  pct=setInputs(nxyz,Dens)
nxyz=nxyz(:);
if length(Dens)>1
    Dens=Dens(:);
end
rr=1;
 if length(nxyz)>2
    mxyz=round(nxyz.*Dens);%*lz
    nx=mxyz(1);
    ny=mxyz(2);
    nz=mxyz(3);
    celln=nx*ny*nz;
    oD=[reshape(repmat(linspace(0,1,nx),ny,nz)',[],1),...
        reshape(repmat(linspace(0,1,ny),nx,nz),[],1),...
        reshape(repmat(linspace(-.5,.5,nz),nx*ny,1),[],1)];
    pct=bsxfun(@times, nxyz',oD+bsxfun(@times,rr*[2/nx,2/ny,2/nz],rand(celln,3)-.5) );%linspace(0,2*pi,1+Ncell);uniform:[-1/3, 1/3]
    
 else
     mxyz=round(2*nxyz.*Dens);%*lz
     nx=mxyz(1);
     ny=nx;
     nz=mxyz(end);
     oD=repmat(linspace(-1,1,nx),ny,nz);
    oD=[reshape(oD',[],1), oD(:), reshape(repmat(linspace(-.5,.5,nz),nx*ny,1),[],1)];
    oD(sum(oD(:,1:2).^2,2)>1,:)=[];
    celln=size(oD,1);
    pct=bsxfun(@times,nxyz([1 1 2])' , oD+bsxfun(@times,rr*[4/nx*[1,1],2/nz],rand(celln,3)-.5));%linspace(0,2*pi,1+Ncell);
end
