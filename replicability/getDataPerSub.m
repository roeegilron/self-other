function [dataout,labelsout, runout] = getDataPerSub(subnum,roinum,settings,params)
data = []; labels = []; dataagre = []; labelsagr = [];  runagr = []; 
load(settings.roifilename)
roimask3d = labelsdata == roinum; %  get roi
for r = 1:length(params.runsuse)
    for c = params.conduse
        fnmload = sprintf(settings.subformat,subnum,r,c,params.suffices{c});
        fullfnm = fullfile(settings.dataloc_group_prev_ruti,fnmload);
        if exist(fullfnm,'file')
            load(fullfnm);
            roiflat = reverseScoringToMatrix1rowAnsMat(roimask3d,locations);
            dataagre  = [dataagre , data(roiflat,:)]; % voxels x trials
            labelsagr = [labelsagr, ones(1,size(data,2))*c];
            runagr    = [runagr,  ones(1,size(data,2))*r];
        end
    end
end
% transpose data
dataout = dataagre'; % trials x voxles 
labelsout = zeros(size(labelsagr'));
labelsout(labelsagr' >3) = 1; % self 
labelsout(labelsagr' <=3) = 2; % other
runout = runagr'; % run uses 

%% check data for zeros, excise them 
if ~isempty(find(sum(dataout,1)==0))
    idxzeros = find(sum(dataout,1)==0);
    allidxs  = 1:size(dataout,2);
    dataout = dataout(:,setxor(allidxs,idxzeros));
    msgwrning = sprintf('sub %d had %d voxels with zeros out of %d taken out\n',...
        subnum,length(idxzeros),length(allidxs));
    warning(msgwrning);
end
if sum(sum(isnan(dataout)))
    error('you have nans in you data');
end
if isempty(data) 
    error('could not find subject data'); 
end
    
end