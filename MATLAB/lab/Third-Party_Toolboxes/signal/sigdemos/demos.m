function tbxStruct=Demos
% DEMOS   Demo list for the Signal Processing Toolbox

% Kelly Liu, 8-6-96
%   Copyright (c) 1988-98 by The MathWorks, Inc.
% $Revision: 1.1 $  $Date: 1998/05/20 14:10:50 $

if nargout==0, demo toolbox; return; end

tbxStruct.Name='Signal Processing';
tbxStruct.Type='toolbox';

tbxStruct.Help= {
    ' The Signal Processing Toolbox includes many    '
    ' powerful, classical algorithms for processing  '
    ' digital signals, including: '
    '    - altering frequency content (filter design),'
    '    - analyzing frequency content (spectral '
    '      analysis), and '
    '    - extracting features (parametric modeling).'
    ' '
    ' These tools are an essential part of many'
    ' applications, including audio, video, '
    ' telecommunications, medicine, geophysics,'
    ' RADAR, SONAR, and econometrics.'
    ' '
     };

tbxStruct.DemoList={
                'Filtering a Signal', 'filtdem',
                'Bandpass Filter Design', 'filtdem2',
                'Spectral Analysis of DTMF', 'phone',
                'Discrete Fourier Transform', 'sigdemo1',
                'Continuous Fourier Transform', 'sigdemo2',
                'Chirp-z Transform', 'cztdemo',
                'Interactive Lowpass Filter Design', 'filtdemo',
                'Modulation', 'moddemo',
                '2nd-Order Sections', 'sosdemo',
             'Savitzky-Golay Filtering', 'sgolaydemo'};

