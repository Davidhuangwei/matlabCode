% function outStruct = MergeStructs(struct1,struct2)
function outStruct = MergeStructs(struct1,struct2)


if ~isstruct(1
struct1Fields = fieldnames(struct1);
struct2Fields = fieldnames(struct2);

outStruct = [];

for j=1:length(struct1Fields)
    if any(strcmp(struct2Fields,struct1Fields{j}))
        if isstruct(struct1.(struct1Fields{j})) | isstruct(struct2.(struct2Fields{j}))
            junk = MergeStructs(struct1.(struct1Fields{j}),struct2.(struct2Fields{j}));
        else
            if struct1.(struct1Fields{j})~=struct2.(struct1Fields{j})
                ERROR_STRUCT_FIELDS_WITH_DIFFERENT_VALUES
            end
        end
    end
    outStruct.(struct1Fields{j}) = struct1.(struct1Fields{j});
end

for j=1:length(struct2Fields)
    outStruct.(struct2Fields{j}) = struct2.(struct2Fields{j});
end

    
return



%% testing %%
   infoStruct = [];
    infoStruct = setfield(infoStruct,'whlSamp',1);
    infoStruct = setfield(infoStruct,'eegSamp',2);
    infoStruct = setfield(infoStruct,'minSpeed',3);
    infoStruct = setfield(infoStruct,'winLength',4);
    junk1 = infoStruct;
   
    infoStruct = [];    
    infoStruct = setfield(infoStruct,'midPointsBool',5);
    infoStruct = setfield(infoStruct,'trialTypesBool',6);
    infoStruct = setfield(infoStruct,'excludeLocations',7);
    infoStruct = setfield(infoStruct,'fileExt',8);
    infoStruct = setfield(infoStruct,'calcTimeFunc',9);
    junk2 = infoStruct;
    
        infoStruct = [];    
    infoStruct = setfield(infoStruct,'whlSamp',1);
    infoStruct = setfield(infoStruct,'eegSamp',2);
     infoStruct = setfield(infoStruct,'midPointsBool',5);
    infoStruct = setfield(infoStruct,'trialTypesBool',6);
    infoStruct = setfield(infoStruct,'excludeLocations',7);
    infoStruct = setfield(infoStruct,'fileExt',8);
    infoStruct = setfield(infoStruct,'calcTimeFunc',9);
    junk2 = infoStruct;
   
