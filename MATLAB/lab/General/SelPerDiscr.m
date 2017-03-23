% selects discrete events within Periods 
%function [y, ind]=SelPerDiscr(x,Periods, WhereFlag,SquashTime)
function [y, ind]=SelPerDiscr(x,Periods, WhereFlag,SquashTime)
nPeriods = size(Periods,1);
if nargin<4 | isempty(SquashTime)
    SquashTime=0;
end
x = x(:);
%x = sort(x);
nTimeBins = max(x);
ind = [];y=[];
if SquashTime
    Shift = Periods(:,1) -[0; Periods(1:end-1,2)]-1 ; % there was evil bug here , thanks to Kenji it is fixed. damn complicated me!
    Shift = cumsum(Shift);
end 

if WhereFlag
    for p=1:nPeriods
        myi   = find(x>=Periods(p,1) & x<=Periods(p,2));
        ind = [ind; myi(:)];

        if ~SquashTime
            y = [y; x(myi) ];
        else
            y = [y; x(myi)-Shift(p) ];
        end
    end

else
    OutPeriods = [];
    if Periods(1,1)>2
        OutPeriods=[1 Periods(1,1)-1];
    end
   
    for  p=1:nPeriods-1
        OutPeriods = [OutPeriods; [Periods(p,2)+1 Periods(p+1,1)-1]];
    end
    
    if Periods(end,2)<nTimeBins
        OutPeriods = [OutPeriods; [Periods(end,2)+1 nTimeBins]];
    end

    [y, ind]=SelPerDiscr(x,OutPeriods,1,SquashTime);
    
%     ind = [ind; find(x > 1 & x < Periods(1,1))];
%     if (nPeriods>1)
%         for  p=1:nPeriods-1
%             myi=find(x > Periods(p,2) & x<Periods(p+1,1));
%             ind = [ind; myi(:)];
% 
%             if SquashTime
%                 y = [y; x(myi)];                
%             
%         end
%     end
%     ind = [ind; find(x > Periods(end,2) & x<nTimeBins)];

end


return