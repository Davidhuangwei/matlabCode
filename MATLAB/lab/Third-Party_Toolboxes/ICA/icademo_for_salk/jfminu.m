function [x,OPTIONS] = jfminu(FUN,x,OPTIONS,GRADFUN,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10)

%jFMINU	Finds the minimum of a function of several variables.

fprintf('\nUsing jfminu ...\n');

global how;

% FUN jsize(P1,'x'); jsize(P2,'S'); GRADFUN
% ------------Initialization----------------
XOUT=x(:);
nvars=length(XOUT);

evalstr = [FUN];
if ~any(FUN<48)
	evalstr=[evalstr, '(x'];
	for i=1:nargin - 4
		evalstr = [evalstr,',P',int2str(i)];
	end
	evalstr = [evalstr, ')'];
end

if nargin < 3, OPTIONS=[]; end
if nargin < 4, GRADFUN=[]; end


if length(GRADFUN)
	evalstr2 = [GRADFUN];
	if ~any(GRADFUN<48) 
		evalstr2 = [evalstr2, '(x'];
		for i=1:nargin - 4
			evalstr2 = [evalstr2,',P',int2str(i)];
		end
		evalstr2 = [evalstr2, ')'];
	end
end

% CLUDGE
%evalstr
%f=h2eval(x,P1,P2);
f = eval(evalstr); 

n = length(XOUT);
GRAD=zeros(nvars,1);
OLDX=XOUT;
MATX=zeros(3,1);
MATL=[f;0;0];
OLDF=f;
FIRSTF=f;
[OLDX,OLDF,HESS,OPTIONS]=joptint(XOUT,f,OPTIONS);
CHG = 1e-7*abs(XOUT)+1e-7*ones(nvars,1);
SD = zeros(nvars,1);
diff = zeros(nvars,1);
PCNT = 0;


OPTIONS(10)=2; % Iteration count (add 1 for last evaluation)
status =-1;

while status ~= 1
% Work Out Gradients
	if ~length(GRADFUN) | OPTIONS(9) 
		OLDF=f;
% Finite difference perturbation levels
% First check perturbation level is not less than search direction.
		f = find(10*abs(CHG)>abs(SD)); 
		CHG(f) = -0.1*SD(f);
% Ensure within user-defined limits
		CHG = sign(CHG+eps).*min(max(abs(CHG),OPTIONS(16)),OPTIONS(17));
		for gcnt=1:nvars
			XOUT(gcnt,1)=XOUT(gcnt)+CHG(gcnt);
			x(:) = XOUT; f = eval(evalstr); 
			GRAD(gcnt)=(f-OLDF)/(CHG(gcnt));
			if f < OLDF
				OLDF=f;
			else
 				XOUT(gcnt)=XOUT(gcnt)-CHG(gcnt);
			end
		end
% Try to set difference to 1e-8 for next iteration
% Add eps for machines that can't handle divide by zero.
		CHG = 1e-8./(GRAD + eps); 
		f = OLDF;
		OPTIONS(10)=OPTIONS(10)+nvars;
% Gradient check 
		if OPTIONS(9) == 1 
			GRADFD = GRAD; 
			x(:)=XOUT;  GRAD(:) = eval(evalstr2); 
			graderr(GRADFD, GRAD, evalstr2);
			OPTIONS(9) = 0; 
		end
				
	else
		OPTIONS(11)=OPTIONS(11)+1;
		x(:)=XOUT; GRAD(:) = eval(evalstr2);
	end
%---------------Initialization of Search Direction------------------
if status == -1
	SD=-GRAD;
	FIRSTF=f;
	OLDG=GRAD;
	GDOLD=GRAD'*SD;
% For initial step-size guess assume the minimum is at zero. 
	OPTIONS(18) = max(0.001, min([1,2*abs(f/GDOLD)]));
	if OPTIONS(1)>0
		disp([sprintf('%5.0f %12.6g %12.6g ',OPTIONS(10),f,OPTIONS(18)),sprintf('%12.3g  ',GDOLD)]);
	end
	XOUT=XOUT+OPTIONS(18)*SD;
	status=4; 
	if OPTIONS(7)==0; PCNT=1; end
         
else
%-------------Direction Update------------------
	gdnew=GRAD'*SD;
	if OPTIONS(1)>0, 
		num=[sprintf('%5.0f %12.6g %12.6g ',OPTIONS(10),f,OPTIONS(18)),sprintf('%12.3g  ',gdnew)];
	end
	if (gdnew>0 & f>FIRSTF)|~finite(f)
% Case 1: New function is bigger than last and gradient w.r.t. SD -ve
%	...interpolate.
		how='inter';
		[stepsize]=jcubici1(f,FIRSTF,gdnew,GDOLD,OPTIONS(18));
		if stepsize<0|isnan(stepsize), stepsize=OPTIONS(18)/2; how='C1f '; end
		if OPTIONS(18)<0.1&OPTIONS(6)==0 
			if stepsize*norm(SD)<eps
				stepsize=exp(rand(1,1)-1)-0.1;
				how='RANDOM STEPLENGTH';
				status=0;
			else        
				stepsize=stepsize/2;
			end   
		end      
		OPTIONS(18)=stepsize;
		XOUT=OLDX;
	elseif f<FIRSTF
		[newstep,fbest] =jcubici3(f,FIRSTF,gdnew,GDOLD,OPTIONS(18));
		sk=(XOUT-OLDX)'*(GRAD-OLDG);
		if sk>1e-20
% Case 2: New function less than old fun. and OK for updating HESS
%         .... update and calculate new direction.
		how='';   
			if gdnew<0
				how='incstep';
				if newstep<OPTIONS(18),  newstep=2*OPTIONS(18)+1e-5; how=[how,' IF']; end
				OPTIONS(18)=min([max([2,1.5*OPTIONS(18)]),1+sk+abs(gdnew)+max([0,OPTIONS(18)-1]), (1.2+0.3*(~OPTIONS(7)))*abs(newstep)]);
			else % gdnew>0
				if OPTIONS(18)>0.9
					how='int_st';
					OPTIONS(18)=min([1,abs(newstep)]);
				end
			end %if gdnew
			[HESS,SD]=jupdhess(XOUT,OLDX,GRAD,OLDG,HESS,OPTIONS);
			gdnew=GRAD'*SD;
			OLDX=XOUT;
			status=4;
% Save Variables for next update
			FIRSTF=f;
			OLDG=GRAD;
			GDOLD=gdnew;
% If mixed interpolation set PCNT
			if OPTIONS(7)==0, PCNT=1; MATX=zeros(3,1);  MATL(1)=f; end
	elseif gdnew>0 %sk<=0 
% Case 3: No good for updating HESSIAN .. interpolate or halve step length.
			how='inter_st'; 
			if OPTIONS(18)>0.01
				OPTIONS(18)=0.9*newstep;
				XOUT=OLDX;
			end
			if OPTIONS(18)>1, OPTIONS(18)=1; end
		else  
% Increase step, replace starting point
			OPTIONS(18)=max([min([newstep-OPTIONS(18),3]),0.5*OPTIONS(18)]);
			how='incst2';
			OLDX=XOUT;
			FIRSTF=f;
			OLDG=GRAD;
			GDOLD=GRAD'*SD;
         		OLDX=XOUT;
		end % if sk>
% Case 4: New function bigger than old but gradient in on
%         ...reduce step length.
	else %gdnew<0 & F>FIRSTF
		if gdnew<0&f>FIRSTF
			how='red_step';  
			if norm(GRAD-OLDG)<1e-10; HESS=eye(nvars); end
			if abs(OPTIONS(18))<eps
				SD=norm(nvars,1)*(rand(nvars,1)-0.5)
				OPTIONS(18)=abs(rand(1,1)-0.5)*1e-6;
              			how='RANDOM SD';
             		else
              			OPTIONS(18)=-OPTIONS(18)/2;
			end
			XOUT=OLDX;
		end %gdnew>0	
	end % if (gdnew>0 & F>FIRSTF)|~finite(F)
	XOUT=XOUT+OPTIONS(18)*SD;
	if OPTIONS(1)>0, disp([num,how]),end
end %----------End of Direction Update-------------------

% Check Termination 
	if max(abs(SD))<2*OPTIONS(2) & (-GRAD'*SD) < 2*OPTIONS(3)
		if OPTIONS(1) > 0
			disp('Optimization Terminated Successfully')
			disp('Gradient less than options(2)')     
			disp([' NO OF ITERATIONS=', int2str(OPTIONS(10))]);
		end
		status=1; 
	elseif OPTIONS(10)>OPTIONS(14) 
			if OPTIONS(1)>=0
				disp('Warning: Maximum number of iterations has been exceeded');
				disp('       - increase options(14) for more iterations.')
			end
			status=1;
	else

% Line search using mixed polynomial interpolation and extrapolation.
		if PCNT~=0 
			while PCNT > 0
				x(:) = XOUT; f = eval(evalstr); OPTIONS(10)=OPTIONS(10)+1;
				[PCNT,MATL,MATX,steplen,f, how]=jsearchq(PCNT,f,OLDX,MATL,MATX,SD,GDOLD,OPTIONS(18), how);
				OPTIONS(18)=steplen;
				XOUT=OLDX+steplen*SD;
			end

		else
			x(:)=XOUT; f = eval(evalstr); OPTIONS(10)=OPTIONS(10)+1;
		end
	end
end

x(:)=XOUT; 
f = eval(evalstr);
if f > FIRSTF
	OPTIONS(8) = FIRSTF; 
	x(:)=OLDX;
else
	OPTIONS(8) = f; 
end
