% computes the available memory in bytes
function HowMuch = FreeMemory()
if isunix
	[junk mem] = unix('vmstat |tail -1|awk ''{print $4} {print $6}''');
	HowMuch = sum(str2num(mem));
    if nargout<1
        fprintf('Free memory : %d Mb (%2.1f Gb)\n',HowMuch, HowMuch/1000);
    end
else
	HowMuch = 200;
	%200Mb for windows machin
	
end