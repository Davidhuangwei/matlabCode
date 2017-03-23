% function outString = SlashCheck(inString)
% 
% if strcmp(inString(end),'/')
%     outString = inString;
% else
%     outString = [inString '/'];
% end
% return
function outString = SlashCheck(inString)

if strcmp(inString(end),'/')
    outString = inString;
else
    outString = [inString '/'];
end
return
   