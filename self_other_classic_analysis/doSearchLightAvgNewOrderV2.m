% This function gets the labels of two letter and locations of all the voxels and
% performs a searchlight algorithm.

function [ansMatAverage, idx] = doSearchLightAvgNewOrderV2(data, labels, positions, params,subName)
% this version takes in data and labels
if params.useparallelcomputing
    pool = parpool('local'); % for linux 2014a
end
%matlabpool open;%for pc
factor = params.snrFactor;
numOfTrials = params.leaveOutRepetitions; % this is permutation
regionSize = params.searchLightSize; % searchlight beam size

dataA = data(labels==1,:);
dataG = data(labels==2,:);

idx = knnsearch(positions, positions, 'K', regionSize);
ansMat = zeros(size(idx,1),numOfTrials); % changes ansMat change bcs of change in for loop structure

% preogres bar stuff
% progress.text = sprintf( ['Completed: %%3.0f%%%%%%s of sub ' subName ]);
% progress.clear = sprintf( '%s', ...
%     sprintf('\b')*ones(1,length(sprintf(progress.text,0,''))) );

for i=1:numOfTrials % loop on permutatins (e.g. how many times perform SVM routine
    % do SNR averaging
    [dataSNRd,labelsSNRd] = performSNRaveraging_v2(data,labels,factor); % 0.13 sec 
    % leave one out - create test train sets
    [train,trainlabels, test, testlabels] = getTrainTestSet_v2(dataSNRd, labelsSNRd,0); % 0.03 sec (shufle = 1) shuffle test labels (shuffle = 0 don't shufle)
    % intialize varialbes 
    dataToTrain = zeros(length(trainlabels),regionSize);
    dataToTest  = zeros(length(testlabels),regionSize);
    %     parfor_progress(round(size(idx,1)/100));
    if params.useparallelcomputing
        parfor j=1:size(idx,1) % loop on all voxels in the brain
            dataToTrain = train(:,idx(j,:));
            dataToTest  = test(:,idx(j,:));
            model = svmtrainwrapper(trainlabels, dataToTrain);
            [predicted_label, accuracy, third] = svmpredictwrapper(testlabels, dataToTest, model);
            ansMat(j,i) = accuracy(1);
            %         if mod(j, 100) == 0
            %             parfor_progress;
            %         end
        end
    else
        for j=1:size(idx,1) % loop on all voxels in the brain
            dataToTrain = train(:,idx(j,:));
            dataToTest  = test(:,idx(j,:));
            model = svmtrainwrapper(trainlabels, dataToTrain);
            [predicted_label, accuracy, third] = svmpredictwrapper(testlabels, dataToTest, model);
            ansMat(j,i) = accuracy(1);
        end
    end
%     fprintf( progress.text, i/numOfTrials*100, progress.clear );
    
    %waitbar(i/numOfTrials,hW,...
    %         sprintf('%2.2f%% done',(i/numOfTrials)*100));
    
    %    parfor_progress(0);
    %     fprintf('permutation %d completed\n',i)
end
% fprintf( progress.text,  i/numOfTrials*100, sprintf('\n') );

%% average results across all perumutations

ansMatAverage(:,2) = ((mean(ansMat,2))/100); % convert to percent from 0-1
ansMatAverage(:,1) = 1:size(idx,1);
%matlabpool close; % for pc
if params.useparallelcomputing
    delete(pool)
end

end