function [ErrorFlag, ErrorMessage,TestDescription] = test_9_setAxesScaling
%TEST_9_SETAXESSCALING Test of Function setAxesScaling
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_9_SETAXESSCALING
%       ErrorFlag (boolean):
%               0 = 'Ok'
%               1 = 'User has to check something by hand or a warning exists
%               2 = 'Serious Error'
%       ErrorMessage (string): Description of the error
 
% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 23-Dez-2010

ErrorFlag_tmp=0;
ErrorMessage_tmp{1}='';
TestDescription={};

close all;
% 1 Check  options
TestDescription{end+1}='1) check options;';

ax=getNormFigure;
plot(ax,[1:10],rand(1,10),'-','linewidth',2);
setAxesScaling(ax,'xlim',[0 9],'yscale','log')
shg;

% 2 Xticks
TestDescription{end+1}='1) check options;';

ax=getNormFigure(3,3);

for iAx=1:9
    set(gcf, 'CurrentAxes', ax(iAx));
    xlim=sort(rand(1,2))*1e-6;
    ylim=sort(10.^(-2+4*rand(1,2)));
    plot(mean(xlim),ylim,'*','markersize',12);
    set(ax(iAx),'xtick',[])
    set(ax(iAx),'ytick',[])
    setAxesScaling(ax(iAx),'xlim',xlim,'ylim',ylim,'yscale','log');
end
shg;

% 3 check warning
TestDescription{end+1}='1) throw arning logarithmic time scale;';

ax=getNormFigure;
plot(ax,[1:10],rand(1,10),'-','linewidth',2); %#ok<*NBRAK>
disp('Warning expected')
setAxesScaling(ax,'xscale','log','timeUnit','h')
shg;

% 4a Time Units
TestDescription{end+1}='4a) Test TimeUnits start 0';

ax=getNormFigure(3,3);
for iAx=1:9
    set(gcf, 'CurrentAxes', ax(iAx));
    xlim=[0 rand(1,1)*2^iAx];
    plot(mean(xlim),10,'*','markersize',12);
    setAxesScaling(ax(iAx),'timeUnit','h','xlim',xlim)
    xlabel('time [h]')
end
shg;

% 4b Time Units
TestDescription{end+1}='b) Test TimeUnits Start >0';

ax=getNormFigure(3,3);
for iAx=1:9
    set(gcf, 'CurrentAxes', ax(iAx));
    xlim=sort([rand(1,1)*2^(iAx+1) rand(1,1)*2^(iAx-1)]);
    plot(mean(xlim),10,'*','markersize',12);
    setAxesScaling(ax(iAx),'timeUnit','h','xlim',xlim)
    xlabel('time [h]')
end
shg;


% 4c Time Units
TestDescription{end+1}='c) Test TimeUnits different Units';
units={'sec','min','h','days','weeks','months'};
for iU=1:length(units)
    ax=getNormFigure(3,3);
    for iAx=1:9
        set(gcf, 'CurrentAxes', ax(iAx));
        xlim=sort([rand(1,1)*2^(iAx+1) rand(1,1)*2^(iAx-1)]);
        plot(mean(xlim),10,'*','markersize',12);
        setAxesScaling(ax(iAx),'timeUnit',units{iU},'xlim',xlim)
        xlabel(['time [' units{iU} ']'])
    end
    shg;
    pause(10);
end

% 4d special cases
TestDescription{end+1}='4d) special cases;';

ax=getNormFigure;
plot(ax,[1:10],[1:10],'-','linewidth',2);
setAxesScaling(ax,'timeUnit','days','xlim',[0.9 11.1])
shg;

% 5 Lin Log switch
ax=getNormFigure(1,1);
x=[0:0.1:20];
plot(x,x.^2);
setAxesScaling(ax,'yscale','log');
setAxesScaling(ax,'yscale','lin');
shg;



[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);
return