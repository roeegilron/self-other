close all;
clear all;
clc
load('faData.mat','faReal3D','faEPIblank');


%% run corr on raw data 
% Here I run the FA real vs FA control. 
idx = 1; x = faReal3D(:,idx); y = faEPIblank(:,idx); 
[r pval] = corr(x,y,'type','Pearson');
fprintf('nonsca\t\t r is %f pval is %f\n',r , pval);
% This is the r value I get for this correaltion: 

%% run corr on scaled data 
% Here to make sure scaling FA from 0-1 doesn't introduce spurious 
% correlations I scale the data. 
scalevec = @(x) (x - (min(x)) )/  ( max(x) - min(x));
scalevec01 = @(x) 2*(x-min(x))/ ( max(x) - min(x))-1;
funcuse = 'scalevec01';
xs = eval([funcuse '(x)']);
ys = eval([funcuse '(y)']);
[rs pvals] = corr(xs,ys,'type','Pearson');
fprintf('scaled \t\t r is %f pval is %f\n',rs , pvals);
% for some reason, this does produce a spurios correaltion and changes the
% value: 

%% plot the scaled vs real data 
% Here I plot all the real, scaled, and scatter plot data. 
figure;
subplot(2,3,1); histogram(x);title('fa real'); xlabel('fa real values'); ylabel('count'); 
subplot(2,3,2); histogram(y);title('fa control'); xlabel('fa control values'); ylabel('count'); 
subplot(2,3,4); histogram(xs);title('fa real scaled'); xlabel('fa real values scaled'); ylabel('count'); 
subplot(2,3,5); histogram(ys);title('fa cont scaled'); xlabel('fa control values scaled'); ylabel('count'); 
ttlreal = sprintf('real (r = %f)',r);
subplot(2,3,3); scatter(x,y,'.');title(ttlreal); 
xlabel('fa real'); ylabel('fa control'); 
ttlscld = sprintf('scaled (r = %f)',rs);
subplot(2,3,6); scatter(xs,ys,'.');title(ttlscld); 
xlabel('fa real scaled'); ylabel('fa control scaled'); 


%% run some controls with random numbers 
rng(1);xsim = normrnd(mean(x),std(x),3e4,1);
rng(2);ysim = normrnd(mean(y),std(y),3e4,1);
sx = eval([funcuse '(xsim)']);
sy = eval([funcuse '(ysim)']);
[rx pvalx] = corr(x,y,'type','Pearson');
[rs pvals] = corr(sx,sy,'type','Pearson');
fprintf('nonsca\t\t r is %f pval is %f\n',rx , pvalx);
fprintf('scaled \t\t r is %f pval is %f\n',rs , pvals);
figure;
subplot(2,3,1); histogram(xsim);title('sim x'); xlabel('x sim values'); ylabel('count'); 
subplot(2,3,2); histogram(ysim);title('sim y'); xlabel('y sim values'); ylabel('count'); 
subplot(2,3,4); histogram(sx);title('sim x scaled'); xlabel('x scaled values'); ylabel('count'); 
subplot(2,3,5); histogram(sy);title('sim y scaled'); xlabel('y scaled values'); ylabel('count'); 
ttlreal = sprintf('real (r = %f)',rx);
subplot(2,3,3); scatter(x,y,'.');title(ttlreal); 
xlabel('x sim'); ylabel('y sim'); 
ttlscld = sprintf('scaled (r = %f)',rs);
subplot(2,3,6); scatter(xs,ys,'.');title(ttlscld); 
xlabel('x sim scaled'); ylabel('y sim scaled'); 

