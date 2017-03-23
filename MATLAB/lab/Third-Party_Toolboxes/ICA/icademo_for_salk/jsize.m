function jsize(m,str);

if nargin>1
fprintf('%s: ',str);
end;

fprintf('jsize = ');
fprintf(' %d ',size(m));
fprintf('\n');
