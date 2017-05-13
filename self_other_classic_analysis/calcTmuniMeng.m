function Tstat = calcTmuniMeng(delta)
covDelta = cov(delta);
corrDelta = corr(delta);
meanDelta = mean(delta);
N = size(delta,1);
n = N-1;
p = size(delta,2);
traceR2 = @(x) trace(x'*x);
getDiag = @(x) (1./x) .*(eye(size(x)));
%calculate stat Muni meng:
numerator = N * meanDelta * getDiag(covDelta) * meanDelta' - (n*p/(n-2));
denminatr = 2*(traceR2(corrDelta) - (p^2/n));
cPn = 1 +  ( traceR2(corrDelta)/ (p^(3/2)) );
Tstat = numerator / sqrt(denminatr * cPn);
Tstat = gather(Tstat);
% calculate paramatric t value
%     2*normcdf(ansMatHotT2_v1(j) ,0,1,'upper');
end