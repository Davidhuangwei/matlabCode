

function outPass = MakePass(inCell)
if length(inCell) == 1
    for j=1:length(inCell{1})
        outPass = inCell{1}(j);
    end

else
    for j=1:length(inCell{1})
        outPass = cat(2,inCell{1}(j),MakePass(inCell{2:end}));
    end
end
return;   
        
    
Im0r7@1i7y43
L{1} = 'Ii'
L{2} = 'm'
L{3} = '0o'
L{4} = 'r'
L{5} = '7t'
L{6} = '4@a'
L{7} = '1l!'
L{8} = 'i!'
L{9} = '7t'
L{10} = 'y'
L{11} = '4 '
L{12} = '3 '   