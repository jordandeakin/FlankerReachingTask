function trialMat = runBaselineReachingTrials(w,display,trialMat,startBox,leftBox,rightBox,rdkCent)


% Trial Loop
for iTrial = 1:height(trialMat)

    responseMade = false;
    % Trial Parameters
    targetDir = trialMat.TargetDir(iTrial);
     coherence = trialMat.Coherence(iTrial);

    inBox = false;
    startTrial = false;


    % While trial has not started
    while ~startTrial
        % while participant has not moved to start box.
        while ~inBox

            [mouseX,mouseY] = GetMouse(w.ptr);
            Screen('FillOval', w.ptr,[255 0 0], [mouseX-5,mouseY-5,mouseX+5,mouseY+5]);
            DrawFormattedText(w.ptr,'Move the stylus into the start box.','center',rdkCent,[255 255 255],100,[],[],2);
            Screen('FrameRect', w.ptr, [255 0 0]*.75, startBox);
            Screen('Flip',w.ptr);
            [mouseX,mouseY] = GetMouse(w.ptr);
            inBox = inStart(mouseX,mouseY,startBox);



            % If they are in the box, show prompt.
            while inBox
                [mouseX,mouseY,buttons] = GetMouse(w.ptr);
                inBox = inStart(mouseX,mouseY,startBox);

                Screen('FillOval', w.ptr,[255 0 0], [mouseX-5,mouseY-5,mouseX+5,mouseY+5]);
                DrawFormattedText(w.ptr,'Click the start box to start the trial.','center',rdkCent,[255 255 255],100,[],[],2);
                Screen('FrameRect', w.ptr, [255 165 0]*.75, startBox);
                Screen('Flip',w.ptr);

                % If they have clicked to start, show the fixation cross
                % while checking they are still in the box.
                if any(buttons)
                    fixOnset = GetSecs();
                    while inBox && (GetSecs - fixOnset) <= .5

                        [mouseX,mouseY,~] = GetMouse(w.ptr);
                        inBox = inStart(mouseX,mouseY,startBox);

                        DrawFormattedText(w.ptr,'+','center',rdkCent,[255 255 255],100,[],[],2);
                        Screen('FrameRect', w.ptr, [255 165 0]*.75, startBox);
                        Screen('Flip',w.ptr);


                    end
                    startTrial = true;


                    break;
                end
            end
        end

    end











    % Create RDK objects.
    target = rdk('display',display,'nDots',50,'coherence',coherence,'direction',targetDir,'speed',3,'centre',[w.Xrect, rdkCent],'lifetime',.5*w.frame_rate,'itemApertureSize',3);
    


    % Initialise dot postitions.
    Screen('DrawDots', w.ptr, [target.dotX;target.dotY],2,[255 255 255],[],1);
    Screen('FrameRect', w.ptr, [80 80 80], leftBox);
    Screen('FrameRect', w.ptr, [80 80 80], rightBox);
    Screen('FillOval', w.ptr,[255 0 0], [mouseX-5,mouseY-5,mouseX+5,mouseY+5]);

      

    mouseXF = [];
    mouseYF = [];
    timestamps = [];


    stimulusOnset = Screen('Flip',w.ptr);
    trialMat.onset(iTrial) = stimulusOnset;
    vbl = stimulusOnset;
      [mouseXF(1),mouseYF(1)] = GetMouse(w.ptr);
 trialMat.onsetPos(iTrial,:) = [mouseXF(1),mouseYF(1)];
 timestamps(1) = vbl;
tooSlow = 0;

    iFrame = 1;

    while ~responseMade
        iFrame = iFrame + 1;
        [ keyIsDown, ~, keyCode ] = KbCheck;

        % Check for quits.
        if keyIsDown && keyCode(KbName('q'))
            sca
            error('quit')
        end


        [mouseXF(iFrame),mouseYF(iFrame)] = GetMouse(w.ptr);
        timestamps(iFrame) = GetSecs;


        % Animation
        moveDots(target); % move the dots.
        checkIfOut(target); % check if any dots are outside the aperture.
        checkIfDead(target); % check if any dots are dead.

         
        % Redraw dots in new locations and stylus dot.
        Screen('DrawDots', w.ptr, [target.dotX;target.dotY],2,[255 255 255],[],1);
              Screen('FrameRect', w.ptr, [80 80 80], leftBox);
        Screen('FrameRect', w.ptr, [80 80 80], rightBox);
        Screen('FillOval', w.ptr,[255 0 0], [mouseXF(iFrame)-5,mouseYF(iFrame)-5,mouseXF(iFrame)+5,mouseYF(iFrame)+5]);

        [vbl] =  Screen('Flip',w.ptr,vbl + 0.5 * w.ifi);
        currTime = GetSecs();


        if currTime - stimulusOnset > 1.5
           tooSlow = 1;
        end

        % Save RT and stylus path.
        if responseMade
            trialMat.RT(iTrial) = timeOfResponse-stimulusOnset;
        else
            trialMat.RT(iTrial) = currTime - stimulusOnset;
            trialMat.Acc(iTrial) = 0;
        end

        % If response made in left box, code accuracy.
        if inLeft(mouseXF(iFrame),mouseYF(iFrame),leftBox)
            timeOfResponse = GetSecs;
            choice = 1;
            responseMade = true;
            if targetDir > 0
                trialMat.Acc(iTrial) = 1;
            else
                trialMat.Acc(iTrial) = 0;
            end
        end

  

        % If in right box..
        if inRight(mouseXF(iFrame),mouseYF(iFrame),rightBox)
            timeOfResponse = GetSecs;
            choice = 2;
            responseMade = true;
            if targetDir < 0
                trialMat.Acc(iTrial) = 1;
            else
                trialMat.Acc(iTrial) = 0;
            end

        end
        %  responseMade
    end


if responseMade
    waited = false;

    while (GetSecs - timeOfResponse) < .3 && inBox
        waited = 1;
        iFrame = iFrame + 1;
           timestamps(iFrame) = GetSecs;

        [mouseXF(iFrame), mouseYF(iFrame)] = GetMouse(w.ptr);


        if choice == 1
            inBox = inLeft(mouseXF(iFrame),mouseYF(iFrame),leftBox);
            chosenBox = leftBox; otherBox = rightBox;
        elseif choice == 2
            inBox = inRight(mouseXF(iFrame),mouseYF(iFrame),rightBox);
            chosenBox = rightBox; otherBox = leftBox;
        end


        Screen('FrameRect', w.ptr, [80 80 80], chosenBox,5);
        Screen('FrameRect', w.ptr, [80 80 80], otherBox);
        Screen('FillOval', w.ptr,[255 0 0], [mouseXF(iFrame)-5,mouseYF(iFrame)-5,mouseXF(iFrame)+5,mouseYF(iFrame)+5]);
        Screen('Flip',w.ptr)

        if ~inBox
            DrawFormattedText(w.ptr,'Please try to remain in the response box until it turns green.','center',rdkCent,[255 255 255],100,[],[],2);
            Screen('Flip',w.ptr);
            WaitSecs(1);
            waited = 0;
            break
        end
    end



    if waited
        Screen('FrameRect', w.ptr, [0 255 0], chosenBox);
        Screen('FrameRect', w.ptr, [80 80 80], otherBox);
        Screen('FillOval', w.ptr,[255 0 0], [mouseXF(iFrame)-5,mouseYF(iFrame)-5,mouseXF(iFrame)+5,mouseYF(iFrame)+5]);
        Screen('Flip',w.ptr)
        WaitSecs(.2)
    end


        trialMat.waited(iTrial) = waited;

      % Show too Slow
        if tooSlow
               DrawFormattedText(w.ptr,'Your previous response was too slow!','center',rdkCent,[255 255 255],100,[],[],2)
            Screen('Flip',w.ptr)
            choice = 0;
            WaitSecs(.5);
            
        end

            % Show feedback in practice trials.
    if trialMat.Practice(iTrial) == 1
        showFeedback(trialMat.Acc(iTrial));
        % DrawFormattedText2(showFeedback(trialMat.Acc(iTrial)),'win',w.ptr,'sx','center','sy','center','xalign','center');
        % Screen('Flip',w.ptr);
        % WaitSecs(.5);
    end

        
    % Show a break every 32 trials.
    if mod(iTrial,32) == 0
        breakScreen(w);
    end
    
end



    mousePath.X = mouseXF;
    mousePath.Y = mouseYF;
    mousePath.time = timestamps;


    % Add stylus path to trial matrix.
    trialMat.tooSlow(iTrial) = tooSlow;
    trialMat.MousePathX(iTrial) = {mousePath.X};
    trialMat.MousePathY(iTrial) = {mousePath.Y};
    trialMat.timestamps(iTrial) = {mousePath.time};

end

recodedDir(trialMat.TargetDir == -67.5) = {'right'};
recodedDir(trialMat.TargetDir == 67.5) = {'left'};

trialMat.TargetDir = recodedDir';





    function showFeedback(acc)
        if acc == 0
            beep2
        end
    end

    function breakScreen(w)

        DrawFormattedText(w.ptr,'Time for a break!\n\nThis break lasts 60 seconds and cannot be skipped!','center','center',[255 255 255],100,[],[],2);
        Screen('Flip',w.ptr);
        WaitSecs(60);

        DrawFormattedText(w.ptr,'Ready to continue?\n\n','center','center',[255 255 255],100,[],[],2)
        DrawFormattedText(w.ptr,'Press any key to start!','center',w.Yrect+300,[0 255 255],100,[],[],2);
        Screen('Flip',w.ptr);
        KbStrokeWait;

    end



    function beep2
        % Play a sine wave
        res = 22050;
        len = 0.5 * res;
        hz = 220;
        sound( sin( hz*(2*pi*(0:len)/res) ), res);
    end

    function out = inStart(x,y,startBox)
        out = x > startBox(1) && x < startBox(3) && y > startBox(2) && y < startBox(4);
    end

    function out = inLeft(x,y,leftBox)
        out = x > leftBox(1) && x < leftBox(3) && y > leftBox(2) && y < leftBox(4);
    end

    function out = inRight(x,y,rightBox)
        out = x > rightBox(1) && x < rightBox(3) && y > rightBox(2) && y < rightBox(4);
    end

end