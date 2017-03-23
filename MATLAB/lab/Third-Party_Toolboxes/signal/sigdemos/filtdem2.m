function slide=filtdem2
% FILTDEM2  IIR Filter design demo.
%   This demonstration designs bandpass filters using the YULEWALK, BUTTER,
%   and CHEBY1 functions in the Signal Processing Toolbox
%
%   To see it run, type 'filtdem2'. 
%
%   See also FILTDEM, FILTDEMO.

%   Copyright (c) 1988-98 by The MathWorks, Inc.
% $Revision: 1.1 $

if nargout<1,
  playshow filtdem2
else
  %========== Slide 1 ==========

  slide(1).code={
   '% normalized frequencies and desired frequency response',
   'f = [0 .4 .4 .6 .6  1];',
   'H = [0  0  1  1  0  0];',
   'fs = 1000; % assumed sampling rate',
   'fhz = f*fs/2;',
   ' plot(fhz,H), title(''Desired Frequency Response'')',
   '    xlabel(''Frequency (Hz)''), ylabel(''Magnitude'')' };
  slide(1).text={
   ' Press the "Start" button to see a demonstration of bandpass',
   ' filter design using the YULEWALK, BUTTER and CHEBY1',
   ' functions.',
   '',
   ' >> f = [0 .4 .4 .6 .6  1];',
   ' >> H = [0  0  1  1  0  0];',
   ' >> fs = 1000; % assumed sampling rate',
   ' >> fhz = f*fs/2;',
   ' >> plot(fhz,H), title(''Desired Frequency Response'')',
   ' >> xlabel(''Frequency (Hz)''), ylabel(''Magnitude'')'};

  %========== Slide 2 ==========

  slide(2).code={
   ' plot(fhz,H), title(''Desired Frequency Response'')',
   '    xlabel(''Frequency (Hz)''), ylabel(''Magnitude'')' };
  slide(2).text={
   ' The YULEWALK function allows you to specify a piecewise',
   ' shape for the desired frequency response magnitude.',
   ' YULEWALK then finds an infinite-impulse response filter',
   ' of the desired order that fits the frequency response in a',
   ' least-squares sense.'};

  %========== Slide 3 ==========

  slide(3).code={
   ' plot(fhz,H), title(''Desired Frequency Response'')',
   '    xlabel(''Frequency (Hz)''), ylabel(''Magnitude'')' };
  slide(3).text={
   ' We start by specifying the desired frequency response',
   ' point-wise, with 1.0 corresponding to half the sample rate.',
   '',
   ' >> f = [0 .4 .4 .6 .6  1];',
   ' >> H = [0  0  1  1  0  0];'};

  %========== Slide 4 ==========

  slide(4).code={
   ' plot(fhz,H), title(''Desired Frequency Response'')',
   '    xlabel(''Frequency (Hz)''), ylabel(''Magnitude'')' };
  slide(4).text={
   ' Next we plot the desired frequency response to make sure',
   ' it is what we want (we''ll unnormalize the frequency axis).',
   '',
   ' >> fs = 1000; % assumed sampling rate',
   ' >> fhz = f*fs/2;',
   ' >> plot(fhz,H)',
   ' >> title(''Desired Frequency Response'')',
   ' >> xlabel(''Frequency (Hz)'')',
   ' >> ylabel(''Magnitude'')'};

  %========== Slide 5 ==========

  slide(5).code={
   ' plot(fhz,H), title(''Desired Frequency Response'')',
   '    xlabel(''Frequency (Hz)''), ylabel(''Magnitude'')' };
  slide(5).text={
   ' Now we use YULEWALK to compute the coefficients of an 8th',
   ' order filter that will approximate our desired response.',
   '',
   ' >> N = 8;',
   ' >> [Bh,Ah] = yulewalk(N,f,H);'};

  %========== Slide 6 ==========

  slide(6).code={
   'N = 8;      % Order of the filter (number of poles and zeros).',
   '[Bh,Ah] = yulewalk(N,f,H);  % Working, please wait.....',
   'n = 256;',
   'hh = freqz(Bh,Ah,n);    % compute complex frequency response',
   'hy  = abs(hh);      % compute magnitude',
   'ff  = fs/(2*n) * (0:n-1);',
   'plot(fhz,H,ff,hy), title(''Actual vs. Desired Frequency Response'')',
   'xlabel(''Frequency (Hz)''), ylabel(''Magnitude'')' };
  slide(6).text={
   'Now we can plot the frequency response magnitude and',
   ' compare it to the desired response.',
   '',
   ' >> n = 256;',
   ' >> hh = freqz(Bh,Ah,n);',
   ' >> hy  = abs(hh);',
   ' >> ff  = fs/(2*n) * (0:n-1);',
   ' >> plot(fhz,H,ff,hy)',
   ' >> title(''Actual vs. Desired Frequency Response'')',
   ' >> xlabel(''Frequency (Hz)''), ylabel(''Magnitude'')'};

  %========== Slide 7 ==========

  slide(7).code={
   'N = 4; passband = [.4 .6]; ripple = .1;',
   '[Bb,Ab] = butter(N, passband);',
   '[Bc,Ac] = cheby1(N, ripple, passband);',
   'h = [abs(hh) abs(freqz(Bb,Ab,n)) abs(freqz(Bc,Ac,n))];',
   'plot(ff,h)',
   'title(''YuleWalk, Butterworth and Chebyshev filters'')',
   'xlabel(''Frequency (Hz)''), ylabel(''Magnitude''),' };
  slide(7).text={
   ' Now let''s design Butterworth and Chebyshev bandpass filters',
   ' with the same passband (defined between 0.0 and 1.0).',
   ' Here we compare all three frequency responses.',
   '',
   ' >> N = 4; passband = [.4 .6]; ripple = .1;',
   ' >> [Bb,Ab] = butter(N, passband);',
   ' >> [Bc,Ac] = cheby1(N, ripple, passband);',
   ' >> h = [abs(hh) abs(freqz(Bb,Ab,n)) abs(freqz(Bc,Ac,n))];',
   ' >> plot(ff,h)',
   ' >> title(''YuleWalk, Butterworth and Chebyshev filters'')'};

  %========== Slide 8 ==========

  slide(8).code={
   'plot(ff(2:n),20*log10(h(2:n,:)))',
   'title(''YuleWalk, Butterworth and Chebyshev filters'')',
   'xlabel(''Frequency (Hz)'')',
   'ylabel(''Magnitude in dB'')' };
  slide(8).text={
   ' Finally, we look at the frequency response on a logarithmic',
   ' decibel (dB) scale.',
   '',
   ' >> plot(ff(2:n),20*log10(h(2:n,:)))',
   ' >> title(''YuleWalk, Butterworth and Chebyshev filters'')',
   ' >> xlabel(''Frequency (Hz)'')',
   ' >> ylabel(''Magnitude in dB'')'};
end
