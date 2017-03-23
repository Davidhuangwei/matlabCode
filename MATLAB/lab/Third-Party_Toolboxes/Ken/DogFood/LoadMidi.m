function [pitch time] = LoadMidi(fName)

% a very simple script to load a 1 track midi file

fp = fopen(fName, 'r');

Header = fread(fp, 4+4+6, 'int8');