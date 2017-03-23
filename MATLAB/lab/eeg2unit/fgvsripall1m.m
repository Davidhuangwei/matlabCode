function fgvsripall(filename,what)

%filename='32309s';

fn=[filename '/' filename];
fg5=sdetect_a(strcat(fn,'.eeg'),8, 1, 140, 120,5);
fg10=sdetect_a(strcat(fn,'.eeg'),8, 1, 140, 120,7);
rip10=sdetect_a(strcat(fn,'.eeg'),8, 1, 200, 160,10);
rip5=sdetect_a(strcat(fn,'.eeg'),8, 1, 200, 160,5);

if what==1
figure
hfg5=sw2clusCC(filename,2,0,0.01,50,fg5)
title('fg5');

elseif what==2
figure
hfg10=sw2clusCC(filename,2,0,0.01,50,fg10)
title('fg10');

elseif what==3
figure
rip5=sw2clusCC(filename,2,0,0.01,50,rip5)
title('rip5');
elseif what==4
figure
rip10=sw2clusCC(filename,2,0,0.01,50,rip10)
title('rip10');
end
