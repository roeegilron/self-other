function params = getParams()
params.factor = 1;
params.regionSize = 27; % searchlight beam size

params.shuffleData = 1; 
params.numShuffels = 1000; 

params.useParallel = 0;
params.NumWorkers = 20; % make sure this is zero if not using parfor  

% choose t stat to use, option are: 
% 'muniMeng' , 'Dempster' Ht2
params.TestOrder = {'MuniMeng'};%,'Dempster'}; % test order in ansMat matrix 
% in calcTStatAll funcition 
params.NumTests = 1; % number of tstat test to run at once
end
