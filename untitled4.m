close all
[data, w, filename, display] = initialiseReaching();sca
    startBox = [w.Xrect-50, w.Yrect+400, w.Xrect+50, w.Yrect+500];
    leftBox = [w.Xrect-900, w.Yrect-450, w.Xrect-750, w.Yrect-300];
    rightBox = [w.Xrect+750, w.Yrect-450, w.Xrect+900, w.Yrect-300];
    rdkCent = w.Yrect - 400;

[leftCX, leftCY] = RectRight(leftBox);
[rightCX, rightCY] = RectRight(rightBox);
[startCX, startCY] = RectRight(startBox);


plot(x,y)
hold on
set(gca,'YDir','reverse')
set(gcf,'WindowStyle','docked')
plot([leftCX-75 leftCX+75],[leftCY+75 leftCY+75],'ko-')
plot([leftCX-75 leftCX+75],[leftCY-75 leftCY-75],'ko-')
plot([leftCX-75 leftCX-75],[leftCY-75 leftCY+75],'ko-')
plot([leftCX+75 leftCX+75],[leftCY-75 leftCY+75],'ko-')

plot([leftCX-75 leftCX+75],[leftCY+75 leftCY+75],'ko-')
plot([leftCX-75 leftCX+75],[leftCY-75 leftCY-75],'ko-')
plot([leftCX-75 leftCX-75],[leftCY-75 leftCY+75],'ko-')
plot([leftCX+75 leftCX+75],[leftCY-75 leftCY+75],'ko-')
ylim([0 1080])
xlim([0 1920])
pbaspect([1,1,1])