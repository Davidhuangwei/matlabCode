%   RUN_S_POWERS        Wrapper function for s_power.
%
%       call:   POWER_MAT = RUN_S_POWERS(N,NS), 
%               where N is the number of observations/sample (vector)
%               and NS is the number of samples (scalar).

function power_mat = run_s_powers(n,NS)

row = 0;
for i=n
    row = row + 1;
    power_mat(row,:) = s_power(i,pi,[0:0.1:2 2.5:0.5:4],NS);
    fstr = sprintf('s_power_%s_%s_%s',num2str(NS),num2str(i),datestr(now,30))
    save(fstr,'power_mat','i','NS')
end
%for i=n+1:2*n
%    power_mat(i,:) = s_power(2,pi,[0:0.1:2],NS,2);
%end

fstr = sprintf('s_power_%s_all_%s',num2str(NS),datestr(now,30))
save(fstr,'power_mat','n','NS')
