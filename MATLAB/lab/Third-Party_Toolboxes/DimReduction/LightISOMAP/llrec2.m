
tt = 0;     % total time counter;
k  = 50;    % number of centers for k-means



fprintf('kmeans...     ');
tic;
[tmp,nodes,tmp] = kmeans(X,[],k,0,0,0);  % clustering
D=sqdist(nodes',X');                     % next build graph from Hebbian Rule
[tmp,D]=sort(D);
D=D(1:2,:);
conn = eye(size(nodes,1));
for i=1:size(X,1)
  conn(D(1,i),D(2,i))=1;
  conn(D(2,i),D(1,i))=1;
end;
k=size(nodes,1);
tim=toc;fprintf(' %f secs\n',tim);tt=tt+tim;



fprintf('Dijkstra...   ');tic;
dists=zeros(k);                 % make distance matrix 
for i=1:k;                      % fill in entries for connected nodes
  for j=1:k
    if conn(i,j); 
      dists(i,j)=norm(nodes(i,:)-nodes(j,:));
    end;
  end;
end
[gd,paths] = dijkstras(dists);tim=toc;
fprintf(' %f secs\n',tim);tt=tt+tim;



tic;fprintf('Graph analysis');  % picks out largest connected component
[tmp,firsts] = min(gd==inf);
[comps,I,J]  = unique(firsts);
n_comps      = length(comps);
size_comps   = sum((repmat(J,n_comps,1)==((1:n_comps)'*ones(1,size(gd,1))))'); 
[tmp, comp_order] = sort(size_comps);  %% sort connected components by size
comps = comps(comp_order(end:-1:1));    
size_comps = size_comps(comp_order(end:-1:1)); 
comp=1;                              %% default: use largest component
index=find(J==comp);
gd = gd(index,index);
tim = toc; tt = tt + tim;fprintf(' %f secs\n',tim);
fprintf('largest connected subgraph covers %d of the total %d nodes\n',length(index),k);
k=length(index);
nodes=nodes(index,:);
conn = conn(index,index);



fprintf('mds...        ');
tic;Yn=MDS(gd.^2,6);Yn=Yn{6}';Full_Yn=Yn;
Yn=Yn(:,1:2);tim=toc;fprintf(' %f secs\n',tim);tt=tt+tim;



fprintf('weights...    ');tic; % Computing reconstruction weights w, see LLE paper 
w=zeros(size(X,1),k); options=optimset('LargeScale','off','Display','off');
D=sqdist(nodes',X');[tmp,K]=min(D);for i=1:k;
  I = find(K==i);
  nh = find(conn(i,:));
  nn = length(nh);
  for j=1:length(I);
    lnh = nodes(nh,:) -repmat(X(I(j),:),nn,1);
    C   = lnh*lnh'; 
    C=C+eye(nn)*trace(C)/1000;
    w_tmp = C\ones(nn,1);
    w_tmp = w_tmp/sum(w_tmp);
    w(I(j),nh)=w_tmp';
  end
end
tim=toc; fprintf(' %f secs\n',tim);tt=tt+tim;


tic;fprintf('Projections...');
Y = w*Yn;
Full_Y = w*Full_Yn;
tim=toc;fprintf(' %f\n',tim);tt=tt+tim;



for i=1:size(Full_Yn,2)
  tmp = sqdist(Full_Yn(:,1:i)',Full_Yn(:,1:i)');
  tmp = corrcoef(sqrt(tmp(:)),gd(:)); 
  fprintf('Using %d dims. --> res. distance correlation  %f\n', i, 1-tmp(1,2));
end
tim=toc;fprintf('Dim. analysis  %f secs\n',tim);tt=tt+tim;
fprintf('Total time :   %f\n',tt);


figure(2);clf;hold on;axis off;set(2,'Color',[1,1,1]);gplot(conn,Yn);plot2(Yn);



