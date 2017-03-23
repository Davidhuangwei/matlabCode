function ic = ic_norm(ic);

ic = ic-mean(ic);
[imin imax]=jminmax(ic);
ic=(ic-imin)/(imax-imin);
ic = ic - 0.5;

ic = ic/std(ic);

rem_zeros=0;
if rem_zeros
%Remove values close to zero.

tt=0.05;
z=ic>=0 & ic<tt;
zz=(z==0); ic = ic.*zz;
ic = ic+z.*min(ic)/2;

z=ic<0.0 & ic>(-tt);
zz=(z==0); ic = ic.*zz;
ic = ic+z.*max(ic)/2;
end;