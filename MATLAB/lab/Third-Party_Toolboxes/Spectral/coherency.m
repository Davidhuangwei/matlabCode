e, showing this information concerning the selection of an')
disp('  optimal AR-model from the data results in,')
disp(' ')
disp('sellog.ar =')
disp(' ')
disp(sellog.ar)
disp(' ')
disp('  and retrieving the estimated AR parameter vector provides,')
disp(' ')
disp('sellog.ar.ar =')
disp(' ')
disp(sellog.ar.ar)
disp(' ')

% This example demonstrates how to limit computing time if some knowledge is 
% present about the data to be analyzed.
disp('  For this simple process, the same final selection result can be obtained')
disp('  using a limited set of AR, MA and ARMA models as possible candidates for')
disp('  selection. For example, let us limit the maximum order models to AR(100),')
disp('  MA(20) and ARMA(10,9). To do this we use,')
disp(' ')
disp('[ar_alt ma_alt sellog_alt] = armasel(y,0:100,0:20,0:10);')
disp(' ')
disp('  since candidate orders are optional input arguments for ''armasel''.') 
disp(' ')

[ar_alt ma_alt sellog_alt]=armasel(data,0:100,0:20,0:10);

disp('  The estimated parameters and the computing time can be compared with the')
disp('  previous results. The estimated AR parameters are,')
ar_alt
disp('  and the estimated MA parameters are,')
ma_alt
disp('  The computing time is now reduced to:')
disp(' ')
disp(['  ****   ' num2str(sellog_alt.comp_time) ' seconds   ****'])

% Assessing the accuracy of the estimated model
% ---------------------------------------------

disp(' ')
disp('  The model error ME is a measure for the accuracy of the estimated model.')
disp('  The ME measures the difference between the estimated model and the true')
disp('  process by,')
disp(' ')
disp('ME = moderr(ar_est,ma_est,ar_true,ma_true,n_obs);')
disp(' ')
disp('  which results in,')

ME=moderr(ar_est,ma_est,ar_true,ma_true,n_obs)

disp('  The theoretical asymptotic expectation of the ME is the number of parameters')
disp(['  in the model, which equals ' ...
      num2str(length(ar_true)+length(ma_true)-2) ' in this example.'])

% Computation of autocorrelations and power spectral density of data
% ------------------------------------------------------------------

disp(' ')
disp('  The Power Spectral Densities of true and estimated models will now be')
disp('  compared. To plot the spectrum of the true process,')
disp(' ')
disp('arma2psd(ar_true,ma_true);')
disp(' ')
disp('  is invoked without output arguments.')
disp(' ')

hold off
figure(1)
arma2psd(ar_true,ma_true);

disp(' ')
disp('  After turning on the hold status, a second graph can be plotted in the')
disp('  figure using ''arma2psd'', while line colors are automatically varied.')
disp(' ')

hold

disp(' ')
disp('  The spectrum of the estimated model is added to the figure using,')
disp(' ')
disp('arma2psd(ar_est,ma_est);')

arma2psd(ar_est,ma_est);
handles = get(gca,'children');
handles = [handles(6);handles(3)];
legend(handles,'true','estimated',3);
title('True and estimated Power Spectral Density ( log-scale )')
hold off;

disp(' ')
disp('  In addition, 50 values of the estimated autocorrelation function and 129')
disp('  values of the estimated power spectral density are determined numerically')
disp('  with,')
disp(' ')
disp('psd_est = arma2psd(ar_est,ma_est);')
disp('cor_est = arma2cor(ar_est,ma_est,50);')
disp(' ')
disp('  The same is done for the parameter vectors of the true process.') 

% Computation of Power Spectral Density
% Use the default number of 129 frequencies for evaluation of Power Spectral Density
[psd_true frequencies]=arma2psd(ar_true,ma_true);
psd_est=arma2psd(ar_est,ma_est);
% Computation of 50 autocorrelations
cor_est=arma2cor(ar_est,ma_est,50);
[cor_true]=arma2cor(ar_true,ma_true,50);

disp(' ')
disp('  The results of the experiment are displayed in four figures:')
disp(' ')
disp('  Figure 1 shows the true spectrum and the estimated time series spectrum.')
disp('  Figure 2 shows the true and the estimated autocorrelations.')
disp('  Figure 3 shows estimated accuracies of all estimated models.')
disp('  Figure 4 compares the raw periodogram with the time series spectrum.')

figure(2)
plot(0:50,cor_true,0:50,cor_est)
title('True and estimated autocorrelation function')
xlabel('\rightarrow time shift')
ylabel('\rightarrow normalized autocorrelation')
legend('true','estimated')

figure(3)
plot(sellog.ar.cand_order,sellog.ar.pe_est)
title('Estimated model accuracy as a function of the model order and type')
xlabel('\rightarrow model order r')
ylabel('\rightarrow normalized model accuracy')
axis([0 500 0.9 2])
hold on
plot(sellog.arma.cand_ar_order,sellog.arma.pe_est,'g')
plot(sellog.ma.cand_order,sellog.ma.pe_est,'r')
legend('AR(r)','ARMA(r,r-1)','MA(r)',4)
hold off

% comparison with raw periodogram
periodogram=abs(fft(data).^2);
periodogram=periodogram/std(data).^2/n_obs;

figure(4)
clf
subplot(121)
semilogy(frequencies,psd_true,[0:1:n_obs/2]/n_obs,periodogram(1:n_obs/2+1),'g')
as=axis;
as(2)=.5;
axis(as);
set(gca,'xtick',[0 0.1 0.2 0.3 0.4 0.5]);
legend('true','periodogram')
title('Raw periodogram ')
xlabel('\rightarrow normalized frequency')
ylabel ('\rightarrow logarithmic power spectral density')
subplot(122)
semilogy(frequencies,psd_true,frequencies,psd_est)
axis(as);
set(gca,'xtick',[0 0.1 0.2 0.3 0.4 0.5]);
legend('true','time series estimate')
title('Time series estimate')
xlabel('\rightarrow normalized frequency')

eval(['warning ' warn_state]);
clear('handles','as','warn_state','ans')
who

disp('==============================================================================')
disp('=                           End of DEMO_ARMASA                               =')
disp('==============================================================================')

%Program history
%======================================================================
%
% Version                Programmer(s)          E-mail address
% -------                -------------          --------------
% [2001 3 14 22 5 14]    P.M.T. Broersen        broersen@tn.tudelft.nl

                                      function [cor,gain,ASAcontrol]=arma2cor_e(varargin)
%ARMA2COR_E ARMA parameters to autocorrelations
%   [COR,GAIN] = ARMA2COR_E(AR,MA) determines MAX(LENGTH(AR),LENGTH(MA)) 
%   elements of the right-sided autocorrelation function of the ARMA 
%   process, determined by the parameter vectors AR and MA. The results 
%   of this computation are the autocorrelations COR and the power gain 
%   of the ARMA process GAIN. For an ARMA process characterized by 
%   signals of observations X and random innovations E, the power gain is 
%   defined by VARIANCE(X)/VARIANCE(E).
%   
%   ARMA2COR_E(AR,MA,N_LAG) determines N_LAG lags of the right-sided 
%   autocorrelation 