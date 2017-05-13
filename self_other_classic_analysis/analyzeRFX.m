function analyzeRFX()
%% add paths 
addPaths()
data = getData(); % get Data 
mask = getMask(); % get mask 
locations = getLocations(mask); % get locations in mask 
flattenedData = flattenData(data , locations); % get all subjects in one flast structure 
labels = repmat(1:2,[1,size(data,4)/2])'; % get labels 
subjects(1:2:216) = 1:108;
subjects(2:2:216) = 1:108;
subjects = subjects';% get subjects 
save('flattenedData.mat')
%% do search light with SVM 
[ansMatAverage, idx] = ... 
    doSearchLightCrossValFolds(flattenedData, labels, subjects, locations)
save('ansMatAverage.mat','ansMatAverage')

%% return results
[fn,pn] = uigetfile('*.mat','choose mat file with results');
load(fullfile(pn,fn),'ansMatAverage','mask','locations')
ansMatAverage(:,2) = ansMatHotT2_v1;
ansMatAverage(:,1) = 1:length(ansMatHotT2_v1);
dataFromAnsMatBackIn3d = scoringToMatrix(mask,ansMatAverage,locations);
% dataFromAnsMatBackIn3d = scoringToMatrix(mask,ansMatHt2_v2,locations);
%% save data as VMP 
[fn,pn] = uigetfile('*.nii'); % load a dummy .nii file 
niftiData = load_nii(fullfile(pn,fn)); % this is dummy nifty data
niftiData.img = dataFromAnsMatBackIn3d;
save_nii(niftiData,'results_fourthPass_SL27_Ht2v1.nii');
n = neuroelf;
vmp = n.importvmpfromspms(fullfile(pwd,'results_fourthPass_SL27_Ht2v1.nii'),'a',[],2);
vmp.saveas