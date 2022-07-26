
for i = 1:height(trialSequence)
x = trialSequence.MousePathX{i}
y = trialSequence.MousePathY{i}
ox = x(1);
oy = y(1);
idxx = x ~= ox;
idxy = y ~= oy;
idx = idxx | idxy;
out(i) = find(idx == 1,1,'first');

time = trialSequence.timestamps{i};
trialSequence.ml(i) = time(out(i)) - time(1);


end