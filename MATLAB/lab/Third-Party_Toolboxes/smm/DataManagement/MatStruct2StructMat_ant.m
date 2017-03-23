function outs = MatStruct2StructMat(ins,varargin)
%function outs = MatStruct2StructMat(ins,fields, dim, withind)
[fields,dim,withind] = DefaultArgs(varargin,{fieldnames(ins(1)),10,0});
%ins =ins(:);
method=2;
outs = struct();
if ~iscell(fields) fields = {fields}; end
nf = length(fields);
Index = [];
strsz = size(ins);
if withind
    for j=1:strsz(2)
        for ii=1:strsz(1)
            if ~isempty(ins(ii,j).(fields{1}))
                sz =size(ins(ii,j).(fields{1}));
                if min(strsz)>1
                    Index = cat(3,Index,repmat([ii j],[1,1,sz(dim)]));
                elseif strsz(1)==1
                    Index = cat(3,Index,repmat(j,[1,1,sz(dim)]));
                else
                    Index = cat(3,Index,repmat(ii,[1,1,sz(dim)]));
                end
            end
        end
    end
end
Index = permute(Index,[3 1 2]);

for ii=1:nf
    f=fields{ii};
    if method == 1 
        strsz = size(ins);
        
        % make sure all sizes match 
        fieldsz = FieldSizes(ins,f);
        %this is a matrix of sizes for this field
        [usz dummy inrow] = unique(fieldsz,'rows');
        %find which size is lonest - that should be the standard for others
        [dummy longest] = max(sum(usz>1,2));
        right_size = usz(longest);
        
        for k=1:length(right_size)
            
        end
        %now we can go over the elements of array and 
        
         
            
        for j=1:strsz(2)
            for ii=1:strsz(1)
                %now go through 
            end
        end
        
    else  %METHOD 2 - current method ..uses matlab cat function - watch for unaccounted troubles ..
      ftype=0;
      for k=1:length(ins(:))
          if ~isempty(ins(k).(f))
              if ischar(ins(k).(f))
                  ftype = 1;
              else
                  ftype=2;
              end
              break
          end
      end

      if ftype==1
          newval={};
          for k=1:size(ins,2)
              for l=1:size(ins,1)
                  if ~isempty(ins(l,k).(f))
                      newval{end+1,1} = ins(l,k).(f);
                  end
              end
          end

      else
            
            try
%                 if strcmp(f,'sh_p') 
%                     keyboard
%                 end
             %   ins = FixStructDims(ins,f);
                newval =cat(dim,ins.(f));
            catch
                try
                    newval =cat(1,ins.(f));
                catch
                    try
                        newval =cat(2,ins.(f));
                    catch
                        try
                            newval =cat(3,ins.(f));
                        catch
                            warning('cannot cat the field %s',f);
                            continue
                        end
                    end
                    newval = sq(newval);
                end
            end
        end
        if isstruct(newval)
            newval = MatStruct2StructMat(newval,[],dim);
        end
        newval = sq(newval);

    end
    outs  = setfield(outs, f, newval);
    
    if withind
        outs  = setfield(outs, 'Index', Index);
    end
    
end