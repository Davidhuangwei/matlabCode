function evalText = BreakOpt
in = input('q:break, else:continue ','s');
if strcmp(in,'q')
    evalText = 'break';
else
    evalText = '';
end
return
