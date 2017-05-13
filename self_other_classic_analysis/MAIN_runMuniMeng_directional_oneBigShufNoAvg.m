function MAIN_runMuniMeng_directional_oneBigShufNoAvg()
% [filesFoundInDir, dirName ]  = loadDirForRack();
% mkdir(fullfile(pwd,dirName));
start = tic;
%% set params:
params = getParams();
numShuffels = 1e3;
slSize = 27;
runRFX = 1;
cvFold = 21;
%%
%% load data
rootDirOriginalData = ...
    'F:\vocalDataSet\processedData\matFilesProcessedData\stats_normalized_sep_beta';
load(fullfile(rootDirOriginalData,'allSubsBetas.mat'),...
    'mask','locations','allSubsData','labels');
%% select data
[data,subsExtracted,numSubs] = extractSubjectsFromDataRosenFFX(allSubsData,cvFold);
data = double(data);
%%
%% set fn to save 
fnTosave = sprintf('Directional____FFX_vocalDataset_%d-subs_%d-slsize_%d-cvFold_%d-shuf',...
    numSubs,slSize,cvFold,numShuffels);
%% 

idx = knnsearch(locations, locations, 'K', params.regionSize);
% pool = startPool(params);
for i = 1:numShuffels
%     deltaData = getDeltaDataOneBigMatrixNoAverageTrials(data,labels,i);
    deltaDataAbs = getDeltaDataOneBigMatrixNoAverageTrialsAbsVals(data,labels,i);
    for (j=1:size(idx,1)) % loop on all voxels in the brain % XXX
        % for j=1:size(idx,1)
        delta = deltaData(:,idx(j,:));
        [ansMat(j,i,:) ] = calcTstatAll(params,delta);
    end
    timeVec(i) = toc(start); reportProgress(fnTosave,i,params, slSize, timeVec)
end

save([fnTosave '_' datestr(clock,30) '.mat'],...
    'ansMat','mask','locations','params','subsExtracted','fnTosave','-v7.3');

end