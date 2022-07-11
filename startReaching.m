function startReaching(spatialArrangement)
KbName('UnifyKeyNames');

[data, w, filename, display] = initialiseReaching();

% Set Coherence Levels
coherence = [20, 30, 60, 90];


%% Choice of Arrangements
% 1: RDKs are displayed in the centre and responses boxes are either side
% of array.
% 2: RDKs are displayed at the top of the screen with responses boxes
% underneath.
if spatialArrangement == 1
startBox = [w.Xrect-50, w.Yrect+400, w.Xrect+50, w.Yrect+500];
leftBox = [w.Xrect-700, w.Yrect-50, w.Xrect-600, w.Yrect+50];
rightBox = [w.Xrect+600, w.Yrect-50, w.Xrect+700, w.Yrect+50];
rdkCent = w.Yrect;
else
startBox = [w.Xrect-50, w.Yrect+400, w.Xrect+50, w.Yrect+500];
leftBox = [w.Xrect-700, w.Yrect-200, w.Xrect-600, w.Yrect-100];
rightBox = [w.Xrect+600, w.Yrect-200, w.Xrect+700, w.Yrect-100];
rdkCent = w.Yrect - 400;
end
    

%% Instructions
ReachingInstructions(w,leftBox,rightBox);

data.trialSequence = [];
trialsPerCondition = 8;

% Runs four blocks.
for iBlock = 1:4
    
    if iBlock == 1
        DrawFormattedText2('We will first do some practice trials.\n\n <b><color=00ffff>Press any key to start!<b><color>','win',w.ptr,'sx','center','sy','center','xalign','center','yalign','center','xlayout','center');%'baseColor',[255 255 255]);
        Screen('Flip',w.ptr);
        KbStrokeWait;
    else
        DrawFormattedText2('We will do some more practice trials.\n\n <b><color=00ffff>Press any key to start!<b><color>','win',w.ptr,'sx','center','sy','center','xalign','center','yalign','center','xlayout','center');%'baseColor',[255 255 255]);
        Screen('Flip',w.ptr);
        KbStrokeWait;
    end
    
    %% Practice Trials
    % The practice trials consist of one practice trial for each
    % combination of the factors.
    practiceMatrix = createFlankerTrials(coherence,1,trialsPerCondition/4);
    practiceMatrix = practiceMatrix(1:16,:);
    practiceMatrix = runReachingTrials(w,display,practiceMatrix,startBox,leftBox,rightBox,rdkCent);
    DrawFormattedText2('That is the end of the practice trials.\n\n<color=00ffff> <b>Press any key to start!<b><color>','win',w.ptr,'sx','center','sy','center','xalign','center','yalign','center','xlayout','center');%'baseColor',[255 255 255]);
    Screen('Flip',w.ptr);
    KbStrokeWait;
    
    %% Experimental Trials.
    trialMatrix = createFlankerTrials(coherence,0,trialsPerCondition/4);
    trialMatrix = runReachingTrials(w,display,trialMatrix,startBox,leftBox,rightBox,rdkCent);
    
    
    % Append the 
    data.trialSequence = [data.trialSequence; practiceMatrix; trialMatrix];
    save(sprintf('%s.mat',filename), '-struct','data')
    
    % If last block, say thank you!
    if iBlock == 4 
     endReaching(w,data.trialSequence)
    end
    
end


sca

