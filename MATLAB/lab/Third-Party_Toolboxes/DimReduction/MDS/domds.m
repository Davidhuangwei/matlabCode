function domds
% ----------------------------------------------------------------------------------
%    MULTIDIMENSIONAL SCALING in matlab by Mark Steyvers 1999 
%      needs optimization toolbox      
% 
%
% ----------------------------------------------------------------------------------

no 			= 10;						% size of input matrix
A  			= rand( no , no );	% dissimilarities

plotdim1 	= 1;		% which dimension on x-axis
plotdim2 	= 2;		% which dimension on y-axis
ndims    	= 2;		% number of dimension in MDS solution
R				= 2.0;	% R values in minkowski metric
maxiter		= 50;		% maximum number of iterations
conv     	= 0.001;	% convergence criterion
R1       	= 1;     % 1=Torgeson Young scaling for initial configuration 0 = intial random configuration
seed     	= 1;		% seed for random number generator
minoption 	= 1;  	% 1 = minimize stress1    2 = minimize stress2

% provide some text labels for the stimulus points here
for i=1:no
   labels{ i } = sprintf( '%d' , i );
end

userinput{2} = R;
userinput{3} = ndims;
userinput{4} = maxiter;
userinput{5} = conv;
userinput{6} = 1;         % 0=no 1=yes, printed comments
userinput{7} = 0;
userinput{8} = 0;
userinput{9} = R1;
userinput{10}= 0;
userinput{11}= seed;
userinput{13}= 1;         % 0=do not symmetrize input matrix % 1=do symmetrize
userinput{14}= 0;
userinput{15}= minoption;

% ---------------------------------------------------------------------------------
%    CALL THE MDS ROUTINE
[ Config,DHS,DS,DeltaS,Stress1,StressT1,Stress2,StressT2,Rs,RsT] = ...
              mds( userinput,A );
% ---------------------------------------------------------------------------------

% ---------------------------------------------------------------------------------
%                            Create the Shepard Plot
% ---------------------------------------------------------------------------------
figure( 1 );
plot( DS , DeltaS , 'r*' , DHS , DeltaS , '-gs' );
grid on;
axis square;
axis tight;
ylabel( 'dissimilarities' );
xlabel( 'distances' );
title( sprintf( 'stress1=%1.4f stress2=%1.4f Rs=%1.4f (N=%d)' , Stress1 , Stress2 , Rs , no ) , 'FontSize' , 8 );

% ---------------------------------------------------------------------------------
%                            Create the plot with stimulus coordinates
% ---------------------------------------------------------------------------------
figure( 2 );
if (ndims==1)
   plot( Config(:,1) , Config(:,1) , 'r*' );
   grid on;
   axis square;
   xlabel( 'dimension 1' );
   ylabel( 'dimension 1' );
   
   for i=1:no
      text( Config(i,1)+0.1 , Config(i,1) , labels{i}  );
   end;   
elseif (ndims>=2)
   plot( Config(:,plotdim1) , Config(:,plotdim2) , 'r*' );
   grid on;
   axis square;
   xlabel( sprintf( 'dimension %d' , plotdim1 ));
   ylabel( sprintf( 'dimension %d' , plotdim2 ));
   
   for i=1:no
      text( Config(i,plotdim1)+0.1 , Config(i,plotdim2) , labels{i} );
   end;   
end

     


