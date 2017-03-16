function setAxesScaling(axes_handle,varargin)
% SETAXESSCALING Sets scaling and limit of x and y axes. Checks if sufficent ticks exist.
%   For linscale at least 3 ticks are set, for y-scale at least 2 with a difference of one order 
%   of magnitude. If the given limit is smaller than one order of magnitude it is increased.
%
%   SETAXESSCALING(axes_handle);
%       axes_handle: handle of an existing axis;
%
% options: 
%   xscale:
%   SETAXESSCALING(axes_handle,'xscale',xscale);
%       xscale: scale of the x-axis (lin,linear or log).
%
%   yscale:
%   SETAXESSCALING(axes_handle,'yscale',yscale);
%       yscale: scale of the y-axis (lin,linear or log).
%
%   xlim:
%   SETAXESSCALING(axes_handle,'xlim',xlim);
%       xlim: (2x1) vector limits of the x-axis.
%       If no xlim is given, the current values are fixed.
%
%   ylim:
%   SETAXESSCALING(axes_handle,'ylim',ylim);
%       ylim: (2x1) vector limits of the y-axis.
%       If no ylim is given, the current values are fixed.
%
%   timeUnit:
%   SETAXESSCALING(axes_handle,'timeUnit',timeUnit_value);
%       timeUnit_value: (string) ('sec','min','h','days','weeks','months').
%       The ticks of the x-axis are set to numbers corresonding to the
%       selected time unit. For example, for time unit h as multiples of 24.
%       This option works only with a linear x-scale.
% 
%
% Example Call:
%   setAxesScaling(axes_handle);
%   setAxesScaling(axes_handle,'xlim',[0 48],'timeUnit','h');
%
%   see also EXAMPLE_FORMAT

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 24-Dez-2010

%% check Inputs --------------------------------------------------------------
if ~exist('axes_handle','var')
    error('Axes handle is missing');
elseif ~ishandle(axes_handle)
    error('Axes handle is invalid');
end

% Check input options
[xscale,yscale,xlim,ylim,timeUnit] = ...
    checkInputOptions(varargin,{...
    'xscale',{'lin','linear','log'},nan,...
    'yscale',{'lin','linear','log'},nan,...
    'xlim',nan,nan,...
    'ylim',nan,nan,...
    'timeUnit',{'sec','s','min','h','day(s)','days','week(s)','months','weeks'},nan...
    });



%% set gca properties
%Reset ticks and scales
set(axes_handle,'YtickMode','auto');
set(axes_handle,'XtickMode','auto');
set(axes_handle,'XLimMode','auto');
set(axes_handle,'YLimMode','auto');
 
if isnan(xscale)
    xscale=get(axes_handle,'xscale');
end
set(axes_handle,'xscale',xscale);
if isnan(yscale)
    yscale=get(axes_handle,'yscale');
end
set(axes_handle,'yscale',yscale);
if isnan(xlim)
    xlim=get(axes_handle,'xlim');
elseif xlim(1)>=xlim(2)
    xlim=get(axes_handle,'xlim');
elseif xlim(1)==0 && strcmp(xscale,'log')
     warning('MoBiToolbox:Basis:setAxesScaling:AxesLog',...
        'The limit 0 cannot be used for logarithmic x-scale.');
end
set(axes_handle,'xlim',xlim);
if isnan(ylim)
    ylim=get(axes_handle,'ylim');
elseif ylim(1)==0 && strcmp(yscale,'log')
     warning('MoBiToolbox:Basis:setAxesScaling:AxesLog',...
        'The limit 0 cannot be used for logarithmic y-scale.');
elseif ylim(1)>=ylim(2)
    ylim=get(axes_handle,'ylim');
end
set(axes_handle,'ylim',ylim);

% Check if time unit is used with logarithmic xscale
if ~isnan(timeUnit)
    if strcmp(xscale,'log')
    warning('MoBiToolbox:Basis:setAxesScaling:TimUnitLog',...
        'The option timeUnit cannot be used for logarithmic x-scale. The option is ignored.');
    else
        setTicksForTimeUnit(axes_handle,xlim,timeUnit);
    end
end
    

%% check ticks
xt=get(axes_handle,'xtick');
switch xscale
    case 'log'
        xt=get(axes_handle,'xtick');
        [xt,xlim]=getLogTicks(xlim,xt);
        set(axes_handle,'xtick',xt,'xlim',xlim);
    case {'linear','lin'}
        if length(xt)<3
            xt=getLinearTicks(xlim);
            set(axes_handle,'xtick',xt);
        end
end


yt=get(axes_handle,'ytick');
switch yscale
    case 'log'
        yt=get(axes_handle,'ytick');
        [yt,ylim]=getLogTicks(ylim,yt);
        set(axes_handle,'ytick',yt,'ylim',ylim);
    case {'linear','lin'}
        if length(yt)<3
            yt=getLinearTicks(ylim);
            set(axes_handle,'ytick',yt);
        end
end

return

% --- generate 3 or 4 linear distributed ticks
function xt=getLinearTicks(xlim)

% generate 3 xticks with as few digits as possible
xt=[0 nan 0];
pot=10.^floor(log10(range(xlim)));
while xt(1)==xt(3);
    xlim_sc=xlim/pot;
    xt(3)=floor(xlim_sc(end))*pot;
    xt(1)=ceil(xlim_sc(1))*pot;
    xt(2)=mean(xt([1 3]));
    pot=pot/10;
end
                
xt=unique(xt);

% check if the range between tick and xlim is not to big
dx=xt(2)-xt(1);
if xt(end)+dx < xlim(2)
    xt(end+1) = xt(end)+dx;
end

if xt(1)-dx > xlim(1)
    xt = [(xt(1)-dx),xt];
end

% return not more than 4 ticks
if length(xt)==5
    xt=xt([1 3 5]);
end

return

% --- generate 2 or 4 logarithmic distributed ticks
function [xt,xlim]=getLogTicks(xlim,xt)

% number of ticks is equal to the original number of ticks, but at least 2
nTicks=max(2,length(xt));

% calculate the order of magnitude of the xlim
p1=ceil(log10(xlim(1)));
p2=floor(log10(xlim(end)));

% Force teh tick to one order of magnitude
if p2<p1
    p1=floor(log10(xlim(1)));
    p2=ceil(log10(xlim(end)));
    xlim=10.^[p1 p2];
elseif p2==p1
    if (p1-log10(xlim(1))) > (log10(xlim(end))-p2)
        p1=floor(log10(xlim(1)));
        xlim(1)=10.^p1;
    else
        p2=ceil(log10(xlim(end)));
        xlim(2)=10.^p2;
    end
end

% return 2 or three ticks
xt=10.^[p1:max(round((p2-p1)/nTicks),1):p2]; %#ok<NBRAK>
return

% calulates ticks depending to the timeUnit
function  setTicksForTimeUnit(axes_handle,xlim,timeUnit)

% number of ticks is equal to the original number of ticks, but at least 3
nTicks=max(3,length(get(axes_handle,'xtick')));

% get unit dependent tick offset
switch timeUnit
    case {'s','sec','min'}
        offset=[60,30,15,10,5,1];
    case {'h'}
        offset=[24,12,6,4,3,1];
    case {'days','day(s)'}
        offset=[7,1];
    case {'weeks','week(s)'}
        offset=[4,1];
    case 'months'
        offset=[12,6,3,1];
    otherwise
        offset=1;
end

% Generate ticks with selected offset
xt=[];
for iO=1:length(offset)
    if (max(xlim) - min(xlim)) > offset(iO)
        xt=ceil(xlim(1)/offset(iO))*offset(iO):offset(iO):xlim(2);
        if length(xt)>=nTicks
            break;
        end
    end
end

if length(xt)>nTicks
    delta=round(length(xt)/nTicks);
    xt=xt(1:delta:end);
elseif length(xt)==1
    xtest=floor(xt(1)-offset(iO)/2);
    if xtest>=xlim(1) && xtest < xt(1)
        xt=[xtest xt];
    end
    xtest=floor(xt(end)+offset(iO)/2);
    if xtest<=xlim(2) && xtest > xt(end)
        xt=[xt xtest];
    end
end
    

set(axes_handle,'xtick',xt);

return