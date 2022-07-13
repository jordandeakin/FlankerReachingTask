function endReaching(w,trialSequence)

idx = trialSequence.Practice == 0;
averageAcc = mean(trialSequence.Acc(idx))*100;
averageRT = median(trialSequence.RT(idx))*1000;

text = sprintf('You''ve reached the end!\n You responded correctly on %.2f%% of trials\n.Your average response time was %.2fms.\n\n .\n\nThank you for your participation.',averageAcc,averageRT);
DrawFormattedText(w.ptr,text,'center','center',[255 255 255],100,[],[],2);%'baseColor',[255 255 255]);
DrawFormattedText(w.ptr,'Press any key to finish.','center',w.Yrect+300,[0 255 255],100,[],[],2);%'baseColor',[255 255 255]);

    Screen('Flip',w.ptr);
    KbStrokeWait; 
end