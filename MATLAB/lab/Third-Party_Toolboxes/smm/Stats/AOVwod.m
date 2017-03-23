function [AOVwod] = AOVwod(X,mt,alpha)
%AOVWOD  Single-Factor Analysis of Variances Test using only Means and Variances.
%(Without data)
%[Computes the Analysis of Variance Model I or Model II for equal or unequal sample sizes
%using only means and variances.]
%
%   Syntax: function [AOVwod] = AOVwod(X,mt,alpha) 
%      
%     Inputs:
%          X - data matrix (Size of matrix must be n-by-3; sample sizes=column 1, means=column 2,
%              variances=column3). 
%         mt - model type [Model I (fixed-effects) = 1; Model II (random-effects) = 2] 
%      alpha - significance level (default = 0.05).
%     Outputs:
%          - Complete Analysis of Variance table.
%                               |- homogeneity among sample means was met (for Model I).
%                               |
%          - Whether or not the |
%                               |
%                               |- homogeneity among variances was met (for Model II).
%
%    Example: From the example 10.2 of Zar (1999, p.184,186), to test the homogeneity among 
%             the means (Model II) of data with a significance level = 0.05.
%
%                            Statistics
%                   -----------------------------
%                       n       Mean      Var
%                   -----------------------------
%                       5       34.6      0.8
%                       5       36.4      0.8
%                       5       35.8      1.7
%                       5       35.2      1.7  
%                   -----------------------------
%                                       
%           Data matrix must be:
%            X=[5 34.6 0.8;5 36.4 0.8;5 35.8 1.7;5 35.2 1.7];
%
%     Calling on Matlab the function: 
%             AOVwod(X,2)
%
%       Answer is:
%
% The number of samples are: 4
%
% Analysis of Variance Model II Table.
% ----------------------------------------------------------------------------------------
% SOV             SS         df         MS         F        P       Var.comp.    % Contr.
% ----------------------------------------------------------------------------------------
% Sample        9.000         3       3.000      2.400   0.1059        0.350      21.87
% Error        20.000        16       1.250                            1.250      78.13
% Total        29.000        19
% ----------------------------------------------------------------------------------------
% The associated probability for the F test is equal or larger than 0.05
% So, the assumption that the added variance and the random variance component are equal was met.
%

%  Created by A. Trujillo-Ortiz and R. Hernandez-Walls
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.mx
%
%  June 09, 2003.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A. and R. Hernandez-Walls. (2003). AOVwod:  Single-factor analysis 
%    of variance test using only means and variances (without data). A MATLAB file.
%    [WWW document]. URL http://www.mathworks.com/matlabcentral/fileexchange/
%    loadFile.do?objectId=3601&objectType=FILE
%
%  References:
% 
%  Zar, J. H. (1999), Biostatistical Analysis (2nd ed.).
%           NJ: Prentice-Hall, Englewood Cliffs. p. 184,186. 
%

if nargin < 3,
   alpha = 0.05;  %(default)
end 

k = length(X);
fprintf('The number of samples are:%2i\n\n', k);

%Analysis of Variance Procedure.
SSA = (X(:,1)'*(X(:,2).^2))-(((X(:,1)'*(X(:,2)))^2)/sum(X(:,1))); %sample sum of squares
v1 = k-1; %sample degrees of freedom.
SSE = (X(:,1)-1)'*X(:,3); %error sum of squares
v2 = sum(X(:,1)) - k; %error degrees of freedom
SST = SSA + SSE; %total sum of squares
dfT = v1 + v2; %total degrees of freedom
MSA = SSA/v1; %sample mean squares
MSE = SSE/v2; %error mean squares
F = MSA/MSE; %F-statistic.

P = 1 - fcdf(F,v1,v2);  %probability associated to the F-statistic   

if mt == 1;
   disp('Analysis of Variance Model I Table.')
   fprintf('--------------------------------------------------------------\n');
   disp('SOV             SS         df         MS         F        P')
   fprintf('--------------------------------------------------------------\n');
   fprintf('Treat.  %11.3f%10i%12.3f%11.3f%9.4f\n',SSA,v1,MSA,F,P);
   fprintf('Error%14.3f%10i%12.3f\n',SSE,v2,MSE);
   fprintf('Total%14.3f%10i\n',SST,dfT);
   fprintf('--------------------------------------------------------------\n');
   
   if P >= alpha;
      fprintf('The associated probability for the F test is equal or larger than% 3.2f\n', alpha);
      fprintf('So, the assumption of sample means are equal was met.\n');
   else
      fprintf('The associated probability for the F test is smaller than% 3.2f\n', alpha);
      fprintf('So, the assumption of sample means are equal was not met.\n');
   end
else mt==2;
   no=(1/v1)*(sum(X(:,1))-(X(:,1)'*X(:,1)/sum(X(:,1))));  %procedure for equal or unequal sample sizes
   s2A=(MSA-MSE)/no;
   pcs2A=(s2A/(MSE+s2A))*100;
   pcs2=100-pcs2A;
   if (MSA-MSE)> 0;
      s2A = s2A;
   else
      s2A = 0;
   end
   disp('Analysis of Variance Model II Table.')
   fprintf('----------------------------------------------------------------------------------------\n');
   disp('SOV             SS         df         MS         F        P       Var.comp.    % Contr.')
   fprintf('----------------------------------------------------------------------------------------\n');
   fprintf('Sample  %11.3f%10i%12.3f%11.3f%9.4f%13.3f%11.2f\n',SSA,v1,MSA,F,P,s2A,pcs2A);
   fprintf('Error%14.3f%10i%12.3f%33.3f%11.2f\n',SSE,v2,MSE,MSE,pcs2);
   fprintf('Total%14.3f%10i\n',SST,dfT);
   fprintf('----------------------------------------------------------------------------------------\n');
   
   if P >= alpha;
      fprintf('The associated probability for the F test is equal or larger than% 3.2f\n', alpha);
      fprintf('So, the assumption that the added variance and the random variance component are equal was met.\n');
   else
      fprintf('The associated probability for the F test is smaller than% 3.2f\n', alpha);
      fprintf('So, the assumption that the added variance and the random variance component are equal was not met.\n');
   end
end


   
   