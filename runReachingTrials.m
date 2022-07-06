function trialMat = runReachingTrials(w,display,Xrect,trialMat,startBox,leftBox,rightBox,rdkCent)


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
            [mouseX,mouseY] = GetMouse(w);
            Screen('DrawDots', w, [mouseX;mouseY], 10,[255 0 0]);
            DrawFormattedText2('Move the stylus into the start box.','win',w,'sx','center','sy',rdkCent,'xalign','center');
            Screen('FrameRect', w, [255 0 0]*.25, startBox);
            Screen('Flip',w);
            
            
            [mouseX,mouseY] = GetMouse(w);
            
            % Check if the mouse is in start box
            inBox = mouseX > startBox(1) & mouseX < startBox(3) & mouseY > startBox(2) & mouseY < startBox(4);
            
            
            
            % If they are in the box, show prompt.
            while inBox
                  [mouseX,mouseY,buttons] = GetMouse(w);
                Screen('DrawDots', w, [mouseX;mouseY], 10,[255 0 0]);
                DrawFormattedText2('Click the start box to start the trial.','win',w,'sx','center','sy',rdkCent,'xalign','center','xlayout','center');
                Screen('FrameRect', w, [255 165 0]*.25, startBox); 
                Screen('Flip',w);
                
              
              
                % Check if the mouse is in start box
                inBox = mouseX > startBox(1) & mouseX < startBox(3) & mouseY > startBox(2) & mouseY < startBox(4);
                
                
                if buttons(1)
                    startTrial = true;
                    break
                end
            end
            
            
            
        end
        
        
    end
    
    
    
    % Display Fixation
    DrawFormattedText2('+','win',w,'sx','center','sy',rdkCent,'xalign','center','xlayout','center');
    Screen('Flip',w);
    WaitSecs(.5)
    
    
    % Create RDK objects.
    target = rdk('display',display,'nDots',50,'coherence',coherence,'direction',targetDir,'speed',3,'centre',[Xrect, rdkCent],'lifetime',.5*display.frame_rate,'itemApertureSize',3);
    leftFlank = rdk('display',display,'nDots',50,'coherence',coherence,'direction',flankerDir,'speed',3,'centre',[Xrect-300; rdkCent],'lifetime',.5*display.frame_rate,'itemApertureSize',3);
    rightFlank = rdk('display',display,'nDots',50,'coherence',coherence,'direction',flankerDir,'speed',3,'centre',[Xrect+300; rdkCent],'lifetime',.5*display.frame_rate,'itemApertureSize',3);
    
    
    [mouseX,mouseY] = GetMouse(w);
    
    % Initialise dot postitions.
    iFrame = 0;
    Screen('DrawDots', w, [target.dotX;target.dotY],2,[255 255 255],[],1);
    Screen('DrawDots', w, [leftFlank.dotX;leftFlank.dotY],2,[255 255 255],[],1);
    Screen('DrawDots', w, [rightFlank.dotX;rightFlank.dotY],2,[255 255 255],[],1);
    %Screen('FrameRect', w, [40 40 40], startBox);
    Screen('FrameRect', w, [40 40 40], leftBox);
    Screen('FrameRect', w, [40 40 40], rightBox);
    Screen('DrawDots', w, [mouseX; mouseY],5,[40 40 40]);
    
    stimulusOnset = Screen('Flip',w);
    
    
    
    while ~responseMade
        iFrame = iFrame + 1;
        [ keyIsDown, ~, keyCode ] = KbCheck;
        
        % Check for quits.
        if keyIsDown && keyCode(KbName('q'))
            sca
            error('quit')      
        end
        
        
        [mouseX(iFrame),mouseY(iFrame)] = GetMouse(w);
        
        
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
        Screen('DrawDots', w, [target.dotX;target.dotY],2,[255 255 255],[],1);
        Screen('DrawDots', w, [leftFlank.dotX;leftFlank.dotY],2,[255 255 255],[],1);
        Screen('DrawDots', w, [rightFlank.dotX;rightFlank.dotY],2,[255 255 255],[],1);
      %  Screen('FrameRect', w, [40 40 40], startBox);
        Screen('FrameRect', w, [40 40 40], leftBox);
        Screen('FrameRect', w, [40 40 40], rightBox);
        Screen('DrawDots', w, [mouseX(iFrame);mouseY(iFrame)], 10,[255 0 0]);
        
        Screen('Flip',w);
        
        
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
    
    % Save RT and stylus path.
    trialMat.RT(iTrial) = timeOfResponse-stimulusOnset;
    mousePath.X = mouseX;
    mousePath.Y = mouseY;
    
    
    
    % Show feedback in practice trials.
    if trialMat.Practice(iTrial) == 1
        DrawFormattedText2(showFeedback(trialMat.Acc(iTrial)),'win',w,'sx','center','sy','center','xalign','center');
        Screen('Flip',w);
        WaitSecs(.5);
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
        
        DrawFormattedText2('Time for a break!\n\nThis break lasts 60 seconds and cannot be skipped!','win',w,'sx','center','sy','center','xalign','center','xlayout','center');
        Screen('Flip',w);
        WaitSecs(60);
        
        DrawFormattedText2('Ready to continue?\n\n <b><color=00ffff><b> Press any key to start!<b>','win',w,'sx','center','sy','center','xalign','center','xlayout','center');
        Screen('Flip',w);
        KbStrokeWait;
        
    end





    function out = showFeedback(acc)
        if acc == 0
            out = '<b><color=FF0000>Incorrect!';
        else
            out = '<b><color=00FF00>Correct!';
        end
    end
end