function [Tstat] = calcTstatMuniMengTwoGroup_cross_validated(x,y,x1,y1)
% compute some base values
% rows are trials, columns are voxels 
getDiag = @(x) (1./x) .*(eye(size(x)));

xmean = mean(x,1); 
ymean = mean(y,1); 
xmean1 = mean(x1,1); 
ymean1 = mean(y1,1); 
deltamean1 = xmean-ymean;
deltamean2 = xmean1-ymean1;
Nx = size(x,1);
Ny = size(y,1);
sx = cov(x);
sy = cov(y);
n = Nx + Ny - 2;
S = ((Nx-1).*sx + (Ny-1).*sy)/n;
dinv = getDiag(S);
R = sqrt(dinv) * S * sqrt(dinv);
traceR2ofCorrDelta = trace(R'*R); 

p = size(x,2);
%% calculate stat Muni meng:
%numerator =  1/(1/Nx + 1/Ny) * deltamean * dinv * deltamean' - p;
numerator =  ((Nx +Ny)/2) * deltamean1 * dinv * deltamean2' - p;
denminatr = 2*(traceR2ofCorrDelta - (p^2/n));
cPn = 1 +  ( traceR2ofCorrDelta/ (p^(3/2)) );
Tstat(1) = numerator / sqrt(denminatr * cPn);
%Tstat(2) = numerator;
%Tstat(3) = sqrt(denminatr * cPn);

end