function hT2Sketch()
addPathsForServer()
load toyDataSet-HighScore.mat;
load toyDataSet-LowScore.mat;

%% SVM part
model = svmtrainwrapper(trainlabels, dataToTrain);
[predicted_label, accuracy, third] = svmpredictwrapper(testlabels, dataToTest, model);
fprintf('acc for SVM is %f\n', accuracy(1));

%% HT2 part 
% join data set:
invVal = inv(Sd);
tic
X = [dataToTest ; dataToTrain];
labels = [testlabels ; trainlabels];
idxA = find(labels == 1);
idxB = find(labels == 2);

%% load pooled covariance 
load('pooledSdCovMatrixWithOnes.mat');

mD=( mean( X(idxA,:) )  -  mean( X(idxB,:) ) );  %Mean-sample differences.
D=X(idxA,:) -X(idxB,:);  %Sample differences.
Sd=cov(D);  %Covariance matrix of sample differences.
numFeatures = size(dataToTest,2);
% T2=(numFeatures/2)*mD*inv(Sd)*mD';  %Hotelling's T-Squared statistic.
T2=(numFeatures/2)*mD*invVal*mD';  %Hotelling's T-Squared statistic.

toc
% ver 2
T2 = mD * inv(Sd* (1/size(idxA,1)+1/size(idxB,1)) ) * mD';

fprintf('Ht2 stat is %f\n',T2)

%% version with pooled Sd
    ansMatHotT2_v1(j) = mD * inv(pooledSdWithOnes* (1/size(idxA,1)+1/size(idxB,1)) ) * mD';
    numFeatures = size(D,2);
    ansMatHotT2_v2(j)=(numFeatures/2)*mD*inv(pooledSdWithOnes)*mD';


%% visualize 
feature1 = 1;
feature2 = 25;
figure;
scatter( X( idxA, feature1) , X(idxA , feature2));
hold on;
scatter( X( idxB, feature1) , X(idxB , feature2),'*');
xlabel(sprintf('feature %d',feature1));
ylabel(sprintf('feature %d',feature2));
title(sprintf('feature %d vs feature %d',feature1, feature2));

%% Calculate the average for each sphere. 200 sphere. 
%% 

end