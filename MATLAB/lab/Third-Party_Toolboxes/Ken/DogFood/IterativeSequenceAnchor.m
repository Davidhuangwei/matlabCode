% Order = IterativeSequenceAnchor(Mat, Anchor, Bias, nIter, Decay)
%
% attempts to do linear arrangement by stochastic best fit
% with the constraint that one item will be fixed to position
% 1.  
%
% Mat is a similarity matrix
%
% Anchor is item to be fixed
% Bias is how much more this items closeness counts than others.
%
% see also IterativeSequence

function [Order, Sc] = IterativeSequenceAnchor(Mat, Anchor, Bias, nIter, Decay)

% wipe diagonal
Mat = Mat-diag(diag(Mat)); 

[n dummy] = size(Mat);
NotAnchor = setdiff(1:n, Anchor);

% closeness measure matrix
HowClose = Decay.^toeplitz(1:n);
% bias it
HowClose(:,1) = HowClose(:,1)*Bias;
HowClose(1,:) = HowClose(1,:)*Bias;

% original order
% [dummy o] = sort(-Mat(NotAnchor,Anchor));
o = randperm(length(NotAnchor));
Order = [Anchor; NotAnchor(o)'];
% return

OldSc = inf;
for i=1:1e20
    
%     temp = temp*tempsc;
    % compute score for this iteration
    ReArMat = Mat(Order,Order);
    Sc = sum(HowClose(:).*ReArMat(:));
    
    % compute 2 random pos, not including anchor
    p1 = 2+floor(rand(1)*(n-1));
    p2 = 2+floor(rand(1)*(n-1));
    
    % with half chance, we either reverse a section, or move it
    if (p1>p2)
        % reverse section
        NewOrder = Order;
        NewOrder(p2:p1) = Order(p1:-1:p2);
    else
        % move section p1..p2 to a new location, p3
        p3 = 2+floor(rand(1)*(n-1-p2+p1)); % this is the location within Without it goes to
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
