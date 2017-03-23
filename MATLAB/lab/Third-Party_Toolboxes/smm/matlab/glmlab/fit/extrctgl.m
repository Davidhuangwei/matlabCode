%EXTRCTGL  Extracts the User data info from glmlab

%Copyright 1997 Peter Dunn
%01 August 1997

GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'UserData');

errdis=GLMLAB_INFO_{1};
link=GLMLAB_INFO_{2};
scalepar=GLMLAB_INFO_{3};
restype=GLMLAB_INFO_{4};
recycle=GLMLAB_INFO_{5};
inc_const=GLMLAB_INFO_{6};
nameyv=GLMLAB_INFO_{9};
namexv=GLMLAB_INFO_{10};
namepw=GLMLAB_INFO_{11};
nameos=GLMLAB_INFO_{12};
rownamexv=GLMLAB_INFO_{13};
yvar=GLMLAB_INFO_{14};
xvar=GLMLAB_INFO_{15};
pwvar=GLMLAB_INFO_{16};
osvar=GLMLAB_INFO_{17};
