function trials = TrialsWithin(x,intvs,trialitvs)
%
% find all points of x that are within ranges of intvs and find all
% points of x that belong to each of the intervalls trialitvs.
% intvs is in units of x. trialitvs is in samples of x.
%

goodx = WithinRanges(x,intvs);
goodintrial = WithinRanges([1:length(x)],trialitvs,[1:size(trialitvs,1)]','vector');
within = goodx.*goodintrial';

for tt = 1:length(trialitvs);
  indx = find(within==tt);
  if ~isempty(indx)
    trials(tt,:) = [min(indx) max(indx)];
  else
    continue;
  end
end

return;

%steps = find(goodx - goodx.*[goodx(1);goodx(1:end-1)].*[goodx(2:end);goodx(end)]);
%for tt = 1:length(trialitvs);
%  within = steps(find(WithinRanges(steps,trialitvs(tt,:))));
%  trials(tt,:) = [min(within) max(within)];
%end
%return;
