function [normMap] = calcNormsOfLeftOutSubjects(allSubsData,leftOutSubjects,locations,labels,slsize)
% calc norms maps for left out subjects either using RFX or MVPA
% benchmarks. 
% the idea is that you average all subject betas (RFX benchmark)
% or that you average all subject norms first. 
params.regionSize = slsize;
% prune data set to only include left out subjects 
allDataLeftOut = allSubsData(:,:,leftOutSubjects);
%% get RFX median- within each sphere average the delta betas across subjects 
%% get MVPA median - average the norms for each subjects - then take median

% get idxs of the spheres acorss the brain 
idx = knnsearch(locations, locations, 'K', params.regionSize);

% loop on spheres ( voxels) 
for i = 1:size(allDataLeftOut,2) 
    % get idx of current sphere (27 idxs)
    curSphrIdxs = idx(i,:); 
    % extract current sphere from left out subjects (40 x 27 x subs)
    curSphere = allDataLeftOut(:,curSphrIdxs,:); 
    % get delta of sphere (20 x 27 x subs)
    curSphereDelt = curSphere(labels==1,:,:)-curSphere(labels==2,:,:);
    
    %% RFX style benchmark 
    % take median sphere value across subjects (20x27)
    meanBetasWithinSPhere = mean(curSphereDelt,3); %XXX switch to mean
    % calculate the mean value of all trials (1 x 27)
    meanBetasWithinSphereMean = mean(meanBetasWithinSPhere,1);
    % sqr this differncet (1 x 27)
    sqrDiffMat = meanBetasWithinSphereMean.^2;
    % take the sum and then sqrt (1 x 1)
    normMap.normofmeans(i) = sqrt(sum(sqrDiffMat));
    
    %% MVPA style benchmark 
    % calculate the mean delta for each subject (20 x 27 x subs)
    meanDeltaPerSub = mean(curSphereDelt,1);
    % sqr the difference matrix for each subject (1 x 27 x subs)
    sqrDiffMatPerSub = meanDeltaPerSub.^2;
    % take the sum and then sqrt per subject (1 x subs);
    normPerSub = squeeze(sum(sqrDiffMatPerSub,2));
    % take the median value across subjects:
    normMap.meanofnorms(i) = mean(normPerSub); % xxx switched to mean
    
    %% clumping benchmark 
%     normMap.clump(i) = calcClumpingIndex(meanDeltaPerSub);
    
    %% wilcoxin sign rank - adapte to multivariate 
%     normMap.wilcox(i) = calcClumpingIndexWilcox(meanDeltaPerSub);
    %% FA  - svd - adapte to multivariate 
    normMap.fa(i) = calcClumpingIndexSVD(meanDeltaPerSub);
end
% figure;
% subplot(1,2,1);
% hold on;
% zscredMVPA = zscore(normMap.MVPA);
% zscredRFX = zscore(normMap.RFX);
% idxsRFXbig = find(zscredRFX>zscredMVPA);
% restIdxs = setxor(1:length(normMap.MVPA),idxsRFXbig);
% orderIdxs = [idxsRFXbig restIdxs];
% [sortedNorm,idxs] = sort(zscredRFX);
% plot(1:length(normMap.MVPA),zscredMVPA(orderIdxs),'LineWidth',2)
% plot(1:length(normMap.MVPA),zscredRFX(orderIdxs),'LineWidth',2)
% legend({'MVPA norms','RFX norms'});
% ylabel('z scored norms per sphere'); 
% xlabel('spheres'); 
% title('comparison of RFX and MVPA norms across voxels');
% subplot(1,2,2);
% hold on;
% title('histogram of RFX and MVPA norms');
% histogram(zscredMVPA);
% histogram(zscredRFX);
% legend({'MVPA norms','RFX norms'});
% ylabel('count of z scored norms per sphere'); 
% xlabel('z scored norm value'); 



end