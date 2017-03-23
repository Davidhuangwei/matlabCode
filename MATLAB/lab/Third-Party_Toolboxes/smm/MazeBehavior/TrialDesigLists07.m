function TrialDesigLists07(trialDesigNameCell,varargin)
analDir = 'GlmWholeModel07/';
model = 'whole';
cwd = pwd;

analDirs = {...
    '/BEEF01/smm/sm9601_Analysis/2-13-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-14-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-15-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-16-04/analysis/',...
    '/BEEF01/smm/sm9603_Analysis/3-20-04/analysis/',...
    '/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-15-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-16-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-17-04/analysis/',...
    '/BEEF02/smm/sm9614_Analysis/4-16-05/analysis/',...
    '/BEEF02/smm/sm9614_Analysis/4-17-05/analysis/',...
    '/BEEF03/smm/drugs/DrugsAnal/sm9608_448-455/analysis/',...
    '/BEEF03/smm/drugs/DrugsAnal/sm9614_564-575/analysis/',...
    '/BEEF03/smm/drugs/DrugsAnal/sm9614_544-557/analysis/',...
};
analDirs = DefaultArgs(varargin,{analDirs});

for j=1:length(analDirs)
    cd(analDirs{j})
    for k=1:length(trialDesigNameCell)
        %eval(['!mv TrialDesig/' analDir ' TrialDesig/' analDir(1:end-1) '_old'])
        SelectTrialDesig(trialDesigNameCell{k},analDir,model);
    end
end
cd(cwd)
return

function SelectTrialDesig(trialDesigName,analDir,model)
fileInfoDir = 'FileInfo/';
chanInfoDir = 'ChanInfo';
contIndepCell = [];
contVarSub = [];
fileBaseCell = [];
trialDesig = [];
trialMeanBool = [];
outlierDepth = [];
modelSpec = [];
ssType = [];
equalNbool = [];
switch trialDesigName
     case 'Maze_Scopolamine'
        categIndepNames = {'Scopolamine'};
        contIndepNames = {};
        contVarSub = {};
        fileBaseCell = LoadVar([fileInfoDir 'MazeFiles']);
        trialDesig.sober = {...
            {{'taskType','alter'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10},...
            {'drug','none'}},...
            {{'taskType','circle'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 0 0 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}...
            {'drug','none'}},...
            {{'taskType','Z'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10},...
            {'drug','none'}},...
            {{'taskType','force'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10},...
            {'drug','none'}},...
            };
        trialDesig.Scopolamine = {...
            {{'taskType','alter'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10},...
            {'drug','Scopolamine'}},...
            {{'taskType','circle'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 0 0 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}...
            {'drug','Scopolamine'}},...
            {{'taskType','Z'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10},...
            {'drug','Scopolamine'}},...
            {{'taskType','force'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10},...
            {'drug','Scopolamine'}},...
            };
        trialMeanBool = 0;
        outlierDepth = 0;
        if strcmp(model,'whole');
            modelSpec = 1;
        else
            modelSpec = 1;
        end
        ssType = 3;
        equalNbool = 1;

    
 case 'Maze_PCP'
        categIndepNames = {'PCP'};
        contIndepNames = {};
        contVarSub = {};
        fileBaseCell = LoadVar([fileInfoDir 'MazeFiles']);
        trialDesig.sober = {...
            {{'taskType','alter'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10},...
            {'drug','none'}},...
            {{'taskType','circle'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 0 0 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}...
            {'drug','none'}},...
            {{'taskType','Z'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10},...
            {'drug','none'}},...
            {{'taskType','force'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10},...
            {'drug','none'}},...
            };
        trialDesig.PCP = {...
            {{'taskType','alter'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10},...
            {'drug','PCP'}},...
            {{'taskType','circle'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 0 0 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}...
            {'drug','PCP'}},...
            {{'taskType','Z'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10},...
            {'drug','PCP'}},...
            {{'taskType','force'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10},...
            {'drug','PCP'}},...
            };
        trialMeanBool = 0;
        outlierDepth = 0;
        if strcmp(model,'whole');
            modelSpec = 1;
        else
            modelSpec = 1;
        end
        ssType = 3;
        equalNbool = 1;

    
     case 'RemVsDrugMaze_DrugBeh'
        categIndepNames = {'drugBeh'};
        contIndepNames = {};
        contVarSub = {};
        fileBaseCell = [setDiff(LoadVar([fileInfoDir 'RemFiles']),LoadVar([fileInfoDir 'DrugFiles']));...
            intersect(LoadVar([fileInfoDir 'MazeFiles']),LoadVar([fileInfoDir 'DrugFiles']))];
        trialDesig.pcpMaze = {...
            {{'taskType','alter'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}},...
            {{'taskType','circle'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 0 0 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}}...
            {{'taskType','Z'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}},...
            {{'taskType','force'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}},...
            };
       trialDesig.rem =  {...
            {{'taskType','REM'},...
            {'thetaFreqLM4-12Hz',1,'>',0}}...
            };
        trialMeanBool = 0;
        outlierDepth = 0;
        if strcmp(model,'whole');
            modelSpec = 1;
        else
            modelSpec = 1;
        end
        ssType = 3;
        equalNbool = 1;

    
     case 'RemVsMaze_Beh'
        categIndepNames = {'behavior'};
        contIndepNames = {};
        contVarSub = {};
        fileBaseCell = [LoadVar([fileInfoDir 'RemFiles']);LoadVar([fileInfoDir 'MazeFiles'])];
        trialDesig.maze = {...
            {{'taskType','alter'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}},...
            {{'taskType','circle'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 0 0 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}}...
            {{'taskType','Z'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}},...
            {{'taskType','force'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}},...
            };
       trialDesig.rem =  {...
            {{'taskType','REM'},...
            {'thetaFreqLM4-12Hz',1,'>',0}}...
            };
        trialMeanBool = 0;
        outlierDepth = 0;
        if strcmp(model,'whole');
            modelSpec = 1;
        else
            modelSpec = 1;
        end
        ssType = 3;
        equalNbool = 1;

     case 'RemVsMazeGood_Beh'
        categIndepNames = {'behavior'};
        contIndepNames = {};
        contVarSub = {};
        fileBaseCell = [LoadVar([fileInfoDir 'RemFiles']);LoadVar([fileInfoDir 'MazeFiles'])];
        trialDesig.maze = {...
            {{'taskType','alter'},...
            {'trialType',[1 0 1 0 0 0 0 0 0 0 0 0 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}},...
            {{'taskType','circle'},...
            {'trialType',[1 0 1 0 0 0 0 0 0 0 0 0 0],'>',0.6},...
            {'mazeLocation',[0 0 0 0 0 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}}...
            {{'taskType','Z'},...
            {'trialType',[1 0 1 0 0 0 0 0 0 0 0 0 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}},...
            {{'taskType','force'},...
            {'trialType',[1 0 1 0 0 0 0 0 0 0 0 0 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}},...
            };
       trialDesig.rem =  {...
            {{'taskType','REM'}...
            {'thetaFreqLM4-12Hz',1,'>',0}}...
            };
        trialMeanBool = 0;
        outlierDepth = 0;
        if strcmp(model,'whole');
            modelSpec = 1;
        else
            modelSpec = 1;
        end
        ssType = 3;
        equalNbool = 1;

     case 'Rem_ThetaFreqLM'
        categIndepNames = {};
        contIndepNames = {'thetaFreqLM4-12Hz'};
        contVarSub = {};
        fileBaseCell = [LoadVar([fileInfoDir 'RemFiles'])];
        trialDesig.rem =  {...
            {{'taskType','REM'},...
            {'thetaFreqLM4-12Hz',1,'>',0}}...
            };
        trialMeanBool = 0;
        outlierDepth = 0;
        if strcmp(model,'whole');
            modelSpec = 1;
        else
            modelSpec = 1;
        end
        ssType = 3;
        equalNbool = 1;

     case 'Maze_ThetaFreqLM'
        categIndepNames = {};
        contIndepNames = {'thetaFreqLM4-12Hz'};
        contVarSub = {};
        fileBaseCell = [LoadVar([fileInfoDir 'MazeFiles'])];
        trialDesig.maze = {...
            {{'taskType','alter'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}},...
            {{'taskType','circle'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 0 0 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}}...
            {{'taskType','Z'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}},...
            {{'taskType','force'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}},...
            };
        trialMeanBool = 0;
        outlierDepth = 0;
        if strcmp(model,'whole');
            modelSpec = 1;
        else
            modelSpec = 1;
        end
        ssType = 3;
        equalNbool = 1;

     case 'RemVsMaze_Beh_ThetaFreqLM'
        categIndepNames = {'behavior'};
        contIndepNames = {'thetaFreqLM4-12Hz'};
        contVarSub = {};
        fileBaseCell = [LoadVar([fileInfoDir 'RemFiles']);LoadVar([fileInfoDir 'MazeFiles'])];
        trialDesig.maze = {...
            {{'taskType','alter'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}},...
            {{'taskType','circle'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 0 0 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}}...
            {{'taskType','Z'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}},...
            {{'taskType','force'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}},...
            };
       trialDesig.rem =  {...
            {{'taskType','REM'},...
            {'thetaFreqLM4-12Hz',1,'>',0}}...
            };
        trialMeanBool = 0;
        outlierDepth = 0;
        if strcmp(model,'whole');
            modelSpec = 1;
        else
            modelSpec = 1;
        end
        ssType = 3;
        equalNbool = 1;

     case 'RemVsMaze_Beh_ThetaFreqLM_X'
        categIndepNames = {'behavior'};
        contIndepNames = {'thetaFreqLM4-12Hz'};
        contVarSub = {};
        fileBaseCell = [LoadVar([fileInfoDir 'RemFiles']);LoadVar([fileInfoDir 'MazeFiles'])];
        trialDesig.maze = {...
            {{'taskType','alter'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}},...
            {{'taskType','circle'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 0 0 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}}...
            {{'taskType','Z'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}},...
            {{'taskType','force'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}},...
            };
       trialDesig.rem =  {...
            {{'taskType','REM'},...
            {'thetaFreqLM4-12Hz',1,'>',0}}...
            };
        trialMeanBool = 0;
        outlierDepth = 0;
        if strcmp(model,'whole');
            modelSpec = 2;
        else
            modelSpec = 1;
        end
        ssType = 3;
        equalNbool = 1;

     case 'RemVsMaze_BehXThetaFreqLM'
        categIndepNames = {'behavior'};
        contIndepNames = {'thetaFreqLM4-12Hz'};
        contVarSub = {};
        fileBaseCell = [LoadVar([fileInfoDir 'RemFiles']);LoadVar([fileInfoDir 'MazeFiles'])];
        trialDesig.maze = {...
            {{'taskType','alter'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}},...
            {{'taskType','circle'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 0 0 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}}...
            {{'taskType','Z'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}},...
            {{'taskType','force'},...
            {'trialType',[1 1 1 1 1 1 1 1 1 1 1 1 0],'>',0.6},...
            {'mazeLocation',[0 0 0 1 1 1 1 1 1],'>',0.5},...
            {'thetaFreqLM4-12Hz',1,'>',0},...
            {'speed.p0',1,'>=',10}},...
            };
       trialDesig.rem =  {...
            {{'taskType','REM'},...
            {'thetaFreqLM4-12Hz',1,'>',0}}...
            };
        trialMeanBool = 0;
        outlierDepth = 0;
        if strcmp(model,'whole');
            modelSpec = [...
                0 0 1;...
                ];
        else
            modelSpec = 1;
        end
        ssType = 3;
        equalNbool = 1;
    case 'AlterGood_S0_A0_MRall'
        categIndepNames = {'mazeRegion'};
        contIndepNames = {'speed.p0','accel.p0'};
        contVarSub = {};
        fileBaseCell = [LoadVar([fileInfoDir 'AlterFiles'])];
        trialDesig.returnArm = {...
            {{'taskType','alter'},...
            {'trialType',[1 0 1 0 0 0 0 0 0 0 0 0 0],'>',0.6},...
            {'mazeLocName','returnArm'}}...
            };
        trialDesig.delayArea = {...
            {{'taskType','alter'},...
            {'trialType',[1 0 1 0 0 0 0 0 0 0 0 0 0],'>',0.6},...
            {'mazeLocName','delayArea'}}...
            };
        trialDesig.centerArm = {...
            {{'taskType','alter'},...
            {'trialType',[1 0 1 0 0 0 0 0 0 0 0 0 0],'>',0.6},...
            {'mazeLocName','centerArm'}}...
            };
        trialDesig.Tjunction = {...
            {{'taskType','alter'},...
            {'trialType',[1 0 1 0 0 0 0 0 0 0 0 0 0],'>',0.6},...
            {'mazeLocName','Tjunction'}}...
            };
        trialDesig.goalArm = {...
            {{'taskType','alter'},...
            {'trialType',[1 0 1 0 0 0 0 0 0 0 0 0 0],'>',0.6},...
            {'mazeLocName','goalArm'}}...
            };
        trialDesig.waterPort = {...
            {{'taskType','alter'},...
            {'trialType',[1 0 1 0 0 0 0 0 0 0 0 0 0],'>',0.6},...
            {'mazeLocName','waterPort'}}...
            };
        trialMeanBool = 0;
        outlierDepth = 1;
        if strcmp(model,'whole');
            modelSpec = 1;
        else
            modelSpec = 1;
        end
        ssType = 3;
        equalNbool = 0;


    otherwise
        fprintf('\n %s Not Found\n',trialDesigName);
        return
end


if ~exist('TrialDesig','dir')
    mkdir('TrialDesig')
end
if ~exist(['TrialDesig/' analDir],'dir')
    mkdir(['TrialDesig/' analDir])
end
outName = ['TrialDesig/' analDir trialDesigName '.mat'];
fprintf('Saving: %s\n',[pwd '/' outName])

save(outName,SaveAsV6,'trialDesig','categIndepNames','contIndepNames',...
    'contVarSub','fileBaseCell','trialMeanBool','outlierDepth',...
    'modelSpec','ssType','equalNbool');
return
