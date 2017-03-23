function nranges = NoOverlapRanges2(ranges)

% function nranges = NoOverlapRanges(ranges)
% output: non-overlapping ranges
% input:  ranges as two column vector [starts stops] of ranges

%% Sort Ranges
ranges = sort(ranges,2);
ranges = sortrows(ranges,1);

%% put into vectro:
Vranges = reshape(ranges',1,size(ranges,1)*2)';

%% its a two step process:
%% 1. find Beginnings that are before previous Ends.
%% 2. identify neigboring Beginning that comes first. 

%% find 'bad' intervals
BadInvs = diff(Vranges)<=0;

if isempty(find(BadInvs))
  nranges=ranges;
else
  
  AA = ones(size(ranges));
  for n=1:size(ranges,1)
    BB = AA;
    AA(find(WithinRanges(ranges(:,1),[ranges(n,1)+1 ranges(n,2)-1])),1)=0;
    AA(find(WithinRanges(ranges(:,2),[ranges(n,1)+1 ranges(n,2)-1])),2)=0;
    %% take care of doubles
    xx = find(ranges(:,1)==ranges(n,1));
    if length(xx)>1
      AA(xx(find(xx)>1),1)=0;
    end
    xx = find(ranges(:,2)==ranges(n,2));
    if length(xx)>1
      AA(xx(find(xx)<length(xx)),2)=0;
    end
  end
  
  if length(find(AA(:,1)))~=length(find(AA(:,2)))
    keyboard %error('something is wrong in NoOverlapRanges.m')
  end
  
  nranges(:,1) = ranges(find(AA(:,1)),1);
  nranges(:,2) = ranges(find(AA(:,2)),2);
end

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  while ~isempty(find(BadInvs))
    AA = find(BadInvs)+1;
    BadBeg = zeros(length(Vranges),1);
    BadEnd = zeros(length(Vranges),1);

    BadBeg(AA) = 1;
    
    for n=1:length(AA) 
      if (Vranges(AA(n)+1)-Vranges(AA(n)-1))>0
	BadEnd(AA-1)=1;
      else
	BadEnd(AA+1)=1;
      end
    end
    NVranges = Vranges(~(BadBeg | BadEnd));
    Vranges = [];
    Vranges = NVranges;
    
    BadInvs = [];
    BadInvs = diff(Vranges)<=0;
    n
  end
  keyboard
  nranges = reshape(Vranges,2,length(Vranges)/2)';
  