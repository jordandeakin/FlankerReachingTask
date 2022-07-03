function [data, w, filename, display, Xrect, Yrect] = initialiseReaching()

% Demographic information.
data.demographics.number = str2double(inputdlg('Enter participant number'));
data.demographics.age = str2double(inputdlg('Enter participant age'));
data.demographics.gender = string(inputdlg('Enter participant gender'));


Screen('Preference', 'SkipSyncTests', 1);
[w, winrect] = Screen('OpenWindow',0,[0,0,0]);
h1 = datestr(now,30);
s = strfind(h1, ' ');
h1(s) = '_';
filename = sprintf('P%d_vs_%s',data.demographics.number, h1);
display.dist = 60;%cm
display.width = 29;%cm
HideCursor()


% Find the resolution of the screen
tmp = Screen('Resolution',0);
display.resolution = [tmp.width,tmp.height];
refresh_interval = Screen('GetFlipInterval',w);
display.frame_rate = 1/refresh_interval;

% Calculate monitor refresh interval and convert into frames / second
[Xrect,Yrect] = RectCenter(winrect);
Screen('TextSize',w,24);
Screen('TextFont',w,'Calibri');
end