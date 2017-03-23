function PutnamValley

TotSum = 920+577;

Names = {
'Kenji' 
'mariano'
'eran'
'shige'
'Pascale'
'Anton'
'Simal'
'Eva'
'Carina'
'Andres'
'Kamran'
'Jagdish'
'Stefan'
};

Days = {
    'Fri eve'	
    'Sat  mor'	
    'Sat noon'
    'Sat eve'
    'Sun mor'
    'Sun noon'
};


Occ = [0 0 0 2 2 2;
       0 0 0 2 0 0;
       0 0 0 1 0 0;
       0 0 0 1 1 0;
       0 0 1 1 1 1;
       0 0 3 3 3 3;
       0 0 0 1 0 0;
       1 1 1 0 1 1;
       2 2 2 2 2 2;
       0 0 0 1 1 1;
       0 0 0 1 0 0;
       1 1 1 1 1 1;
       0 0 1 1 1 1]
sumOcc = sum(Occ)

ndays = length(Days);
nnames = length(Names);

mOcc = Occ.*repmat(sum(Occ),nnames,1);

%pOcc = ceil(mOcc*TotSum/sum(mOcc(:)));
pOcc = round(mOcc*TotSum/sum(mOcc(:)));

sumOcc = sum(pOcc,2);

Spend = [0 0 0 0 0 577 0 920 0 0 0 0 0]';


Pay = ceil(pOcc)

for n=1:nnames
  fprintf([Names{n} '(' num2str(max(Occ(n,:))) ')' ' : ' num2str(sumOcc(n)-Spend(n)) '\n']);
end

fprintf(['\n Sum  : ' num2str(sum(sumOcc)) '\n']);

fprintf(['\n rel Sum  : ' num2str(sum(sumOcc-Spend)) '\n']);



imagesc(pOcc)
set(gca,'TickDir','out','XTickLabel',Days,'YTick',[1:nnames],'YTickLabel',Names)
box off



