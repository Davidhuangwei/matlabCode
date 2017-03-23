function ip = read_data(filename)
%% function ip = read_data(filename)
%%    read data file
%%    format: number_vectors vector_dimension
%%            vectors (one per line)
%%
%%   Copyright 2002 Oregon Health and Science University
%%   Author: Cynthia Archer 
%%

fid = fopen(filename, 'r');
if (fid == -1)
   disp('Error opening data file');
   ip = [];
   return;
end;

no_ip = fscanf(fid, '%d',1);
ip_dim = fscanf(fid, '%d', 1);
[ip, count] = fscanf(fid, '%g', [ip_dim, no_ip]);
ip = ip';
fclose(fid);
if (count ~= no_ip*ip_dim)
    disp('Error reading data file');
    return;
end;
