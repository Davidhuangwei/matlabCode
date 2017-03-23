function v=resexample(t,tao,ts,tt)
v=-(exp(-t/ts).*(t+tao*(1/ts+1))-(tao*(1/ts+1)+tt)*exp(1-tt*(1/ts-1/tao))*exp(-t/tao));
end