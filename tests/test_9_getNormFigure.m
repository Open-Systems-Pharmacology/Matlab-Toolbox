function [ErrorFlag, ErrorMessage,TestDescription] = test_9_getNormFigure
%TEST_9_GETNORMFIGURE Test of Function getNormFigure
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_9_GETNORMFIGURE
%       ErrorFlag (boolean):
%               0 = 'Ok'
%               1 = 'User has to check something by hand or a warning exists
%               2 = 'Serious Error'
%       ErrorMessage (string): Description of the error
 
% Open Systems Pharmacology Suite;  http://open-systems-pharmacology.org


ErrorFlag_tmp=0;
ErrorMessage_tmp{1}='';
TestDescription={};

close all;
% 1 Check default options
TestDescription{end+1}='1) Base figure;';

[ax]=getNormFigure(1,1);
ax(1);
hist(rand(100,1))
xlabel('test xlabel bold fontsize 12')
ylabel('test ylabel bold fontsize 12')
title('test title bold fontsize 12')
legend('test legend bold fontsize 12')
shg;

% return

% Check more than one plot
TestDescription{end+1}='2) Multi figures;';

nRows=2;
nCols=4;
[ax]=getNormFigure(nRows,nCols);
for iAx=1:nRows*nCols
    set(gcf, 'CurrentAxes', ax(iAx));
    switch mod(iAx,3)
        case 0
            hist(rand(100,1));
        case 1
            plot(rand(10,1),rand(10,1),'x','linewidth',2)
        case 2
            plot([1:10],rand(10,1),'-','linewidth',2) 
    end
    xlabel('test xlabel')
    ylabel('test ylabel')
    title('test title')
    legend('test legend')
end
shg;

% Check more than one plot
TestDescription{end+1}='3) withoptions;';

[~,f]=getNormFigure(1,1,[],'paperposition',[0 0 30 30],...
    'paperOrientation','landscape','fontsize',5,'figureFormat','landscape');
hist(rand(100,1));
shg


% Check figure handle
TestDescription{end+1}='3) use gcf ;';
[~,f]=getNormFigure(1,1,f);
plot([1:10],rand(10,1),'-','linewidth',2); %#ok<*NBRAK>
shg


% Check axes handle
TestDescription{end+1}='4) use axes_position ;';
[ax]=getNormFigure(2,3,f,'axes_position',[0.6 0.1 0.3 0.8;0.1 0.1 0.3 0.8]);

set(gcf, 'CurrentAxes', ax(1));
plot([1:10],rand(10,1),'-','linewidth',2); %#ok<NBRAK>
xlabel('test xlabel')
ylabel('test ylabel')
title('test title')
legend('test legend')

set(gcf, 'CurrentAxes', ax(2));
hist(rand(100,1));
xlabel('test xlabel')
ylabel('test ylabel')
title('test title')
legend('test legend')

shg

[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);

close all;

return
