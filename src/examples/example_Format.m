function example_Format
%EXAMPLE_FORMAT example of figure formating
%
%   examples for the use of the formatting functions 
%   see also SETAXESSCALING,GETNORMFIGURE 
%
% Example 1
% Create a figure with one column and two rows of axes, 
% choose landscape as figureformat
% set the y-scale of the first plot to linear and to the second to log
% set the time unit of the x-Axes to h
%
% Example 2
% Create a figure with one histogramm in the first row and two istograms in the second row, 
% set the time unit of the first x-Axes to sec
%
% Example 3
% Reuse an existing figure handle 
% set many ticks with small fontsize
% 
% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 24-Dez-2010

close all;

%% Example 1
% Create a figure with one column and two rows of axes, 
% choose landscape as figureformat
% set the y-scale of the first plot to linear and to the second to log
% set the time unit of the x-Axes to h

% create the figure:
[ax_handle]=getNormFigure(2,1,[],'figureFormat','landscape');

% set the first axes active
set(gcf, 'CurrentAxes', ax_handle(1));
% Plot data
plot(0:24,rand(25,1),'x-','linewidth',2);
% set the Axes scaling 
setAxesScaling(ax_handle(1),'yscale','lin','timeUnit','h')
% set x and y label
xlabel('time [h]')
ylabel('random values')

% set the second axes active
set(gcf, 'CurrentAxes', ax_handle(2));
% Plot data
plot(0:24,rand(25,1),'x-','linewidth',2);
% set the Axes scaling; the cuurent axes is axes(ax_handle(2)), so gca is
% used as input for setAxesscaling
setAxesScaling(gca,'yscale','log','timeUnit','h')
% set x and y label
xlabel('time [h]')
ylabel('random values')

% set name of figure
set(gcf,'Name','Example 1')
shg;

%% Example 2
% Create a figure with one histogramm in the first row and two histograms in the second row, 
% set the time unit of the first x-Axes to sec

% create the figure:
[ax_handle]=getNormFigure(2,1,[],'axes_position',[0.1 0.6 0.8 0.3; 0.1 0.1 0.32 0.32; 0.6 0.1 0.32 0.32]);

% set the first axes active
set(gcf, 'CurrentAxes', ax_handle(1));
% Plot data
plot(0:60,rand(61,1),'x-','linewidth',2);
% set the Axes scaling 
setAxesScaling(ax_handle(1),'timeUnit','sec')
% set x and y label
xlabel('time [h]')
ylabel('random values')

% set the second axes active
set(gcf, 'CurrentAxes', ax_handle(2));
% Plot data
hist(rand(1000,1));
setAxesScaling(gca);
% set x and y label
xlabel('random values')
ylabel('number of entries')

% set the third axes active
set(gcf, 'CurrentAxes', ax_handle(3));
% Plot data
hist(randn(1000,1));
setAxesScaling(gca);
% set x and y label
xlabel('random values')
ylabel('number of entries')

% set name of figure
set(gcf,'Name','Example 2')
shg;

%% Example 3
% Reuse an existing figure handle 
% set many ticks with small fontsize

% Create  figure;
figure_handle=figure;

% plot something
plot(1:10);

% create the figure, the existing figure is cleared
[ax_handle]=getNormFigure(1,1,figure_handle,'fontsize',6);
plot(1:20,rand(20,1),'linewidth',2);
set(gca,'xtick',[0:20])
setAxesScaling(gca,'xlim',[0 20]);
xlabel('may ticks')
ylabel('random values')

% set name of figure
set(gcf,'Name','Example 3')
shg;


return

