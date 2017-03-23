function whl = GetWheelSpeed(whl)


%% max size of jump
MaxWheel = (max(whl.extra)-min(whl.extra))*0.45; 

%% jumpsize
MaxJump = round(max(abs(diff(whl.extra)))/1000)*1000

%% unwrap whl speed
jumps = find(abs(diff(whl.extra))>MaxWheel);
newextra=whl.extra;
for n=1:length(jumps)
  newextra(jumps(n)+1:end) = newextra(jumps(n)+1:end)-(newextra(jumps(n)+1)-newextra(jumps(n)));
end
whl.turn = newextra;

%% filter turning
FiltFreq = 0.5;
NFreq = whl.rate/2;

%% instantaneous speed
smturn = ButFilter(whl.turn,2,FiltFreq/NFreq,'low');
whl.rotspeed = [0; diff(smturn)];

return;
