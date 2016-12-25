function [dataout,labelsout,runout,labelStr,locations,map] = loadData(subnum,settings, params) 
%% load data across all conditions and runs 
% dataout is trials x voxels 
data = []; labels = []; dataagre = []; labelsagr = [];  runagr = []; 


for r = 1:length(params.runsuse)
    for c = params.conduse
        fnmload = sprintf(settings.subformat,subnum,r,c,params.suffices{c});
        fullfnm = fullfile(settings.dataloc,fnmload);
        labelStr{c} = params.suffices{c};
        if exist(fullfnm,'file')
            load(fullfnm,'data','locations','map');
            dataagre  = [dataagre , data]; % voxels x trials
            labelsagr = [labelsagr, ones(1,size(data,2))*c];
            runagr    = [runagr,  ones(1,size(data,2))*r];
        end
    end
end
% transpose data
dataout = dataagre'; % trials x voxles 
labelsout = zeros(size(labelsagr'));
labelsout = labelsagr'; 
runout = runagr'; % run uses 

    
end