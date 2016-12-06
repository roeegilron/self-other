function perc = estimate_Prevelane(data)
global DATA
DATA = data;
p = 0.5; sigma1 = 1; sigma2 = 1; mu = 1;
initvals(1) = log(p/(1-p));
initvals(2) = exp(sigma1);
initvals(3) = exp(sigma2);
initvals(4) = mu;
x = fminsearch(@liklihoodfunc2,initvals);
xout = 1 /(1+exp((-1)*x(1)));
fprintf('area %s is %f \n',name,xout);
perc = xout; 

end


function outre =  computeF(x,t,p,sigma1,sigma2,mu)
a = sigma2/sqrt(t); 
b = sqrt(sigma1^2 + sigma2^2/t);
outre = (1-p) * normpdf(x,0,a) + p * normpdf(x,mu,b); 
end

function lres = liklihoodfunc(p,sigma1,sigma2,mu)
global DATA 
for i = 1: size(DATA,1)
    res(i) =  computeF(DATA(i,1),DATA(i,2),p,sigma1,sigma2,mu);
end
lres =  sum(log(res));
end

function result = liklihoodfunc2(initvals)
pstar      = initvals(1);
sigma1star = initvals(2);
sigma2star = initvals(3);
mu         = initvals(4);

p      = 1 /(1+exp((-1)*pstar));
sigma1 = log(sigma1star); 
sigma2 = log(sigma2star); 
result = liklihoodfunc(p,sigma1,sigma2,mu)*(-1); % bcs maximizing 
end

function f1(x,t,p,sigma1,sigma2,mu)
end
