% function out = AntiDiag(data)
% 
% for j=1:size(data,1)
%     for k=1:size(data,2)
%         if j~=k
%             out(j,k) = data(j,k);
%         end
%     end
% end
% return

function out = AntiDiag(data)

for j=1:size(data,1)
    for k=1:size(data,2)
        if j~=k
            out(j,k) = data(j,k);
        end
    end
end
return
