function MAIN_runDirecVsNDmeansingletrials()
%% Mukamel Style Nondirectional norms 
% Step 1: Calculate ‘Real’ Norm as follows:
%%
% # For each subject, randomly pair AB trials and compute their delta
% # Take the mean of the delta vector 
% # Calculate the all kinds of valuelus using t stats calc all 
% # Calculate the mean norm across all trial pairs and subjects
%

% Step 2: Calculate distribution of ‘Null’ Norms as follows:
%%
% # For each subject, shuffle the trial labels
% # Repeat steps 1-3 from the ‘real’ above.
% # Do this (for example) 1,000 times to obtain a distribution of ‘null’ norms
%

% Load the data and set some paramaters: 
% set params:
params = getParams();
numShuffels = 1e3;
params.numShuffels = numShuffels;
slSize = 27;
runRFX = 1;
cvFold = 21;
% load data - here we load the raw data
rootDirOriginalData = ...
    'F:\vocalDataSet\processedData\matFilesProcessedData\stats_normalized_sep_beta';
load(fullfile(rootDirOriginalData,'allSubsBetas.mat'),...
    'mask','locations','allSubsData','labels');
% select data - we selects a susect of the data 
[data,subsExtracted,numSubs] = extractSubjectsFromDataRosenFFX(allSubsData,cvFold);
data = double(data);
% set fn to save 
fnTosaveD = sprintf('Directional____FFX_vocalDataset_%d-subs_%d-slsize_%d-cvFold_%d-shuf',...
    numSubs,slSize,cvFold,numShuffels);
fnTosavND = sprintf('Nondirectional_FFX_vocalDataset_%d-subs_%d-slsize_%d-cvFold_%d-shuf',...
    numSubs,slSize,cvFold,numShuffels);
%% 

% Compute mukamel style delta 
idx = knnsearch(locations, locations, 'K', params.regionSize);
% pool = startPool(params);
start = tic;
for i = 1:numShuffels % loop on shuffels 
    % Shuffle data to get one big matrix 
    [deltaMatrixD , deltaMatrixND]  = getDeltaDataSameSizeDirAndND(data,labels,i);
    %%
    for (j=1:size(idx,1)) % loop on all voxels in the brain 
        deltaD  = deltaMatrixD(:,idx(j,:)); % get delta from sphere 
        deltaND = deltaMatrixND(:,idx(j,:)); % get delta from sphere v
        % compute T stats D
        [ansMatD(j,i,:) ] = calcTstatAll(params,deltaD);
        
        % compute T stats ND
        [ansMatND(j,i,:) ] = calcTstatAll(params,deltaND);
    end
end
ansMat = ansMatD;
save([fnTosaveD '_onavg'  '.mat'],...
    'ansMat','mask','locations','params','subsExtracted','fnTosave');
clear ansMat
ansMat = ansMatND;
save([fnTosaveND '_onavg' '.mat'],...
    'ansMat','mask','locations','params','subsExtracted','fnTosave');


end

%% Create the Shuffle Permutations 
function [deltaMatrixD , deltaMatrixND]   = getDeltaDataSameSizeDirAndND(data,labels,i)
% compute the delta of the data by permuting the labels
% for each subject seperatly.
% data is of size (trials,voxels,subjects)
deltaData = [];
for k = 1:size(data,3) % loop on subjects 
    if i == 1 % don't permuse it if its the first shuffle
        shufflabels = labels;
    else
        shufflabels = labels(randperm(length(labels)));
    end
    a = data(shufflabels==1,:,k); % get a labels
    b = data(shufflabels==2,:,k); % get b labels 
    deltaDataOneSub = a-b;
    meanDelta = mean(deltaDataOneSub,1);
    deltaMatrixD(k,:) = meanDelta;
    deltaMatrixND(k,:) = abs(meanDelta);
end
end



