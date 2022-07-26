function BaselineInstructions(w,leftBox,rightBox)
c = clock;
        c = fix(c);
        
        if c(4) <= 12
            welcome = 'Good Morning';
        else
            welcome = 'Good Afternoon';
        end
        

Screen('TextSize',w.ptr,18);
DrawFormattedText(w.ptr,sprintf('%s\n\n\n In this task, you will see a circular field of moving dots known as a random-dot kinematogram (RDKS).',welcome),'center','center',[255 255 255],40,[],[],2);
DrawFormattedText(w.ptr,'Press space to continue','center',w.Yrect+300,[0 255 255],100,[],[],2);
Screen('Flip',w.ptr);
Screen('TextSize',w.ptr,18);
KbPressWait;


instructionsText = strcat('Within the RDK, some of the dots move coherently (either leftwards or rightwards), while the rest move randomly.',...
    '\n\nThe task is to report the direction of motion in the RDK\n  (left or right).');


DrawFormattedText(w.ptr,instructionsText,'center','center',[255 255 255],100,[],[],2)%'sx','center','sy','center','xalign','center','yalign','center','xlayout','center','wrapat',100);%'baseColor',[255 255 255]);
DrawFormattedText(w.ptr,'Press space to continue.','center',w.Yrect+300,[0 255 255],100,[],[],2);%'baseColor',[255 255 255]);
Screen('Flip',w.ptr);
KbStrokeWait;



leftInstr = strcat('If the coherent motion in the RDK is moving LEFTWARDS, move the stylus to the box on the left.');
rightInstr = strcat('If the coherent motion in the RDK is moving RIGHTWARDS, move the stylus to the box on the right');


DrawFormattedText(w.ptr,leftInstr,w.Xrect+100,w.Yrect-200,[255 255 255],30,[],[],2);
Screen('FrameRect', w.ptr, [255 255 255], leftBox);
DrawFormattedText(w.ptr,'Press space to continue.','center',w.Yrect+300,[0 255 255],100,[],[],2);%'baseColor',[255 255 255]);
Screen('Flip',w.ptr);
KbPressWait;
           
DrawFormattedText(w.ptr,rightInstr,w.Xrect-400,w.Yrect-200,[255 255 255],30,[],[],2);
Screen('FrameRect', w.ptr, [255 255 255], rightBox);
DrawFormattedText(w.ptr,'Press space to continue.','center',w.Yrect+300,[0 255 255],100,[],[],2);
Screen('Flip',w.ptr);
KbPressWait;
