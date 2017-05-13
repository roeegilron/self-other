function Tstat = calcTdempster(delta)
covDelta = cov(delta);
meanDelta = mean(delta);
N = size(delta,1);
% calcualte stat Du1958
Tstat = N * meanDelta * meanDelta' / trace(covDelta);

end