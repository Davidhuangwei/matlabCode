function out = uniquefn(FileBase,varargin)
up = userpath;
if FileExists([up(1:end-1) '/mydata/rats/allrats.uid'])
    [fstr,fid] = textread('/u12/antsiro/mydata/rats/allrats.uid','%s %d');
    out = fid(find(strcmp(fstr,FileBase)));
else
    fnnum = double(FileBase);
    out = str2num([num2str(sum(fnnum(1:2:end))) num2str(sum(fnnum(2:2:end)))]);
end
return

%first way - just sum of ascii codes

%num2str(sum(fnnum(2:2:end)))]);

%some more fancy algorythm 
maxint = 2^12;
phi = 0.6180339887498947;

fnint= '';
for i=1:length(fnnum)
    fnint = sprintf('%s%s',fnint,num2str(fnnum(i)));
end
%keyboard
fnint = str2num(fnint);
a = phi*fnint
keyboard
out = round(maxint*(a-floor(a))); %since a-floor(a) has to be unique when phi is irrational, fnint - integer
fprintf('integer %30.2f \n %15.1f',fnint,out);
