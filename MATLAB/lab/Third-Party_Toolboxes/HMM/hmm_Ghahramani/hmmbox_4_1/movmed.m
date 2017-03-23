function [filt_data] = movmed (data,filter_order);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    [filt_data] = MOVMED (data,filter_order);
%  
% performs moving average filter operation for 1D data. The segement size, 
% over which to average is specified by filter_order.
% 
% The filtered sample is at filter_order/2
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (size(data,1)<size(data,2)) data=data'; end;
N=size(data,1);
ndim=size(data,2);

disp(sprintf('Filtering done for %d vector samples in %d dimension(s)',N,ndim));
if (nargin<2) filter_order=10; disp('Using Filter Order 10'); end;
half_fo=floor(filter_order/2);

data=[data(N-half_fo+1:N,:); data; data(1:half_fo,:)];
filt_data=zeros(N,ndim);
j=1;
hand=waitbar(0,'Median Filtering');
for i=1:N,
  filt_data(j,:)=median(data(i:i+filter_order-1,:));
  j=j+1;
  waitbar(j/N);
end;
close(hand);

