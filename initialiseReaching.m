function [data,window, filename, display] = initialiseReaching()
% Demographic information.
data.demographics.number = str2double(inputdlg('Enter participant number'));
data.demographics.age = str2double(inputdlg('Enter participant age'));
data.demographics.gender = string(inputdlg('Enter participant gender'));


%% Screen Stuff
Screen('Preference', 'SkipSyncTests', 1)
PsychDefaultSetup(2);
screens = Screen('Screens');
screenNumber = max(screens);

window.ptr = PsychImaging('OpenWindow',screenNumber,[0 0 0]);

% Measure the vertical refresh rate of the monitor
[x,y] = Screen('WindowSize', screenNumber);
window.Xrect = x/2; window.Yrect = y/2;

% Retreive the maximum priority number
topPriorityLevel = MaxPriority(window.ptr);
Priority(topPriorityLevel);

% Find the resolution of the screen
window.ifi = Screen('GetFlipInterval', window.ptr);
tmp = Screen('Resolution',0);
window.resolution = [tmp.width,tmp.height];
window.frame_rate = 1/window.ifi;

Screen('TextSize',window.ptr,24);
Screen('TextFont',window.ptr,'Calibri');


%% File Stuff
h1 = datestr(now,30);
s = strfind(h1, ' ');
h1(s) = '_';
filename = sprintf('P%d_vs_%s',data.demographics.number, h1);
display.dist = 60;%cm
display.width = 29;%cm
display.resolution = window.resolution;
HideCursor()

end