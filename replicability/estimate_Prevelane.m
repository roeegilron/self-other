function perc = estimate_Prevelane(data)
global DATA
DATA = data;
p2 = 0.3; p3=0.3; sigma1 = 1; sigma2 = 1; sigma3 = 1; mu = 1;
initvals(1) = log(p2/(1-p2));
initvals(2) = log(p3/(1-p3));
initvals(3) = exp(sigma1);
initvals(4) = exp(sigma2);
initvals(5) = exp(sigma3); 
initvals(6) = mu;

x = fminsearch(@liklihoodfunc2,initvals);
xout = 1 /(1+exp((-1)*x(1)));
perc = xout; 

end


function outre =  computeF(x,t,p2,p3,sigma1,sigma2,sigma3, mu)
a2 = sigma2/sqrt(t); 
a3 = sigma3/sqrt(t); 
b = sqrt(sigma1^2 + sigma2^2/t+ sigma3^2/t);
outre = p2 * normpdf(x,0,a2) + p3 * normpdf(x,0,a3) + (1-p2-p3) * normpdf(x,mu,b); 

end

function lres = liklihoodfunc(p2,p3,sigma1,sigma2,sigma3, mu)
global DATA 
for i = 1: size(DATA,1)
    res(i) =  computeF(DATA(i,1),DATA(i,2),p2,p3,sigma1,sigma2,sigma3, mu);
end
lres =  sum(log(res));
end

function result = liklihoodfunc2(initvals)
p2star      = initvals(1);
p3star      = initvals(2);
sigma1star = initvals(3);
sigma2star = initvals(4);
sigma3star = initvals(5);
mu         = initvals(6);

p2      = 1 /(1+exp((-1)*p2star));
p3      = 1 /(1+exp((-1)*p3star));
sigma1 = log(sigma1star); 
sigma2 = log(sigma2star); 
sigma3 = log(sigma3star); 
result = liklihoodfunc(p2,p3,sigma1,sigma2,sigma3, mu)*(-1); % bcs maximizing 
end

function f1(x,t,p2,p3,sigma1,sigma2,sigma3,mu)
end
