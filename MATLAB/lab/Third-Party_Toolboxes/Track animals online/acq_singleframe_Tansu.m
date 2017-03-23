function acq_singleframe(finalfile)

close all; pack
vid=videoinput('dt',1);
vid.FrameGrabInterval = 1; 

start(vid)
data=getdata(vid,1);
stop(vid)

imwrite(data,[finalfile '.jpeg'],'jpeg')