%function NeuroClass(FileBase,ElLoc,Overwrite)
function NeuroClass(FileBase,varargin)
%par = LoadPar([FileBase '.par']);
par = LoadXml([FileBase '.xml']);
[ElLoc,Overwrite] = DefaultArgs(varargin,{[1:par.nElecGps],0});

if isstr(ElLoc(1))
    El = find(strcmp(par.ElecLoc,ElLoc));
else
    El = ElLoc;
    ElLoc='all';
end
savefn =[FileBase '.type'];
if ~strcmp(ElLoc,'all') & isstr(ElLoc)
    savefn=[savefn '-' ElLoc];
end
if FileExists(savefn) & ~Overwrite 
    fprintf('File already exists, NO overwrite \n');
    return;pwd
end
if isempty(El) 
    fprintf('No cells in location %s\n',ElLoc);
    return;
end
global struct gINSGUI
gINSGUI.UseElec = El;
gINSGUI.ElecLoc = ElLoc;

gINSGUI.FileBase =FileBase;

INSGUI;


