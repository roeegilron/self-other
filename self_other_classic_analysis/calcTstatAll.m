function [Tstat] = calcTstatAll(params,delta)
testOrder = {'MuniMeng','Dempster','Ht2'}; % just a reminder
% the acutal value is set in getParams
% compute some base values
traceR2 = @(x) trace(x'*x);
getDiag = @(x) (1./x) .*(eye(size(x)));
getDiagSqrt = @(x) (eye(size(x))).* repmat(1./sqrt(diag(x)),[1,size(x,1)]);
covDelta = cov(delta);
%
% corrDelta = corr(delta);.,
% alternate faster computation of corrDelta
covvDeltaSqrt = getDiagSqrt(covDelta);
corrDelta = covvDeltaSqrt * covDelta *  covvDeltaSqrt;
meanDelta = mean(delta);
traceR2ofCorrDelta = traceR2(corrDelta);
N = size(delta,1);
n = N-1;
p = size(delta,2);
%% calculate stat Muni meng:
numerator = N * meanDelta * getDiag(covDelta) * meanDelta' - (n*p/(n-2));
denminatr = 2*(traceR2ofCorrDelta - (p^2/n));
cPn = 1 +  ( traceR2ofCorrDelta/ (p^(3/2)) );
Tstat(1,1) = numerator / sqrt(denminatr * cPn); % M&M
Tstat(1,2) = numerator ; 
Tstat(1,3) = sqrt(denminatr * cPn);
% calculate paramatric t value
%     2*normcdf(ansMatHotT2_v1(j) ,0,1,'upper');
%% calc stat dempster
Tstat(1,4) = N * meanDelta * meanDelta' / trace(covDelta);

%% calc stat HT2
if (p < N) % don't calculate hotteling if you have inversion problem
    Tstat(1,5) = N * meanDelta * inv(covDelta) * meanDelta';
    Tstat(1,6) = log(det(covDelta));
end

%% calc norm 
Tstat(1,7) = meanDelta * meanDelta';

%% calc norm 2 
% Tstat(1,8) = sqrt(delta * delta');

end