% This function gets the labels of two letter and locations of all the voxels and
% performs a searchlight algorithm.

function [ansMatAverage, idx] = doSearchLightCrossValFolds()
addPathsForServer()
load flattenedData.mat;
data = [];
data = flattenedData;
positions = locations;
useParallel = 1;
if useParallel
    pool = parpool('local'); % for linux 2014a
end

factor = 6;
regionSize = 125; % searchlight beam size
numOfTrials = 50;

idx = knnsearch(positions, positions, 'K', regionSize);
ansMat =[];

for i=1:numOfTrials % loop on permutatins (e.g. how many times perform the CV routine
    % get train test sets:
    % test:
    folds = getFolds(labels,subjects);
    ansMatCVfolds = zeros(size(idx,1),factor); % changes ansMat change bcs of change in for loop structure
    for z = 1:factor
        testIdx = folds(:,z); % the first random fold will always be test
        test = data(testIdx,:);
        testlabels = labels(testIdx);
        %train
        trainIdx = setxor(testIdx,folds(:));
        train = data(trainIdx,:);
        trainlabels = labels(trainIdx);
        
        % intialize varialbes
        dataToTrain = zeros(length(trainlabels),regionSize);
        dataToTest  = zeros(length(testlabels),regionSize);
        doParallel = 0;
        if useParallel
            parfor j=1:size(idx,1) % loop on all voxels in the brain
                dataToTrain = train(:,idx(j,:));
                dataToTest  = test(:,idx(j,:));
                model = svmtrainwrapper(trainlabels, dataToTrain);
                [predicted_label, accuracy, third] = svmpredictwrapper(testlabels, dataToTest, model);
                ansMatCVfolds(j, z  ) = accuracy(1);
            end
        else
            hWait = waitbar(0,sprintf('doing fold %d',i));
            for j=1:size(idx,1) % loop on all voxels in the brain
                dataToTrain = train(:,idx(j,:));
                dataToTest  = test(:,idx(j,:));
                model = svmtrainwrapper(trainlabels, dataToTrain);
                [predicted_label, accuracy, third] = svmpredictwrapper(testlabels, dataToTest, model);
                ansMatCVfolds(j, z ) = accuracy(1);
                waitbar(j/size(idx,1),hWait, sprintf('pos %d out of %d',j,size(idx,1)));
            end
        end
    end % end CV step throug 
    ansMat = [ansMat ansMatCVfolds];
    fprintf('finished run %d out of %d runs. time is %s\n',...
        i,numOfTrials,datestr(clock))
end

%% average results across all perumutations

ansMatAverage(:,2) = ((mean(ansMat,2))/100); % convert to percent from 0-1
ansMatAverage(:,1) = 1:size(idx,1);

save('resultsSVM_linear_recreatefoldsDoAllCVfolds.mat');
if useParallel
    delete(pool)
end

end