%   VM_RND          A first attempt.

% directional statistics package
% Dec-2001 ES

function theta = vm_rnd(myu0,k,n,show);

if nargin<4
    show = 0
end
% given myu and k, we can compute the value of any 0<theta<=2*pi using:
% vm = 1/(2*pi*besseli(0,k))*exp(k*cos(theta-myu0))

% we can also find the minimum & the maximum of the function:

vm_min = 1/(2*pi*besseli(0,k))*exp(-k);
vm_max = 1/(2*pi*besseli(0,k))*exp(k);
%vm_min_max = [ vm_min vm_max ]

% we then select a random value in that range
rnd = vm_max - rand(n,1)*(vm_max-vm_min);% + vm_min;

% and use the inverse vm function to find the angle
% acos_arg = log(rnd*2*pi*besseli(0,k))/k
% if acos_arg>1
%     acos_arg = 1
% elseif acos_arg<-1
%     acos_arg = -1
% end
% temp = acos( acos_arg );
temp = acos( log(rnd*2*pi*besseli(0,k))/k );

% since acos is ambiguous, we choose a direction
% if round(rand(n,1))
%     theta = myu0 + temp
% else
%     theta = myu0 + 2*pi - temp
% end

dir = round(rand(n,1)); % if 0 - myu0+temo; if 1 - myu0+2*pi-temp
theta = myu0 + dir*2*pi + ~dir.*temp - dir.*temp;
theta = mod(theta,2*pi);

if show
    dir_mean(theta,ones(length(theta),1),'compass');
end