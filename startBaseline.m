function startBaseline(spatialArrangement,blocks)
KbName('UnifyKeyNames');

% Initialises the Screen and FileName
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
    leftBox = [w.Xrect-900, w.Yrect-450, w.Xrect-750, w.Yrect-300];
    rightBox = [w.Xrect+750, w.Yrect-450, w.Xrect+900, w.Yrect-300];
    rdkCent = w.Yrect - 400;
end


%% Show Instructions
BaselineInstructions(w,leftBox,rightBox);
data.trialSequence = [];
trialsPerCondition = 32;



% Full trial sequence is 4 blocks. The sequence is saved after each block.
% In the event of crashes, experimenter can rerun this code with different
% number of blocks.
for iBlock = blocks

    if iBlock == 1
        % If it is the first block, the amount of practice trials are
        % doubled.
         practiceMatrix = [createSingleTrials(coherence,1,trialsPerCondition/2); createSingleTrials(coherence,1,trialsPerCondition/2)]; 
        DrawFormattedText(w.ptr,'We will first do some practice trials.\n\n','center','center',[255 255 255],100,[],[],2);
        DrawFormattedText(w.ptr,'Press any key to start!','center',w.Yrect+300,[0 255 255],100,[],[],2);%'baseColor',[255 255 255]);
        Screen('Flip',w.ptr);
        KbStrokeWait;
    else
         practiceMatrix = createSingleTrials(coherence,1,trialsPerCondition/4);
        DrawFormattedText(w.ptr,'We will do some more practice trials.\n\n','center','center',[255 255 255],100,[],[],2);%'baseColor',[255 255 255]);
        DrawFormattedText(w.ptr,'Press any key to start!','center',w.Yrect+300,[0 255 255],100,[],[],2);%'baseColor',[255 255 255]);
        Screen('Flip',w.ptr);
        KbStrokeWait;
    end

    %% Practice Trials
 practiceMatrix = runBaselineReachingTrials(w,display,practiceMatrix,startBox,leftBox,rightBox,rdkCent);

 % Tell participant that practice trials are over. 
    DrawFormattedText(w.ptr,'That is the end of the practice trials.\n\n','center','center',[255 255 255],100,[],[],2)
    DrawFormattedText(w.ptr,'Press any key to start!','center',w.Yrect+300,[0 255 255],100,[],[],2);
    Screen('Flip',w.ptr);
    KbStrokeWait;


    %% Experimental Trials.
 trialMatrix = createSingleTrials(coherence,0,trialsPerCondition/4);
 trialMatrix = runBaselineReachingTrials(w,display,trialMatrix,startBox,leftBox,rightBox,rdkCent);


    % Append the sequence...
    data.trialSequence = [data.trialSequence; practiceMatrix; trialMatrix];
    data.trialSequence.Block = repmat(iBlock,height(data.trialSequence),1);
    save(sprintf('Baseline_%s.mat',filename), '-struct','data')

    % If last block, say thank you!
    if iBlock == 4
        endReaching(w,data.trialSequence)
    end

end


% Close the Psychtoolbox Window.
clear
sca

