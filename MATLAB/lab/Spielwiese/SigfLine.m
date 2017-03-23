function SigfLine(X1,X2,Y,sig,varargin)
%function SigfLine(X1,X2,Y,sig,varargin)
%[ltick,col,width,p] = DefaultArgs(varargin,{1,[0 0 0],[],0.05});
[ltick,col,width,p] = DefaultArgs(varargin,{1,[0 0 0],[],0.05});

Lines([X1 X2],Y,col,[],width);
Lines(X1,[Y-ltick Y],col,[],width);
Lines(X2,[Y-ltick Y],col,[],width);

if sig < p
  text((X2+X1)/2,Y+ltick,'*','FontSize',16);
end
