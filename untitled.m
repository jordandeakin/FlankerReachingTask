coherence = [20 30 60 90];

close all

for i = 1:height(trialSequence)

    for iCon = 1:2

for iCoh = 1:4 

    idx = trialSequence.Practice == 0 & trialSequence.Coherence == coherence(iCoh) & trialSequence.Congruency == iCon;
    RT(i,iCoh,iCon) = median(trialSequence.RT(idx));

    idx = trialSequence.Practice == 0 & trialSequence.Coherence == coherence(iCoh) & trialSequence.Congruency == iCon;
    acc(i,iCoh,iCon) =(1- mean(trialSequence.Acc(idx)))*100;

end
    end
end

plot(coherence,mean(RT(:,:,1))*1000,'g-')
hold on
plot(coherence,mean(RT(:,:,2))*1000,'r-')
yyaxis right
b = ([mean(acc(:,:,1)); mean(acc(:,:,2))]);
b = bar(coherence,b);
b(1).FaceColor = 'g';
b(2).FaceColor = 'r';
ylim([0 100])
