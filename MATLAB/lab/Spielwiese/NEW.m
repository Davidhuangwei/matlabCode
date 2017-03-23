function out=NEW(FileBase,varargins)
[overwrite] = DefaultArgs(varargins,{0});
%%
%% function to estimate the gain of the firing rate depending on speed
%% 
%% input: FileBase - it will look for spiking information in the place fields.
%% 
%% ALSO:: 
%% -- how does the area of firing changes depending on the speed?
%% -- These are all bad data, because most of the place fields are in the corner where the 
%%    rat does not have a constant speed but accellerates or decellerates.
%%    That makes the estimates very very difficult....
%% -- Use only best cells and good trials.

%% How to estimate the tuning curves? 
%% => Binning the instantaneous speed might help, if the rate-speed-relationship is instantaneous.
%% ==> check!!! is the speed-rate relationship instantaneous? Compute rate vs. speed vs. space
%%     for space bins for one cell over all trials.
%% => 

%% How to get the single cell's clock right?
%% => Power of the single cells versus field.   
%% ==> (1) Independent of speed: the single cell oscillates faster than the field.
%%     (2) Speed speeds up the clock. Is This equivalent to the rate change?
%% => Looking for significance. 
 
%% Get the data:
%% spiketimes and possitons.



spiket = 