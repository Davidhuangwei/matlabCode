function MakeAnatCurvature(animal)

i = input('\nLoad existing file?y\[n]')
if i == 'y';
    ERROR_CANT_DO_THAT
else
    notDone = 1;
    while notDone
        
        i = 0;
        while i~=1 & i~=2 & i~=3 & i~=4 & i~=5 & i~=6
        i = input('What curve would you like to work on?\n' ...
            '1) CA1-top\n 2) CA1-bottom\n 3) LM border\n 4) fissure\n 5) DGG\n 6) CA3\n');
        switch i
            case 1
                currentCurve = CA1top;
                break;
            case 2
                currentCurve = CA1bottom;
                break;
            case 3
                currentCurve = CA1top;
                break;
            case 4
                currentCurve = CA1top;
                break;
            case 5
                currentCurve = CA1top;
                break;
             case 6
                currentCurve = CA1top;
                break;   
        end
        
        i = 0;
        while i~=1 & i~=2
            i = input('What would you like to do?\n' ...
                '1) draw\n 2) edit\n');
            if i=1
                
                j = 0;
                while j
                    
                    fprintf('Draw a point'
                    [x,y] = ginput(1);
                    
                    hold on
                    
            
    

[x,y] = ginput(1);
xIndex = find((currentCurveX-x).^2+(currentCurveY-y).^2 == min((currentCurveX-x).^2+(currentCurveY-y).^2));
yIndex = find((currentCurveX-x).^2+(currentCurveY-y).^2 == min((currentCurveX-x).^2+(currentCurveY-y).^2));
plot(currentCurveX(xIndex),currentCurveY(yIndex),'o')
[x,y] = ginput(1);
currentCurveX(xIndex) = x;
currentCurveY(yIndex) = y;


clf
chanMat = zeros(16,6);
for i=1:96
    chanMat(i) = mod(i,14);
end
imagesc(chanMat)
set(gca,'xtick',[0.5:0.25:6.5],'ytick',[1:16]);
grid on
hold on
fprintf('\nMark the Points for the Top of the CA1 Pyramidal Layer (Start on the Left Side):\n')
%[currentCurveX,currentCurveY] = ginput;
hold on;
plot(currentCurveX,currentCurveY,'color',[0.75 0.75 0.75],'linewidth', 3)
plot(CA1bottomX,CA1bottomY,'color',[0.75 0.75 0.75],'linewidth', 3)

plot(CA1topX,CA1topY,'color',[0.75 0.75 0.75],'linewidth', 3)


i = input('Is this good? [y]/n:')
if ~isempty(i) & i == 'n'
    i = input('Do you want to start over with this curve? y/[n]:')
  ,,
,,,,
junk3 = [-72,114;-142,171;-213,172;-171,172;-171,221;-224,211;-177,384;-404,567;-610,113;-160,231;-327,298;-512,10;-12,41;-80,103;-189,31;-47,62;-93,94;-140,88;-120,171;-223,290;-314,90;-53,223;-136,337;-136,4;-4,35;-8,39;-12,66;0,134;-23,202;-23,12;-12,324;-7,336;4,80;9,191;13,264;54,8;0,28;12,35;12,48;23,107;45,160;54,61;31,134;49,199;70,24;25,85;20,109;44,19;3,23;7,31;7,193;98,387;201,586;288,74;44,74;44,127];
,,,,
,,,,
,,,,
