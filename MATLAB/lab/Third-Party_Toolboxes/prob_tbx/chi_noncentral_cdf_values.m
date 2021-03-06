function [ n_data_new, x, lambda, df, cdf ] ...
  = chi_noncentral_cdf_values ( n_data )

%% CHI_NONCENTRAL_CDF_VALUES returns values of the noncentral chi CDF.
%
%  Discussion:
%
%    The CDF of the noncentral chi square distribution can be evaluated
%    within Mathematica by commands such as:
%
%      Needs["Statistics`ContinuousDistributions`"]
%      CDF [ NoncentralChiSquareDistribution [ DF, LAMBDA ], X ]
%
%  Modified:
%
%    12 June 2004
%
%  Author:
%
%    John Burkardt
%
%  Reference:
%
%    Stephen Wolfram,
%    The Mathematica Book,
%    Fourth Edition,
%    Wolfram Media / Cambridge University Press, 1999.
%
%  Parameters:
%
%    Input, integer N_DATA, indicates the index of the previous test data
%    returned, or is 0 if this is the first call.  For repeated calls,
%    set the input value of N_DATA to the output value of N_DATA_NEW
%    from the previous call.
%
%    Output, integer N_DATA_NEW, the index of the test data.
%
%    Output, real X, the argument of the function.
%
%    Output, real LAMBDA, the noncentrality parameter.
%
%    Output, integer DF, the number of degrees of freedom.
%
%    Output, real CDF, the noncentral chi CDF.
%
  n_max = 27;
  cdf_vec = [ ...
    0.839944E+00, 0.695906E+00, 0.535088E+00, ...
    0.764784E+00, 0.620644E+00, 0.469167E+00, ...
    0.307088E+00, 0.220382E+00, 0.150025E+00, ...
    0.307116E-02, 0.176398E-02, 0.981679E-03, ...
    0.165175E-01, 0.202342E-03, 0.498448E-06, ...
    0.151325E-01, 0.209041E-02, 0.246502E-03, ...
    0.263684E-01, 0.185798E-01, 0.130574E-01, ...
    0.583804E-01, 0.424978E-01, 0.308214E-01, ...
    0.105788E+00, 0.794084E-01, 0.593201E-01 ];
  df_vec = [ ...
      1,   2,   3, ...
      1,   2,   3, ...
      1,   2,   3, ...
      1,   2,   3, ...
     60,  80, 100, ...
      1,   2,   3, ...
     10,  10,  10, ...
     10,  10,  10, ...
     10,  10,  10 ];
  lambda_vec = [ ...
     0.5E+00,  0.5E+00,  0.5E+00, ...
     1.0E+00,  1.0E+00,  1.0E+00, ...
     5.0E+00,  5.0E+00,  5.0E+00, ...
    20.0E+00, 20.0E+00, 20.0E+00, ...
    30.0E+00, 30.0E+00, 30.0E+00, ...
     5.0E+00,  5.0E+00,  5.0E+00, ...
     2.0E+00,  3.0E+00,  4.0E+00, ...
     2.0E+00,  3.0E+00,  4.0E+00, ...
     2.0E+00,  3.0E+00,  4.0E+00 ];
  x_vec = [ ...
     3.000E+00,  3.000E+00,  3.000E+00, ...
     3.000E+00,  3.000E+00,  3.000E+00, ...
     3.000E+00,  3.000E+00,  3.000E+00, ...
     3.000E+00,  3.000E+00,  3.000E+00, ...
    60.000E+00, 60.000E+00, 60.000E+00, ...
     0.050E+00,  0.050E+00,  0.050E+00, ...
     4.000E+00,  4.000E+00,  4.000E+00, ...
     5.000E+00,  5.000E+00,  5.000E+00, ...
     6.000E+00,  6.000E+00,  6.000E+00 ];

  n_data_new = n_data;

  if ( n_data_new < 0 )
    n_data_new = 0;
  end

  n_data_new = n_data_new + 1;

  if ( n_max < n_data_new )
    n_data_new = 0;
    x = 0.0E+00;
    lambda = 0.0E+00;
    df = 0;
    cdf = 0.0E+00;
  else
    x = x_vec(n_data_new);
    lambda = lambda_vec(n_data_new);
    df = df_vec(n_data_new);
    cdf = cdf_vec(n_data_new);
  end
