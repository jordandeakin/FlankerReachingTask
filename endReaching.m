function endReaching(w,trialSequence)

idx = trialSequence.Practice == 0;
averageAcc = mean(trialSequence.Acc(idx))*100;
averageRT = median(trialSequence.RT(idx))*1000;

text = sprintf('You''ve reached the end!\n You responded correctly on %.2f%% of trials\n.Your average response time was %.2fms.\n\n .\n\n<color=00ffff> <b>Thank you for your participation.\nPress any key to end!<b><color>',averageAcc,averageRT);

DrawFormattedText2(text,'win',w,'sx','center','sy','center','xalign','center','yalign','center','xlayout','center');%'baseColor',[255 255 255]);
    Screen('Flip',w);
    KbStrokeWait; 
end