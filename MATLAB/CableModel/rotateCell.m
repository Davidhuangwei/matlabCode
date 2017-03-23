function NP=rotateCell(NP,pct,isrot)
if isrot
    % Mphi=@(phi)([1 0 0; 0 cos(phi) sin(phi); 0 -sin(phi) cos(phi)]);
    % Mtheta=@(theta)([cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1]);
    nx=@(x)([cos(x), sin(x)]);% theta
    ny=@(x,y)([-sin(y).*cos(x), cos(y).*cos(x), -sin(x)]);% phi, theta
    nz=@(x,y)([-sin(y).*sin(x), cos(y).*sin(x), cos(x)]);
    Randrot=bsxfun(@times,pi*[.1 2],rand(size(pct,1),2)-.5);% phi, theta
    mX=mean(NP.compartmentXPositionMat,2)';
    mY=mean(NP.compartmentYPositionMat,2)';
    mZ=mean(NP.compartmentZPositionMat,2)';
    
    NP.LocX=nx(Randrot(:,2))*[mX;mY];
    NP.LocY=ny(Randrot(:,1),Randrot(:,2))*[mX;mY;mZ];
    NP.LocZ=nz(Randrot(:,1),Randrot(:,2))*[mX;mY;mZ];
    NP.LocX=bsxfun(@plus,NP.LocX,pct(:,1));
    NP.LocY=bsxfun(@plus,NP.LocY,pct(:,2));
    NP.LocZ=bsxfun(@plus,NP.LocZ,pct(:,3));
else
    NP.LocX=bsxfun(@plus,mean(NP.compartmentXPositionMat,2)',pct(:,1));
    NP.LocY=bsxfun(@plus,mean(NP.compartmentYPositionMat,2)',pct(:,2));
    NP.LocZ=bsxfun(@plus,mean(NP.compartmentZPositionMat,2)',pct(:,3));
end