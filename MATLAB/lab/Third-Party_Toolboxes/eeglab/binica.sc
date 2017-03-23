# ica - Perform Independent Component Analysis, standalone-version
#       Master .sc file for binica - do not alter.
#
#   Run the ICA algorithm of Bell & Sejnowski (1996) or the extended-ICA 
#   of Lee, Girolami & Sejnowski (1998). Original Matlab code: Scott Makeig,
#   Tony Bell, et al.; C++ code: Sigurd Enghoff, CNL / Salk Institute 7/98
#   Use the MATLAB binica() routine
#
#   Usage:   >> [wts,sph] = binica(data,[runica() args]);
#
#   Contacts: {scott,terry,tony,tewon,jung}@salk.edu
#
# Required variables:
# 
    DataFile     XXX       # Input data to decompose (floats multiplexed
                           #   by channel (i.e., chan1, chan2, ...))
    chans        31        # Number of data channels (= data columns) 
    frames       768       # Number of data points per epoch (= data rows)
#
#   epochs       436       # Number of epochs
# 	FrameWindow  20        # Number of frames per window
# 	FrameStep    4         # Number of frames to step per window
# 	EpochWindow  100       # Number of epochs per window
# 	EpochStep    25        # Number of epochs to step per window
# 	Baseline     25        # Number of data points contained in baseline
#
    WeightsOutFile binica.wts  # Output ICA weight matrix (floats)
    SphereFile     binica.sph  # Output sphering matrix (floats)
# 
# Processing options:
# 
    sphering     on        # Flag sphering of data (on/off)   {default: on}
    bias         on        # Perform bias adjustment (on/off) {default: on}
    extended     0         # Perform "extended-ICA" using tnah() with kurtosis
                           #  estimation every N training blocks. If N < 0,
                           #  fix number of sub-Gaussian components to -N 
                           #  {default|0: off}
    pca          0         # Decompose a principal component subspace of
                           #  the data. Retain this many PCs. {default|0: all}
# Optional input variables:
# 
#  WeightsInFile [] # Starting ICA weight matrix (nchans,ncomps)
                           #  {default: identity or sphering matrix}
    lrate        1.0e-4    # Initial ICA learning rate (float << 1)
                           #  {default: heuristic ~5e-4}
    blocksize    0         # ICA block size (integer << datalength) 
                           #  {default: heuristic fraction of log data length}
    stop         1.0e-6    # Stop training when weight-change < this value
                           #  {default: heuristic ~0.000001}
    maxsteps     512       # Max. number of ICA training steps {default: 128}
    posact       on        # Make each component activation net-positive
                           # (on/off) {default: on}
    annealstep   0.98      # Annealing factor (range (0,1]) - controls 
                           #  the speed of convergence.
    annealdeg    60        # Angledelta threshold for annealing {default: 60}
    momentum     0       # Momentum gain (range [0,1])      {default: 0}
    verbose      on        # Give ascii messages (on/off) {default: on}
# 
# Optional outputs:
# 
#  ActivationsFile data.act # Activations of each component (ncomps,points)
#  BiasFile      data.bs   # Bias weights (ncomps,1)
#  SignFile      data.sgn  # Signs designating (-1) sub- and (1) super-Gaussian 
                           #  components (ncomps,1)
#
# Note that the input data file(s) must be native floats.
