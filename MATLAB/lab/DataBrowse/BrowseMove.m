function flChange = BrowseMove(MoveType, Value)
global gBrowsePar
flChange=0;
switch MoveType
case 'left'
           %fprintf(' left\n');
        if gBrowsePar.Center > Value + gBrowsePar.Width/2
            gBrowsePar.Center = gBrowsePar.Center -Value;
            flChange=1;
            gBrowsePar.LastAction = 'left';
        else
            fprintf('No more to the left, change step\n');
        end
  
case 'right'
         %    fprintf(' right\n');
        if gBrowsePar.Center < gBrowsePar.MaxT - Value - gBrowsePar.Width/2
            gBrowsePar.Center = gBrowsePar.Center + Value; 
            flChange=1;
            gBrowsePar.LastAction = 'right';
        else
            fprintf('No more to the right, change step\n');
        end  

 end    