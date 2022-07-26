close all
trialSequence = trialSequence(trialSequence.Acc == 1,:);
%[data, w, filename, display] = initialiseReaching();sca
    startBox = [w.Xrect-50, w.Yrect+400, w.Xrect+50, w.Yrect+500];
    leftBox = [w.Xrect-900, w.Yrect-450, w.Xrect-750, w.Yrect-300];
    rightBox = [w.Xrect+750, w.Yrect-450, w.Xrect+900, w.Yrect-300];
    rdkCent = w.Yrect - 400;


[leftCX, leftCY] = RectCenter(leftBox);
[rightCX, rightCY] = RectCenter(rightBox);
[startCX, startCY] = RectCenter(startBox);

plot([leftCX-75 leftCX+75],[leftCY+75 leftCY+75],'k-')
hold on
plot([leftCX-75 leftCX+75],[leftCY-75 leftCY-75],'k-')
plot([leftCX-75 leftCX-75],[leftCY-75 leftCY+75],'k-')
plot([leftCX+75 leftCX+75],[leftCY-75 leftCY+75],'k-')

plot([rightCX-75 rightCX+75],[rightCY+75 rightCY+75],'k-')
plot([rightCX-75 rightCX+75],[rightCY-75 rightCY-75],'k-')
plot([rightCX-75 rightCX-75],[rightCY-75 rightCY+75],'k-')
plot([rightCX+75 rightCX+75],[rightCY-75 rightCY+75],'k-')

plot([startCX-75 startCX+75],[startCY+75 startCY+75],'k-')
plot([startCX-75 startCX+75],[startCY-75 startCY-75],'k-')
plot([startCX-75 startCX-75],[startCY-75 startCY+75],'k-')
plot([startCX+75 startCX+75],[startCY-75 startCY+75],'k-')


set(gca,'YDir','reverse')
set(gcf,'WindowStyle','docked')

ylim([0 1080])
xlim([0 1920])

for i = 1:height(trialSequence)
    x = trialSequence.MousePathX{i};
    y = trialSequence.MousePathY{i};

    plot(x,y,'k')
    
    if strcmp(trialSequence.TargetDir{i},'left')
    idx = find(x > leftBox(1) & x < leftBox(3) & y > leftBox(2) & y < leftBox(4),1,'first');
    else
    idx = find(x > rightBox(1) & x < rightBox(3) & y > rightBox(2) & y < rightBox(4),1,'first');
    end

    plot(x(idx),y(idx),'ro')
    
    drawnow
WaitSecs(1)
end

