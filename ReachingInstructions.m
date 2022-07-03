function ReachingInstructions(w,Xrect,Yrect,leftBox,rightBox)
c = clock;
        c = fix(c);
        
        if c(4) <= 12
            welcome = 'Good Morning';
        else
            welcome = 'Good Afternoon';
        end
        

Screen('TextSize',w,30);
DrawFormattedText2(sprintf('<b><color=00ffff>%s<color><b>\n\n\n In this task, you will see circular fields of moving dots known as random-dot kinematograms (RDKS). \n\n <b><color=00ffff>Press any key to continue<b><color>',welcome),'win',w,'sx','center','sy','center','xalign','center','yalign','center','xlayout','center','baseColor',[255 255 255],'wrapat',100);
Screen('Flip',w);
Screen('TextSize',w,30);
KbPressWait;


instructionsText = strcat('In each RDK, some of the dots move coherently (either leftwards or rightwards), while the rest move randomly.',...
    '\n\nThe task is to report the direction of motion in the <b><color=00ffff>CENTRE<b><color> RDK\n  (left or right).',...
    '\n\n\n<b><color=00ffff>Press any key to continue<b><color>');


DrawFormattedText2(instructionsText,'win',w,'sx','center','sy','center','xalign','center','yalign','center','xlayout','center','wrapat',100);%'baseColor',[255 255 255]);
Screen('Flip',w);
KbStrokeWait;



leftInstr = strcat('If the coherent motion in the <b>CENTER<b> RDK is moving <b>LEFTWARDS<b>, move the stylus to the box on the left.');
rightInstr = strcat('If the coherent motion in the <b> CENTER <b> RDK is moving <b>RIGHTWARDS<b>, move the stylus to the box on the right');


DrawFormattedText2(leftInstr,'win',w,'sx','center','sy','center','wrapat',60,'xalign','left','xlayout','center');%'baseColor',[255 255 255]);
Screen('FrameRect', w, [255 255 255], leftBox);
DrawFormattedText2('<color=00ffff><b>Press any key to continue<color><b>','win',w,'sx','center','sy',Yrect+200,'xalign','center','yalign','center','xlayout','center','wrapat',100);%'baseColor',[255 255 255]);
Screen('Flip',w);
KbPressWait;
           
DrawFormattedText2(rightInstr,'win',w,'sx','center','sy','center','wrapat',60,'xalign','right','xlayout','center');%'baseColor',[255 255 255]);
Screen('FrameRect', w, [255 255 255], rightBox);
DrawFormattedText2('<color=00ffff><b>Press any key to continue<color><b>','win',w,'sx','center','sy',Yrect+200,'xalign','center','yalign','center','xlayout','center','wrapat',100);%'baseColor',[255 255 255]);
Screen('Flip',w);
KbPressWait;
