Screen('Preference','VisualDebugLevel',1)
window = Screen('OpenWindow',0);
Screen('TextSize',window,24);
Screen('TextFont',window,'Times');
circler = 150;
circlec = 400;
textX = 200;
textY = 200;
Cursorsize = 6;
mousedata = zeros(10000,2);
sample = 0;
SetMouse(circlec-circler,circlec,window);
HideCursor

buttons = 1;
while any(buttons)
    [mouseX,mouseY,buttons] = GetMouse(window);
end

DesiredSampleRate = 65;
clear sampletime;
begintime = GetSecs;
nextsampletime = begintime;
while buttons(1) == 0
    sample = sample + 1;
    xlocaton = 0;
    lowerbound = circlec-circler;
    upperbound = circlec+circler;
    Screen('DrawText',window,'Trace',textX,textY,[0 0 0]);
    Screen('FrameOval',window,[0 0 0],[lowerbound lowerbound upperbound upperbound]);
    Screen('FrameOval',window,[0 0 0],[mouseX-Cursorsize mouseY-Cursorsize, mouseX + Cursorsize, mouseY+Cursorsize],3);
    Screen('Flip',window);
    [mouseX, mouseY, buttons] = GetMouse(window);
    mousedata(sample,1) = mouseX;
    mousedata(sample,2) = mouseY;
    sampletime(sample) = GetSecs;
    nextsampletime = nextsampletime + 1/DesiredSampleRate;
    while GetSecs < nextsampletime
    end
end

endtime = GetSecs;
ElapsedTime = endtime-begintime;
NumberOfSamples = sample;
ActualSampleRate = 1/(ElapsedTime/NumberOfSamples);
mousedata = mousedata(1:sample,1:2);
ShowCursor
sca
size(mousedata)
clf
plot(mousedata(:,1),mousedata(:,2));
set(gca,'YDir','reverse')
    axis equal
    shg