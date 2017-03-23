cd ~/data/g10
jnm=dir('*.new.lfp');
k=4
    cd ~/data/g10

    mfile=memmapfile(jnm(k).name,'Format','double');
    x=mfile.Data;
    cd(['/gpfs01/sirota/bach/data/gerrit/analysis/', jnm(k).name(1:12)])
    nf=fopen(jnm(k).name([1:13,18:end]),'w');
    fwrite(nf,x,'int16');
    fclose(nf)
    clear mfile x
