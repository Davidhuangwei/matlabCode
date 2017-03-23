% function outBool = CheckStructSim(struct1,struct2)
function outBool = CheckStructSim(struct1,struct2)

if ~isstruct(struct1)
    outBool=1;
else
    struct1Fields = fieldnames(struct1);
    struct2Fields = fieldnames(struct2);
    if length(struct1Fields)~=length(struct2Fields)
        outBool = 0;
    else
        for j=1:length(struct1Fields)
            if ~strcmp(struct1Fields{j},struct2Fields{j})
                outBool = 0;
            else
                outBool = CheckStructSim(struct1.(struct1Fields{j}),struct2.(struct2Fields{j}));
            end
        end
    end
end
return