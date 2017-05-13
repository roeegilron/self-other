function calcReplicabilityPrevelanceWithinSL()
p = genpath('D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX');
addpath(p);
close all
dataFolder = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\ffxNotZscoredVocalDataSet_1000_shufs\';
dataFolder  = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\ffxNotZscored_VocalData_Set1000_Shufs_9slsize_not_smoothed';
vmpname = 'ffxNotZscored_VocalData_Set1000_Shufs_9slsize_not_smoothed';
% load(fullfile(dataFolder,'prevData.mat'),'prevData');
load(fullfile(dataFolder,'prevData_9slsize_unsmoothed.mat'),'prevData');

resultsFolder = dataFolder;%'D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX\matlabCode\atlasLabels';
rng(1);
randSubs = randperm(150,20);
allPvals = [prevData.pvals];

%% choose the min p value within each sphere within each subject 
ff = findFilesBVQX(dataFolder,'*.mat');
mfo = matfile(ff{3});
locations = mfo.locations;
idx = knnsearch(locations, locations, 'K', 27);
pvalsMinWithinSL = zeros(size(allPvals));
for i = 1:size(allPvals,2) % loop on subjects 
    for j = 1:size(allPvals,1) % loop on voxels 
        idxssl = idx(j,:);
        pvalsMinWithinSL(j,i) = min(allPvals(idxssl,i));
    end
end
%%
n = size(pvalsMinWithinSL,2); 
u = floor(0.125 *n);
df = 2 * (n-u+1);

% sum of pvals. 
Ps = [];
for i = 1:size(pvalsMinWithinSL,1)
    pvals = pvalsMinWithinSL(i,:);
    sortpvals = sort(pvals);
    upvals = sortpvals(u:end);
    upvalslog = log(upvals) * (-2);
    sumus = sum(upvalslog);
    Ps(i) = chi2cdf(sumus,df,'upper');
end
% for i = 1:size(allPvals,2); 
%     [pvalsecond(i), ~] = chi2gof(
% end

%% plot vmp of sig. voxels: 
sigfdr = fdr_bh(Ps,0.05,'pdep','yes'); 
ff = findFilesBVQX(dataFolder,'*.mat');
mfo = matfile(ff{2});
mask = mfo.mask;
locations = mfo.locations;
ansMat = double(sigfdr)';
dataFromAnsMatBackIn3d = scoringToMatrix(mask,ansMat,locations);
dumynii = 'D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX\matlabCode\atlasLabels\HarvardOxford-cort-maxprob-thr0-1mm.nii';
n = neuroelf;
vmpout = n.importvmpfromspms(dumynii,'a',[],3);
vmpout.Map.VMPData = dataFromAnsMatBackIn3d;
vmpout.Map.Name = [vmpname ];
