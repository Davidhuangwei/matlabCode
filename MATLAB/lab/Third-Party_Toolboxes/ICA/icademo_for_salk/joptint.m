function [xold,fold,invhess,para]=joptint(xnew,fnew,para)
%OPTINT Function to initialize FMINU routine.

lenx=length(xnew);
invhess=eye(lenx);  
xold=xnew;
fold=fnew;
para=foptions(para);
if para(14)==0, para(14)=lenx*100;end 
if para(1)>1, para, end
if para(1)>0,
	disp('')
	disp('f-COUNT   FUNCTION    STEP-SIZE      GRAD/SD  LINE-SEARCH')
end
