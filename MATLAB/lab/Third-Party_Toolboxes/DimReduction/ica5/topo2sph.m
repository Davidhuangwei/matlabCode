% topo2sph() - convert a topoplot()-style 2-D polar-coordinates 
%              channel locations file to a 3-D spherical-angle
%              file for use with headplot()
% Usage:
%        >> topo2sph('eloc_file','eloc_angles_file');
% Inputs:
%           'eloc_file' = filename of polar 2-d electrode locations file used by topoplot()
%              See >> topoplot('example') or cart2topo()
%           'eloc_angles_file' = output file of electrode locations in spherical angle coords.
%              for use in headplot().
%
% See also: sph2topo(), cart2topo()

% Scott Makeig CNL / Salk Institute, 1999 as pol2sph()
% 3-16-00 changed name to topo2sph() for compatibility with cart2topo() -sm

function topo2sph(eloc_locs,eloc_angles)

MAXCHANS = 1024;

fid = fopen(eloc_locs);
if fid<1,
    fprintf('topo2sph()^G: cannot open eloc_loc file (%s)\n',eloc_locs)
    return
end
E = fscanf(fid,'%d %f %f  %s',[7 MAXCHANS]);
E = E';
fclose(fid);

if exist(eloc_angles)==2,
   fprintf('plo2sph(): eloc_angles file (%s) already exists.\n',eloc_angles);
   return
end

fid = fopen(eloc_angles,'a');
if fid<1,
    fprintf('topo2sph()^G: cannot open eloc_angles file (%s)\n',eloc_angles)
    return
end
for e=1:size(E,1)
   % (t,r) -> (c,h)
   t = E(e,2); % theta
   r = E(e,3); % radius

   if t>=0
      h = 90-t; % horizontal rotation
   else
      h = -(90+t);
   end
   if t~=0
      c = sign(t)*180*r; % coronal rotation
   else
      c = 180*r;
   end
   chan = E(e,4:7);

   fprintf('%d	%g	%g	%s\n',E(e,1),c,h,chan);
   fprintf(fid,'%d	%g	%g	%s\n',E(e,1),c,h,chan);
end

