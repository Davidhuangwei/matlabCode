function vers = V6Save
% used in save function to save file in version 6
% Returns '' if working in version 6.x 
% Returns '-V6' if working later matlab version

v = version;
if str2num(v(1))>6
    vers = '-V6';
else
    vers = '-MAT';
end
return