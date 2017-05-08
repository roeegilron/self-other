
function [perc, sig1, sig4, mu] = estimate_Prevelane2(data)
% 4 centered componnets
global DATA
DATA = data;
p2 = 0.2; p3=0.2; p4=0.2; sigma1 = 1; sigma2 = 1; sigma3 = 1; sigma4=1; mu = 1;
initvals(1) = log(p2/(1-p2));
initvals(2) = log(p3/(1-p3));
initvals(3) = log(p4/(1-p4));
initvals(4) = log(sigma1);
initvals(5) = log(sigma2);
initvals(6) = log(sigma3);
initvals(7) = log(sigma4);
initvals(8) = mu;
% options = optimset('Display','final','PlotFcns',@optimplotfval); % to plot
% options = optimset('Display','final'); % to plot
% [x] = fminsearch(@liklihoodfunc2,initvals,options);
[x] = fminsearch(@liklihoodfunc2,initvals);
p2out = 1 /(1+exp((-1)*x(1)));
p3out = 1 /(1+exp((-1)*x(2)));
p4out = 1 /(1+exp((-1)*x(3)));
sig1  = exp(x(4));
sig2  = exp(x(5));
sig3  = exp(x(6));
sig4  = exp(x(7));
mu    = exp(x(8));

% return percent subjects with effect
perc = 1 - p2out - p3out- p4out;
end



function[outre] =  computeF(x,t,p2,p3,p4,sigma1,sigma2,sigma3,sigma4,mu)
%% create another version,
if p2 + p3 + p4 > 1
    outre = -inf;
    return;
end
a2 = sigma2/sqrt(t);
a3 = sigma3/sqrt(t);
a4 = sigma4/sqrt(t);
b = sqrt(sigma1^2 + sigma2^2/t+ sigma3^2/t + sigma4^2/t);
outre = p2 * normpdf(x,0,a2) + p3 * normpdf(x,0,a3) + p4 * normpdf(x,0,a4) + (1-p2-p3-p4) * normpdf(x,mu,b);

end



function [lres] = liklihoodfunc(p2,p3,p4,sigma1,sigma2,sigma3,sigma4,mu)
global DATA
for i = 1: size(DATA,1)
    [res(i) ]=  computeF(DATA(i,1),DATA(i,2),p2,p3,p4,sigma1,sigma2,sigma3,sigma4,mu);
end
lres =  sum(log(res));
end




function [result] = liklihoodfunc2(initvals)
p2star      = initvals(1);
p3star      = initvals(2);
p4star      = initvals(3);
sigma1star  = initvals(4);
sigma2star  = initvals(5);
sigma3star  = initvals(6);
sigma4star  = initvals(7);
mu          = initvals(8);

p2      = 1 /(1+exp((-1)*p2star));
p3      = 1 /(1+exp((-1)*p3star));
p4      = 1 /(1+exp((-1)*p4star));
sigma1  = exp(sigma1star);
sigma2  = exp(sigma2star);
sigma3  = exp(sigma3star);
sigma4  = exp(sigma4star);
[result] = liklihoodfunc(p2,p3,p4,sigma1,sigma2,sigma3,sigma4,mu) * (-1); % bcs maximizing
end