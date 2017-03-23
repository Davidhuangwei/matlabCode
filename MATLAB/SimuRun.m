function SimuRun(FileBase, Syn, Cls,initC,simutime, RecDir)
% function SimuRun(FileBase, Syn, Cls,initC,simutime, RecDir);
% run simulation of the network in LFPNetGenerator.m
% inputs: 
% FileBase: defult: LFPNetGenerator.data.n.mat
% Syn: co
% Cls
% initC
% simutime
% RecDir
% 
% in constructing:
% connection matrix should have all 1/tau+or - 2*1/Ra entrys in hte diag
% while the connected ones have - or + 1/Ra in rows.
% then we also have the connection in by synapsis. 
% 1. synapses have their own activity recorded.
% 2. the connection matrix is ncomp*nsyn
% 3. the injected currents and the activity of the synapses should be
% recorded. activity of the synapses is recorded as connection matrix *syn
% 4. synaptic activity only use exp or say, 1st order 
% 5. active channels can be added directly to the voltage at every time
% point
% 6. the time step be 0.05 ms.
% 7. LFP recording step: 0.8 ms.
% 8. the synaptic activity is recorded the same time as LFP
% 9. the noise. 
% 1) how to record the noise? if the kernel is designed as
% causal filter, then the noise effect before should be recorded. however,
% the noise during the recording interval is not tracable. 
% 2) say that the noise is somehow iid, then probably is everaged out
% during the integration in the interval. 
% 3) so, let's try start with recording the instantineous noise first. 
% 10. because the Ra is not consistant along the cell, so it's not possible
% to only use converlution. <-- well i can test it. 
% the input could directly merged into the activity of syn input. not
% necessare to have another neuron network. 

if isempty(RecDir)
    RecDir='~/data';
end
cd(RecDir)
if isempty(FileBase)
    exds=dir('LFPNetGenerator.data.*');
    FileBase=sprintf('LFPNetGenerator.data.%d.mat',length(exds)+1);
end

lfp=zeros