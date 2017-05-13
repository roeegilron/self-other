function MAIN_runMukamelStyle_Nondirectional()
%% Mukamel Style Nondirectional norms 
% Step 1: Calculate ‘Real’ Norm as follows:
%%
% # For each subject, randomly pair AB trials and compute their delta
% # Calculate the norm of each such delta vector (from here stems the non-directionality of the test)
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
fnTosave = sprintf('Directional____FFX_vocalDataset_%d-subs_%d-slsize_%d-cvFold_%d-shuf',...
    numSubs,slSize,cvFold,numShuffels);
%% 

% Compute mukamel style delta 
idx = knnsearch(locations, locations, 'K', params.regionSize);
% pool = startPool(params);
start = tic;
for i = 1:numShuffels % loop on shuffels 
    % Shuffle data to get one big matrix 
    deltaMatrix = getDeltaDataOneBigMatrixNoAverageTrials(data,labels,i);
    %%
    for (j=1:size(idx,1)) % loop on all voxels in the brain 
        delta = deltaMatrix(:,idx(j,:)); % get delta from sphere 
        % compute mukamel norms 
        [ansMat(j,i,1) ] = mean( sum( sqrt( (delta.^2) ) , 2) );
    end
end

save([fnTosave '_' datestr(clock,30) '.mat'],...
    'ansMat','mask','locations','params','subsExtracted','fnTosave','-v7.3');

end

%% Create the Shuffle Permutations 
function deltaData = getDeltaDataOneBigMatrixNoAverageTrials(data,labels,i)
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
    deltaData = [deltaData ; deltaDataOneSub]; % get one big delta matrix
end
end



