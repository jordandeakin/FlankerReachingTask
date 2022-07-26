function out = createSingleTrials(coherence,practice,trials_per_cell)

trialMat = fullfact([length(coherence) 2]); % [2 = left and right length(coherence) = coherence]
trialMat = [trialMat(:,1) ones(length(trialMat),1) trialMat(:,2)];
trialMat = trialMat(randperm(size(trialMat, 1)), :);
% Enter Coherence Values

for i = 1:length(coherence)
    idx = trialMat(:,1) == i;
    trialMat(idx,1) = coherence(i);
end




trialMat = array2table(trialMat);
trialMat.Properties.VariableNames = ["Coherence","Practice","TargetDir"];
Trial = [1:height(trialMat)]';
trialMat = addvars(trialMat,Trial,'Before','Coherence');
trialMat.TargetDir(trialMat.TargetDir == 1) = -67.5;
trialMat.TargetDir(trialMat.TargetDir == 2) = 67.5;

if practice == 1
    out = trialMat;
else
    trialMat = repmat(trialMat,round(trials_per_cell/2),1);
    trialMat.Practice = zeros(size(trialMat,1),1);
    trialMat = trialMat(randperm(size(trialMat, 1)), :);
    trialMat.Trial = [1:height(trialMat)]';
out = trialMat;
end
end
