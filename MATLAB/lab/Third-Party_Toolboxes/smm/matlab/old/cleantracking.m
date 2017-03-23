function syncNew = cleantracking(sync1,sync2)    

% add points as necesary beginning with point 2 because point 1 is usually a bit off
        
        MedSync1Dif = median(diff(sync1(1:end)));
        tolerance = 0.95 ;
        if (median(diff(sync1(2:5))) < median(diff(sync1(1:end)))*tolerance |  median(diff(sync1(2:5))) > median(diff(sync1(1:end)))/tolerance)
          fprintf('the median time difference between the 2nd-5th spot is not similar to the median time difference between all the spots in the file... i.e there is a problem and you should attempt some manual cleaing before running autofix');    end
        [m1,n] = size(sync1);
        % Correct sync 1
        i=2; % skip the first point because it's usually off
        while (i < m1)
	  if (((sync1(i+1)-sync1(i)) >= (MedSync1Dif*tolerance)) & ((sync1(i+1)-sync1(i)) <= (MedSync1Dif/tolerance)))
            i=i+1;
          else
            while ((i < m1) & ((sync1(i+1)-sync1(i)) < (MedSync1Dif*tolerance)))
             m1=m1-1;              
             sync1(i+1) = [];              
            end
            while ((i < m1) & ((sync1(i+1)-sync1(i)) > (MedSync1Dif/tolerance)))
    	      x = sync1(i) + MedSync1Dif;
              sync1 = [sync1(1:i);x;sync1(i+1:end)];
              i=i+1;
	      m1=m1+1;
              m2 = m1;
            end
          end
        end  
        [m2,n] = size(sync2);
        while (m1 < m2)
          sync1 = [sync1(m1); sync1(m1) + MedSync1Dif];
        end
        syncNew = sync1;
