clc
clear

disp(' ');
disp(' --------------------------------------------- ');
disp(' Install and check of integrity of the toolbox ');
disp(' --------------------------------------------- ');
% for windows

disp(' This installation script performs a test on the training')
disp(' and simulation routines  and some hints are given ')
disp(' about  the accesibility of the toolbox ')
disp(' If some problems are encountered, stop the script by the keys');
disp(' <ctrl>-c and restart this installation)');
disp(' ');
disp(' If an old toolbox is installed already, it''s recommended')
disp(' to remove that directory from the system.')
disp(' ')
disp(' ');
disp(' 1. Extract the ''.tar.gz'' file using winzip');
disp(' ');
disp(' Save the extracted toolbox in a directory....');
disp(' ');
disp(' ');

disp(' ')
disp(' press <ENTER> to continue')
disp(' '); pause;

disp(' Is the archive extracted in one of the following directories?');
!dir LS-SVMlab*
disp(' ');
disp(' If so, pass the name of that directory.');
disp(' If not so type the complete path');
disp(' ');
file = input('Name of the directory of LS-SVMlab: ','s')
disp(' ');
disp([' >> cd ' file]);
eval(['cd ' file]);
disp(' ');


disp(' 2. Choose the appropriate compilation:');
disp(' ');
disp(' >> version');
v = version
if v(1)~='6',
  disp(' warning:');
  disp(' The c-files and the optimization routines are developped ');
  disp(' For Matlab 6.* . Older releases are not supported explicitly.');
  disp(' If you can access Matlab 6, you should re-run this installation there.');
end

disp(' ');
disp(' Check for the optimization routines: ');
disp(' ');
disp(' >> which(''fminunc'')');

disp(' ');
disp(' >> which(''fminunc'')');
resp = which('fminunc');
disp(' ');
if isempty(resp),
  disp(' This function seems not to be found, ');
  disp(' The functions ''tunelssvm'', ''bay_optimize'',');
  disp(' ''bay_lssvm'' and ''bay_rr'' may produce errors.');
  disp(' ');
end
  
disp(' Which memory intensity level do you which?');
c = input('Up to (a) 64 Mb, (b) 256 Mb or (c) up to 1 Gb? [answer ''a'',''b'' or ''c''] : ','s');
disp(' ');

!del lssvm.dll
!del simclssvm.dll
!del lssvmFILE.exe
!del simFILE.exe
    
if c(1)=='c',
  !copy simclssvm1024.dll simclssvm.dll
  !copy lssvm1024.dll lssvm.dll
  !copy simFILE1024.exe simFILE.exe
  !copy lssvmFILE1024.exe lssvmFILE.exe
  disp('>> !copy simclssvm1024.dll simclssvm.dll');
  disp('>> !copy lssvm1024.dll lssvm.dll');
  disp('>> !copy simFILE1024.exe simFILE.exe');
  disp('>> !copy lssvmFILE1024.exe lssvmFILE.exe');
  disp(' ');
  disp('Maximal used memory is 1Gb');
elseif c(1)=='b' 
  !copy simclssvm256.dll simclssvm.dll
  !copy lssvm256.dll lssvm.dll
  !copy simFILE256.exe simFILE.exe
  !copy lssvmFILE256.exe lssvmFILE.exe
  disp('>> !copy simclssvm256.dll simclssvm.dll');
  disp('>> !copy lssvm256.dll lssvm.dll');
  disp('>> !copy simFILE256.exe simFILE.exe');
  disp('>> !copy lssvmFILE256.exe lssvmFILE.exe');
  disp(' ');
  disp('Maximal used memory is 256 Mb');
else
  !copy simclssvm64.dll simclssvm.dll
  !copy lssvm64.dll lssvm.dll
  !copy simFILE64.exe simFILE.exe
  !copy lssvmFILE64.exe lssvmFILE.exe
  disp('>> !copy simclssvm64.dll simclssvm.dll');
  disp('>> !copy lssvm64.dll lssvm.dll');
  disp('>> !copy simFILE64.exe simFILE.exe');
  disp('>> !copy lssvmFILE64.exe lssvmFILE.exe');
  disp(' ');
  disp('Maximal used memory is 64 Mb');
end

disp(' ')
disp(' press <ENTER> to continue')
disp(' '); pause;



disp(' 3. Testing the training and simulation');
disp(' ');
disp(' 3.1 training');
disp(' ');
disp(' Here, the C-mex, the C-file and the native Matlab');
disp(' implementations are tested. The default is set respectively');
disp(' ''CMEX'', ''CFILE'' and ''CFILE'', according to the success');
disp(' of the test');
disp(' ');
disp(' TESTING: ....');
% make a small test data set
nb = 20;
X = 2.*randn(nb,1);
Y = sin(pi*X)./(pi.*X+1234*eps) + 0.1.*randn(nb,1);
imps = {'CMEX','CFILE','MATLAB'};
% test different implementations, and set default
for i = 1:3,
  eval('model = trainlssvm({X,Y,''f'',10,1,''RBF_kernel'',''preprocess'',imps{i}});e=0;',...
       'disp([imps{i} '' implementation does not work properly''] );e=1;');
  if ~e,
    if strcmpi(model.implementation,imps{i}), 
      disp([imps{i} ' implementation of training works properly']);e=0;
    else
      disp([imps{i} ' implementation does not work properly']);e=1;
    end
  end
  if e,
    disp(' Set the default implementation in ''initlssvm.m'' at');
    disp([' line 51 from ' imps{i} ' to ' imps{min(i+1,3)} '.']); 
  end
  
end

disp(' ');
disp(' 3.2 simulation');
disp(' ');
for i = 1:3,
  eval('[f,ff,model] = simlssvm({X,sign(Y),''c'',10,1,''RBF_kernel'',''preprocess'',imps{i}},X);',...
       'disp([imps{i} '' simulation implementation does not work properly''] );break;');
  if strcmpi(model.implementation,imps{i}), 
    disp([imps{i} ' simulation implementation of training works properly']);
  else
    disp([imps{i} ' simulation implementation does not work properly']);
  end
end


disp(' ')
disp(' press <ENTER> to continue')
disp(' '); pause;


disp(' 4. Setting the path:');
disp(' ');
disp(' To access the toolbox from every directory, add this directory to your path:');
disp(' ');
disp(['>> addpath(''' pwd ''')']);
disp(' ');
disp(' To delete this toolbox from your path, use:');
disp(' ');
disp(['>> rmpath(''' pwd ''')']);
disp(' ');
disp(' CAUTION: the files ''lssvmFILE.exe'' and ''simFILE.exe'' need');
disp(' to be in the current working directory when the ''CFILE''');
disp(' implementation is called');
disp(' ');

disp(' ');
disp(' ');
disp('>> pwd');
pwd
disp(' ');
disp(' Installation completed .');
disp(' ');

disp(' To start working with the toolbox, try one of  ');
disp(' the demo''s:');
disp(' >> demofun');
disp(' >> democlass');
disp(' >> demomodel');
disp(' >> demo_yinyang');
disp(' >> demo_fixedsize');
disp(' >> demo_fixedclass');
disp(' ');


