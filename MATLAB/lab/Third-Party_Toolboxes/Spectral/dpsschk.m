ximum order model must
            %be applied repeatedly
         order = ar_order;
         
         %Increment the index to establish
         %extrapolation of the previously determined
         %autocovariances
         index = index+1;
      end
      h_cov_vv(shift) = ...
         -ar_stack{order}*h_cov_vv(shift:-1:index)';
   end
end

%Create the complete autocovariance function of v from
%the one-sided function determined above
cov_vv = [fliplr(h_cov_vv) h_cov_vv(2:end)];

%The MA contribution to the autocovariances of the
%proces is determined by autocorrelating the MA
%parametervector. The convolution of the AR and MA
%autocovariance sequences provides the autocovariance
%function of the ARMA proces: cov_xx

%Perform this convolution so that a one sided
%autocovariance function will remain after doing so
center = 2*ma_order+n_shift+1;
last = 2*ma_order+2*n_shift+1;
h_cov_xx = convol_e(convolrev_e(ma,ASAcontrol),...
   cov_vv,center,last,ASAcontrol);

%Determine the power gain, variance_x / variance_e, of
%the ARMA proces
gain = h_cov_xx(1);

%Normalize the autocov