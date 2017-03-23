function num = IsProject(FileBase,ident,varargin)
%%
%% in a structure 'project' the selection of files for certain projects is saved.
%%
%% example: project.SVMU = 1  : this file is used ini the project SVMU
%%
%% INPUT: 
%%    ident : project identification (e.g. 'SVMU')
%%
%% OUTPUT:
%%    num : 1 or 0 depending on in this file is used in the project 'ident'
%% 
[overwrite] = DefaultArgs(varargin,{0});
%%

if ~FileExists([FileBase '.project'])
  num = input(['\n Do you want to use this file for project ' ident ' [0/1]? ']);
  project = struct(ident,num);
  save([FileBase '.project'],'project')
else

  load([FileBase '.project'],'-MAT');
  
  if ~isfield(project,ident) | overwrite
    num = input(['\n Do you want to use this file for project ' ident ' [0/1]? ']);
    project = setfield(project,ident,num);
    save([FileBase '.project'],'project')
  else
    num = getfield(project,ident);
  end
end
return;
