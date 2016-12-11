function simulateDataPrevelance()
%% params for data simulation 
params.numsubs       =  40; % number of subjects 
params.percentresp   =  0.8; % percent subs responding 
params.sigma1        =  0.5; %  real sigma 
params.mu1           =  2; % real mu (responding subs)
params.sigma2        =  0.5; % non responding  
params.mu2           =  0; % non responding 
params.numtrial      =  80; % number of trials 
params.numtrial_prog =  5:5:params.numtrial; % trials sampeled  
params.sigma1_prog   =  linspace(1,0.5,length(5:5:params.numtrial)); % sigam prog (getting smaller) 
params.sigma2_prog   =  linspace(1,0.5,length(5:5:params.numtrial)); 

%% create simulated data 
simdata = []; 
for t = 1:length(params.numtrial_prog)
    numt = params.numtrial_prog(t); 
    nums_wisignal = floor(params.percentresp * params.numsubs); 
    nums_wosignal = params.numsubs - nums_wisignal; 
    % create sim data: 
    data_ws = normrnd(params.mu1, params.sigma1_prog(t),nums_wisignal,1);
    data_ns = normrnd(params.mu2, params.sigma1_prog(t),nums_wosignal,1);
    dataconcat = [data_ws ; data_ns]; 
    numtrials  = ones(params.numsubs,1).* numt; 
    simdata = [simdata ; [dataconcat , numtrials]]; 
end
perc = estimate_Prevelane(simdata); 

fprintf('real prevelance is %f estimated prevelance is %f\n',...
    params.percentresp, perc); 
end