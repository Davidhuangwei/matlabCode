%plots a vector v vs index scaled by sample rate sr

function plott(v,sr)
ind=find(v<max(v)+1);
plot(ind/sr,v);
