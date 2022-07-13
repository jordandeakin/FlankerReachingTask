function trialMat = runReachingTrials(w,display,trialMat,startBox,leftBox,rightBox,rdkCent)

% Trial Loop
for iTrial = 1:height(trialMat)

    responseMade = false;
    % Trial Parameters
    targetDir = trialMat.TargetDir(iTrial);
    flankerDir = trialMat.FlankerDir(iTrial);
    coherence = trialMat.Coherence(iTrial);

    inBox = false;
    startTrial = false;


    % While trial has not started
    while ~startTrial
        % while participant has not moved to start box.
        while ~inBox

            [mouseX,mouseY] = GetMouse(w.ptr);
            Screen('FillOval', w.ptr,[255 0 0]*25, [mouseX-5,mouseY-5,mouseX+5,mouseY+5]);
            DrawFormattedText(w.ptr,'Move the stylus into the start box.','center',rdkCent,[255 255 255],100,[],[],2);
            Screen('FrameRect', w.ptr, [255 0 0]*.25, startBox);
            Screen('Flip',w.ptr);
            [mouseX,mouseY] = GetMouse(w.ptr);
            inBox = mouseX > startBox(1) & mouseX < startBox(3) & mouseY > startBox(2) & mouseY < startBox(4);



            % If they are in the box, show prompt.
            while inBox
                inBox = mouseX > startBox(1) & mouseX < startBox(3) & mouseY > startBox(2) & mouseY < startBox(4);

                [mouseX,mouseY,buttons] = GetMouse(w.ptr);

                Screen('FillOval', w.ptr,[255 0 0]*25, [mouseX-5,mouseY-5,mouseX+5,mouseY+5]);
                DrawFormattedText(w.ptr,'Click the start box to start the trial.','center',rdkCent,[255 255 255],100,[],[],2);
                Screen('FrameRect', w.ptr, [255 165 0]*.25, startBox);
                Screen('Flip',w.ptr);

                % If they have clicked to start, show the fixation cross
                % while checking they are still in the box.
                if any(buttons)
                    fixOnset = GetSecs();
                    while inBox && (GetSecs - fixOnset) <= .5
                        DrawFormattedText(w.ptr,'+','center',rdkCent,[255 255 255],100,[],[],2);
                        Screen('FrameRect', w.ptr, [255 165 0]*.25, startBox);
                        Screen('Flip',w.ptr);
                        [mouseX,mouseY,~] = GetMouse(w.ptr);
                        inBox = mouseX > startBox(1) & mouseX < startBox(3) & mouseY > startBox(2) & mouseY < startBox(4);


                    end
                    startTrial = true;


                    break;
                end
            end
        end

    end











    % Create RDK objects.
    target = rdk('display',display,'nDots',50,'coherence',coherence,'direction',targetDir,'speed',3,'centre',[w.Xrect, rdkCent],'lifetime',.5*w.frame_rate,'itemApertureSize',3);
    leftFlank = rdk('display',display,'nDots',50,'coherence',coherence,'direction',flankerDir,'speed',3,'centre',[w.Xrect-300; rdkCent],'lifetime',.5*w.frame_rate,'itemApertureSize',3);
    rightFlank = rdk('display',display,'nDots',50,'coherence',coherence,'direction',flankerDir,'speed',3,'centre',[w.Xrect+300; rdkCent],'lifetime',.5*w.frame_rate,'itemApertureSize',3);


    [mouseX,mouseY] = GetMouse(w.ptr);

    % Initialise dot postitions.
    iFrame = 0;
    Screen('DrawDots', w.ptr, [target.dotX;target.dotY],2,[255 255 255],[],1);
    Screen('DrawDots', w.ptr, [leftFlank.dotX;leftFlank.dotY],2,[255 255 255],[],1);
    Screen('DrawDots', w.ptr, [rightFlank.dotX;rightFlank.dotY],2,[255 255 255],[],1);
    %Screen('FrameRect', w, [40 40 40], startBox);
    Screen('FrameRect', w.ptr, [40 40 40], leftBox);
    Screen('FrameRect', w.ptr, [40 40 40], rightBox);
    Screen('FillOval', w.ptr,[255 0 0]*25, [mouseX-5,mouseY-5,mouseX+5,mouseY+5]);

    stimulusOnset = Screen('Flip',w.ptr);
    vbl = stimulusOnset;


    while ~responseMade
        iFrame = iFrame + 1;
        [ keyIsDown, ~, keyCode ] = KbCheck;

        % Check for quits.
        if keyIsDown && keyCode(KbName('q'))
            sca
            error('quit')
        end


        [mouseX(iFrame),mouseY(iFrame)] = GetMouse(w.ptr);


        % Animation
        moveDots(target); % move the dots.
        checkIfOut(target); % check if any dots are outside the aperture.
        checkIfDead(target); % check if any dots are dead.

        moveDots(leftFlank);
        checkIfOut(leftFlank);
        checkIfDead(leftFlank);

        moveDots(rightFlank);
        checkIfOut(rightFlank);
        checkIfDead(rightFlank);

        % Redraw dots in new locations and stylus dot.
        Screen('DrawDots', w.ptr, [target.dotX;target.dotY],2,[255 255 255],[],1);
        Screen('DrawDots', w.ptr, [leftFlank.dotX;leftFlank.dotY],2,[255 255 255],[],1);
        Screen('DrawDots', w.ptr, [rightFlank.dotX;rightFlank.dotY],2,[255 255 255],[],1);
        %  Screen('FrameRect', w, [40 40 40], startBox);
        Screen('FrameRect', w.ptr, [40 40 40], leftBox);
        Screen('FrameRect', w.ptr, [40 40 40], rightBox);
        Screen('FillOval', w.ptr,[255 0 0]*25, [mouseX(iFrame)-5,mouseY(iFrame)-5,mouseX(iFrame)+5,mouseY(iFrame)+5]);

        [vbl] =  Screen('Flip',w.ptr,vbl + 0.5 * w.ifi);
        currTime = GetSecs();


        if currTime - stimulusOnset > 1.5
            DrawFormattedText(w.ptr,'Too Slow!','center',rdkCent,[255 255 255],100,[],[],2)
            Screen('Flip',w.ptr)
            WaitSecs(.5)
            break
        end

        % Save RT and stylus path.
        if responseMade
            trialMat.RT(iTrial) = timeOfResponse-stimulusOnset;
        else
            trialMat.RT(iTrial) = currTime - stimulusOnset;
            trialMat.Acc(iTrial) = 0;
        end

        % If response made in left box, code accuracy.
        if mouseX(iFrame) > leftBox(1) && mouseX(iFrame) < leftBox(3) && mouseY(iFrame) > leftBox(2) && mouseY(iFrame) < leftBox(4)
            timeOfResponse = GetSecs;
            responseMade = true;
            if targetDir > 0
                trialMat.Acc(iTrial) = 1;
            else
                trialMat.Acc(iTrial) = 0;
            end
        end



        % If response made in right box, code accuracy.
        if mouseX(iFrame) > rightBox(1) && mouseX(iFrame) < rightBox(3) && mouseY(iFrame) > rightBox(2) && mouseY(iFrame) < rightBox(4)
            timeOfResponse = GetSecs;
            responseMade = true;
            if targetDir < 0
                trialMat.Acc(iTrial) = 1;
            else
                trialMat.Acc(iTrial) = 0;
            end

        end

        %  responseMade



    end

    mousePath.X = mouseX;
    mousePath.Y = mouseY;



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



    % Add stylus path to trial matrix.
    trialMat.MousePathX(iTrial) = {mousePath.X};
    trialMat.MousePathY(iTrial) = {mousePath.Y};
end


recodedDir(trialMat.TargetDir == -67.5) = {'right'};
recodedDir(trialMat.TargetDir == 67.5) = {'left'};
recodedFlankDir(trialMat.FlankerDir == -67.5) = {'right'};
recodedFlankDir(trialMat.FlankerDir == 67.5) = {'left'};

trialMat.TargetDir = recodedDir';
trialMat.FlankerDir = recodedFlankDir';




    function breakScreen(w)

        DrawFormattedText(w.ptr,'Time for a break!\n\nThis break lasts 60 seconds and cannot be skipped!','center','center',[255 255 255],100,[],[],2);
        Screen('Flip',w.ptr);
        WaitSecs(60);

        DrawFormattedText(w.ptr,'Ready to continue?\n\n','center','center',[255 255 255],100,[],[],2)
        DrawFormattedText(w.ptr,'Press any key to start!','center',w.Yrect+300,[0 255 255],[],[],2);
        Screen('Flip',w.ptr);
        KbStrokeWait;

    end





    function showFeedback(acc)
        if acc == 0
            beep2
        end
    end

    function beep2
        % Play a sine wave
        res = 22050;
        len = 0.5 * res;
        hz = 220;
        sound( sin( hz*(2*pi*(0:len)/res) ), res);
    end
end