% Out = StructArray(In)
%
% Flips over a struct array.  So if you have a structure where each field
% is an array, it will turn it into a structure array where each member of
% the array is a structure.  And vice versa
% DOESN'T WORK

function Out = StructArray(In)

Out = [];

if size(In)==[1 1]
	% we are dealing with a single structure whose fields are arrays
	fields = fieldnames(In);
	for i=1:length(fields)
		f = fields{i};
		a = getfield(In, f);
		for j=1:length(a)
			Out = setfield(Out, {j}, f, getfield(In, f, {j}));
       end
    end
else
	% this is easier - turn a struct array into a single struct
	fields = fieldnames(In);
	for i=1:length(fields)
		f = fields{i};
		for j=1:length(In)
            Val = getfield(In, {j}, f);
            if ~isempty(Val)
    			Out = setfield(Out, f, {j}, Val);
            end
		end
    end
end

