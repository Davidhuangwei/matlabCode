%write current parameter output file script
% format: M, part_type, fit_noise, fit_dim, seed, dimension
%         noises
%         dimensions
%         priors
%         means (1 vector per row)
%         variances (1 vector per row) 
%         eigenvectors (dimension vectors per row)

%  part_type is 1 for soft partitioning, 0 for hard partitioning
%  fit_noise is 1 if noise fit to data; 0 otherwise
%  fit_dim is 1 if dimension fit to data; 0 otherwise

%%
%%   Copyright 2002 Oregon Health and Science University
%%   Author: Cynthia Archer 
%%


if (ptype==1) 
    typstr = 'soft';
else
    typstr = 'hard';
end;
if (~dfit)
    if (~nfit)
       initfile = sprintf('%s_M%d_%s_n%.2f_d%d_r%d', namebase, M, typstr, noise, dim, rseed);
   else
       initfile = sprintf('%s_M%d_%s_n_d%d_r%d', namebase, M, typstr, dim, rseed);
   end;
else
   initfile = sprintf('%s_M%d_%s_n%.2f_d_r%d', namebase, M, typstr, noise, rseed);
end;
parfile = sprintf('%s.par', initfile)
fid = fopen(parfile, 'w');
if (fid == -1)
   disp('Error opening parameter initialization file');
   return;
end;
fprintf(fid, '%d %d %d %d %d %d\n', M, ptype, nfit, dfit, rseed, ip_dim);
if (nfit)
    fprintf(fid, '%g \n', ns(1:M));
else
    fprintf(fid, '%g \n', noise*ones(1,M));
end;
fprintf(fid, '%d \n', d);
fprintf(fid, '%g \n', p);
for i=1:M
    fprintf(fid, '%g ', m(i,:));
    fprintf(fid, '\n');
end;
for i=1:M
    fprintf(fid, '%g ', V(i,:));
    fprintf(fid, '\n');
end;
for i=1:M
    U = W(:,:,i);
    fprintf(fid, '%g ', U);
    fprintf(fid, '\n');
end;
fclose(fid);


asgnfile = sprintf('%s.ras', initfile);
fid = fopen(asgnfile, 'w');
if (fid == -1)
   disp('Error opening region assignment file\n');
   return;
end;
fprintf(fid, '%d %d \n', no_ip, M);
fprintf(fid, '%d ', asgn);
fclose(fid);
%keyboard;



