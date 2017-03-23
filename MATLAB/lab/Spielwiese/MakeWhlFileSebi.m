function MakeWhlFileSebi(FileBase,dirname,varargin)



cc = LoadStringArray([FileBase '.srs']);
cl = load([FileBase '.srslen']);


for n=1:length(cc)

  filename = [dirname '/' cc{n} '.mat'];
  
  if FileExists(filename)
    xx = load(filename,'-MAT')
    keyboard
    
  end
    
end



