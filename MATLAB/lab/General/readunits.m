filename='j2604.002';
%res=cell(3,1);
%clu=cell(3,1);
ind=[1,2,6];
spk=cell(3,1);
for i=1:3
    fnres=[filename '.res.' num2str(ind(i))];
    fnclu=[filename '.clu.' num2str(ind(i))];
    res=load(fnres);
    clu=load(fnclu);
    clu=clu(2:end);
    spk{i}=res(find(clu~=1));
end
