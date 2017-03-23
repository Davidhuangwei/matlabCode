% Order = IterativeSequence(Mat, nIter, Decay)
%
% attempts to do linear arrangement by stochastic best fit
%
% Mat is a similarity matrix
%
% decay is a space-factor for how mauch it should care about 
% neighboring elements (try 0.9)

function [Order, Sc] = IterativeSequence(Mat, nIter, Decay)

% wipe diagonal
Mat = Mat-diag(diag(Mat)); 

[n dummy] = size(Mat);

% closeness measure matrix
HowClose = Decay.^toeplitz(1:n);

% original order
Order = randperm(n)';
OldSc = inf;
for i=1:1e20
    
%     temp = temp*tempsc;
    % compute score for this iteration
    ReArMat = Mat(Order,Order);
    Sc = sum(HowClose(:).*ReArMat(:));
    
    % compute 2 random pos
    p1 = 1+floor(rand(1)*n);
    p2 = 1+floor(rand(1)*n);
    
    % with half chance, we either reverse a section, or move it
    if (p1>p2)
        % reverse section
        NewOrder = Order;
        NewOrder(p2:p1) = Order(p1:-1:p2);
    else
        % move section p1..p2 to a new location, p3
        p3 = 1+floor(rand(1)*(n-p2+p1)); % this is the location within Without it goes to
        Without = [Order(1:p1-1); Order(p2+1:end)];
        NewOrder = [Without(1:p3-1); Order(p1:p2) ; Without(p3:end)];
    end

    % compute new score
    NewReArMat = Mat(NewOrder,NewOrder);
    NewSc = sum(HowClose(:).*NewReArMat(:));
    
   if (NewSc>Sc)
%     if (NewSc>Sc) | (rand(1)<exp(-(Sc-NewSc)/temp));
        Order=NewOrder;
        Sc=NewSc;
    end

    if (mod(i,nIter)==1)
        imagesc(Mat(Order,Order));
        drawnow
        fprintf('Score %f, normalized %f\r', Sc, Sc/n);
        if (Sc==OldSc) 
            break; 
        end
        OldSc = Sc;
    end

end
fprintf('\n');
return
