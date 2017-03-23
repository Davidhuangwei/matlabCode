% Usage: EEGExtract('filename', [NumCh Samples], [ExtractBegin ExtractEnd], ChNum);
% OR
% Usage: EEGExtract('filename', [NumCh Samples], [ExtractBegin ExtractEnd], [ChNum1, ChNum2,...]);
%
% Example: EEGExtract('filename', [8 inf], [1 2], 1);
%
%    Where: 'filename' is an eeg file with 8 channels, load the entire sample with inf
%           extracting from 1 to 2 seconds from channel 1.
%
% This extracts a portion of the eeg file and either outputs it to another eeg file
% or to an eps format picture.

function EEGExt(FileBase, arg1, arg2, ChNum);

if (nargin<4)
  error('Incorrect Usage. For help type help EEGExtract... aborting');
end;

filename = ([FileBase '.eeg']);
fn = fopen(filename,'r');
datasize = 'short';
sRate = 1250;

if (arg2(1)==1)
   eegbegin = 1;
  else
   eegbegin=round(arg2(1)*sRate);
end;

eegend = round(arg2(2)*sRate);

fprintf('\nLoading files...\n');
eegAll = fread(fn, arg1, datasize);
EEGextrt = eegAll(ChNum,eegbegin:eegend) ;

%figure(1)
% hold on;
% %plot(eegAll(ChNum(1),eegbegin:eegend));
% j = 0;
% if ((size(ChNum,2))>1)
%   for i = 2:(size(ChNum,2))
%     j = j-400;
%     junk=eegAll(ChNum(i),eegbegin:eegend)-j;

%     if (i==2)
 %      %plot(junk,'r');
  %   end;

  %   if (i==3)
       %plot(junk,'g');
   %  end;

%     if (i==4)
       %plot(junk,'m');
 %    end;

  %   if (i==5)
       %plot(junk,'c');
   %  end;

%     if (i==6)
       %plot(junk,'y');
 %    end;

  %   if (i==7)
       %plot(junk,'k');
   %  end;

    % if (i==8)
       %plot(junk,'b');
     %end;

  % end;
% end;

% grid off;
% xlabel('Time (ms)');
% ylabel('Amplitude (mv)');
% hold off;

%questionsavefig = input('\nDo you want to save this figure? ','s');
%questionsaveeeg = input('\n\nDo you want to save this as a .eeg? ','s') ;

%pict = strcat(FileBase,'_extract');
eegsave = strcat(FileBase, '_extract.eeg');
questionsaveeeg='y';

%if (questionsavefig=='y')
%  print ( '-f1', '-depsc2', pict);
%end;

if (questionsaveeeg=='y')
  bsave(eegsave,EEGextrt,'integer*2');
end;
close all;
fclose all;

%-------------------------------------------------------------------------------
%function Color = colorselect(tempnum)

%switch tempnum;
%case (tempnum==2)
%  Color = 'r';

%case (tempnum==3)
%  Color = 'g';
%end;





