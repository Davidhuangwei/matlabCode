rsync localDir/files host@distalDir
md5sum localDir/Files > CheckSumFile
rsync CheckSumFile host@distalDir
ssh host cd distalDir md5sum -c CheckSumFile

rsync host@distalDir/files LocalDir
ssh host cd distalDir; md5sum localDir > CheckSumFile
rsync host@distalDir/CheckSumFile LocalDir
md5sum -c LocalDir/CheckSumFile


RSyncCheck options sourcefiles destinationDir


case source=local
cwd = pwd
host = before:destinationDir
rsync options sourcefiles destinationDir
md5sum sourcefiles > CheckSumFile
rsync CheckSumFile destinationDir
ssh host cd destinationDir md5sum -c CheckSumFile
cd cwd


case source=distal
cwd = pwd
host = before:sourcefiles
rsync options sourcefiles destinationDir
ssh host md5sum sourceFiles > CheckSumFile
rsync host:CheckSumFile destinationDir
cd destinationDir
md5sum -c CheckSumFile
cd cwd

