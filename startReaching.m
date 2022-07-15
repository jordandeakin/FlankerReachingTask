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
elseif spatialArrangement == 2
startBox = [w.Xrect-50, w.Yrect+400, w.Xrect+50, w.Yrect+500];
leftBox = [w.Xrect-700, w.Yrect-450, w.Xrect-600, w.Yrect-350];
rightBox = [w.Xrect+600, w.Yrect-450, w.Xrect+700, w.Yrect-350];
rdkCent = w.Yrect - 400;
end
    

%% Instructions
ReachingInstructions(w,leftBox,rightBox);

data.trialSequence = [];
trialsPerCondition = 32;

% Runs four blocks.
for iBlock = 1:4
    
    if iBlock == 1
        DrawFormattedText(w.ptr,'We will first do some practice trials.\n\n','center','center',[255 255 255],100,[],[],2);
        DrawFormattedText(w.ptr,'Press any key to start!','center',w.Yrect+300,[0 255 255],100,[],[],2);%'baseColor',[255 255 255]);
        Screen('Flip',w.ptr);
        KbStrokeWait;
    else
        DrawFormattedText(w.ptr,'We will do some more practice trials.\n\n','center','center',[255 255 255],100,[],[],2);%'baseColor',[255 255 255]);
         DrawFormattedText(w.ptr,'Press any key to start!','center',w.Yrect+300,[0 255 255],100,[],[],2);%'baseColor',[255 255 255]);
        Screen('Flip',w.ptr);
        KbStrokeWait;
    end
    
    %% Practice Trials
    % The practice trials consist of one practice trial for each
    % combination of the factors.
    practiceMatrix = createFlankerTrials(coherence,1,trialsPerCondition/4);
   % practiceMatrix = practiceMatrix(1:2,:);
       practiceMatrix = runReachingTrials(w,display,practiceMatrix,startBox,leftBox,rightBox,rdkCent);
    
       DrawFormattedText(w.ptr,'That is the end of the practice trials.\n\n','center','center',[255 255 255],100,[],[],2)
    DrawFormattedText(w.ptr,'Press any key to start!','center',w.Yrect+300,[0 255 255],100,[],[],2);%'baseColor',[255 255 255]);
       
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

