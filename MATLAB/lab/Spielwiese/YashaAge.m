function YashaAge(varargin)
%
% how to use:
%  YashaAge(birthdate,date,name)
%  default: birthdate = '2-September-2007'
%           date = today
% examples:
%   >> YashaAge
%
%   ======================================
%   Yashas birthday is 2-September-2007
%   On 11-Feb-2008 Yasha is
%   162 day(s) or
%   23 week(s) and 1 day(s) or
%   5 month(s) and 9 days(s) old!!
%   0 year(s), 5 month(s) and 9 days(s) old!!
%   ======================================
%
%   >> YashaAge('26-April-1976','2-September-2007','Anton')
%
%   ======================================
%   Antons birthday is 26-April-1976
%   On 2-September-2007 Anton was
%   1635 week(s) and 6 day(s) or
%   376 month(s) and 7 days(s) old!!
%   31 year(s), 4 month(s) and 7 days(s) old!!
%   ======================================

%% default arguments
[birth today name] = DefaultArgs(varargin,{'2-September-2007',date,'Yasha'});

%% number of days passed
dayspassed = datenum(today)-datenum(birth);

%% turn into weeks and days
curweek = floor(dayspassed/7);
curday = rem(dayspassed,7);

%% get date vectors
vbirth = datevec(birth);
vdate = datevec(today);

%% years
yearadjust = (vbirth(2)-vdate(2))>0;
years = vdate(1)-vbirth(1)-yearadjust;

%% months
monthsadjust = (vbirth(3)-vdate(3))>0;
months = mod(vdate(2)-vbirth(2),12) - monthsadjust;

%% days 
if vbirth(3)<=vdate(3)
  days = vdate(3)-vbirth(3);
else
  %% count days backward from today to same day of previous month
  tday = datevec(datenum(today)-1);
  days=0;
  while vbirth(3)-tday(3)
    days=days+1;
    tday = datevec(datenum(today)-days);
  end
end

if datenum(today)<datenum(date)
  %gram = 'were';
  gram = 'was';  
else
  %gram = 'are';
  gram = 'is';
end

fprintf('\n======================================\n');
fprintf('%ss birthday is %s\n',name,birth);
fprintf('On %s %s %s \n',today,name,gram);
fprintf('%d day(s) or \n',dayspassed);
fprintf('%d week(s) and %d day(s) or \n',curweek, curday);
fprintf('%d month(s) and %d days(s) old!!\n',years*12+months,days);
fprintf('%d year(s), %d month(s) and %d days(s) old!!\n',years,months,days);
fprintf('======================================\n\n');

