function simulateDataPrevelance()
%% params for data simulation 
params.numsubs       =  23; % number of subjects 
params.percentresp   =  0.15; % percent subs responding 
params.sigma1        =  1; %  real sigma 
params.mu1           =  1.5; % real mu (responding subs)
params.sigma2        =  1.5; % non responding  
params.mu2           =  0; % non responding 
params.numtrial      =  80; % number of trials 
params.numtrial_prog =  5:5:params.numtrial; % trials sampeled  


%% create simulated data 
simdata = []; 
for t = 1:length(params.numtrial_prog)
    numt = params.numtrial_prog(t); 
    nums_wisignal = floor(params.percentresp * params.numsubs); 
    nums_wosignal = params.numsubs - nums_wisignal; 
    % create sim data: 
    sig1cor = sqrt(params.sigma1^2 + params.sigma2^2/t); 
    data_ws = normrnd(params.mu1, sig1cor,nums_wisignal,1);
    data_ns = normrnd(params.mu2, params.sigma2/sqrt(t),nums_wosignal,1);
    dataconcat = [data_ws ; data_ns]; 
    numtrials  = ones(params.numsubs,1).* numt; 
    simdata = [simdata ; [dataconcat , numtrials]]; 
end
perc = estimate_Prevelane(simdata); 

fprintf('real prevelance is %f estimated prevelance is %f\n',...
    params.percentresp, perc); 
end