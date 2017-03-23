function KenjiLinkDatsBat01(fileBaseCell,datDir,testBool)

cwd = pwd;
for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j};
    cd(fileBase)
    evalText = ['!ln -s ' datDir fileBase '.dat .'];
    EvalPrint(evalText,testBool);
    cd(cwd)
end