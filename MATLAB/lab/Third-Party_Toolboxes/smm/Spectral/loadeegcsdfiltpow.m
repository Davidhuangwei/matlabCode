function [eegch,eegfiltch,eegpowch,csdch,csdfilt,csdpow]=loadeegcsdfiltpow(filebase,numeegchan,eegchan,numcsdchan,csdchan,lowband,highband)

eegch=readmulti([filebase '.eeg'],numeegchan,eegchan);
eegfiltch=readmulti([filebase '_' num2str(lowband) '-' num2str(highband) 'Hz.eeg.filt'],numeegchan,eegchan);
eegpowch=readmulti([filebase '_' num2str(lowband) '-' num2str(highband) 'Hz.eeg.100DBpow'],numeegchan,eegchan);
csdch=readmulti( [filebase '_linear_interp.csd'],numcsdchan,csdchan);
csdfilt=readmulti( [filebase '_' num2str(lowband) '-' num2str(highband) 'Hz_linear_interp.csd.filt'],numcsdchan,csdchan);
csdpow=readmulti( [filebase '_' num2str(lowband) '-' num2str(highband) 'Hz_linear_interp.csd.100DBpow'],numcsdchan,csdchan);
return