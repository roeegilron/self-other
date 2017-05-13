function splitRussData()
[ data,locations, mask, labels, fnTosave ] = loadDataForRack();
unqSubs = 1:108';
subjects =[];
for i = 1:108
        subjects = [subjects; i; i];
end

rng(2); % set seed
%% create 2 fold data set (54 subs per fold)
cvFolds = randomDivideToParts(108,5); 
%% create 6 fold data set (18 subs per fold)
% cvFolds = randomDivideToParts(108,6); 

rawData = data;
rawLabels = labels;

%% save the data
for i = 1:15%size(cvFolds,2)
    fprintf('started saving for fold %d at %s\n',i,datestr(clock,21));
    rng(i)
    cvFolds = randomDivideToParts(108,5);
    idxFoldToUse = find(sum(cvFolds(:,:))==108,1);
    idxsToExtract = []; data = []; labels = []; 
    subsForFold = unqSubs(cvFolds(:,idxFoldToUse))';
    for j = 1:length(subsForFold)
        idxsToExtract = [idxsToExtract, find(subsForFold(j) == subjects)'];
    end
    data = rawData(idxsToExtract,:);
    labels = rawLabels(idxsToExtract,:);
    fNToUse = sprintf('%s_%dSubs_cvFold%d',fnTosave,length(subsForFold),i);
    save(fullfile('replicabilityAnalysis',[fNToUse '.mat']),...
        'data','labels','mask','locations','fNToUse','subsForFold');
    fprintf('subs used for folds=');
    fprintf('%d ', subsForFold)
    fprintf('\n')
    fprintf('finished saving for fold %d at %s\n',i,datestr(clock,21));
end
clc
end