mkdir OldAnal
mv *.100DB* OldAnal
mv *.filt OldAnal
mv alter* OldAnal
rm *.HIS
rm *.MRS
rm *.SLV

mkdir analysis
mkdir processed
mv *.eeg processed
mv *.spots processed
mv *.xml processed
mv *.led processed

mkdir dats
reorgDat2Dir *.dat
mv *.dat dats

mkdir m1vs
mv *.m1v m1vs
mkdir htms
mv *.htm htms
mv sm96* analysis

reorgDat2Dir *.dat
reorgeMvWhlInd *_whl_indexes.mat
cd ../processed
reorgEegEtc2Dir *.eeg

cd ../analysis
reorgProcLinks



for i in sm9608_*
do
cd $i
ln -s ../../processed/$i/$i.* .
cd ..
done

#!/usr/bin/perl
foreach $i (@ARGV) {
    if  ($i =~ /(.*).dat/){
        print("mkdir $1\n");
        system("mkdir $1");
        print("rm $1.dat\n");
        system("rm $1.dat");
        }
}

#!/usr/bin/perl
foreach $i (@ARGV) {
    if  ($i =~ /(.*)_whl_indexes.mat/){
        print("mv $1_whl_indexes.mat $1/\n");
        system("mv $1_whl_indexes.mat $1/");
        }
}

cd ../processed

#!/usr/bin/perl
foreach $i (@ARGV) {
    if  ($i =~ /(.*).eeg/){
        print("mkdir $1\n");
        system("mkdir $1");
        print("mv $1.* $1/\n");
        system("mv $1.* $1/");
        }
}

cd ../analysis01

for i in sm9608_*
do
cd $i
ln -s ../../processed/$i/$i.* .
cd ..
done

