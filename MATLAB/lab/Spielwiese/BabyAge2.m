function BabyAge2(due)
% usage: e.g. BabyAge('7.09.2007') or BabyAge('7-September-2007');

daysleft = datenum(due)-datenum(date);
dayspassed = 7*40-daysleft;
day1 = datenum(due)-7*40;
conc = datenum(due)-7*38;

curday = rem(dayspassed,7);
curweek = (dayspassed -curday)/7;

futday = rem(daysleft,7);
futweek = (daysleft -futday)/7;

fprintf('We are %d weeks, %d day(s) old !!\n',curweek, curday);
fprintf('Estimated day 1 : %s\nestimated XXX : %s\n',datestr(day1), datestr(conc));

%fprintf('Left : %d days ',daysleft);
fprintf('Left: %d weeks and %d days(s)\n',futweek, futday);

