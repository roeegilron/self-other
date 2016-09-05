function ansmat_2ndlevel = compute_stelzer_perms(ansmat,params)
% compute stelzer perms as described in: 
% Stelzer, J., et al. (2013). "Statistical inference and multiple testing correction in classification-based multi-voxel pattern analysis (MVPA): Random permutations and cluster size control." Neuroimage 65: 69-82.
% 	An ever-increasing number of functional magnetic resonance imaging (fMRI) studies are now using information-based multi-voxel pattern analysis (MVPA) techniques to decode mental states. In doing so, they achieve a significantly greater sensitivity compared to when they use univariate frameworks. However, the new brain-decoding methods have also posed new challenges for analysis and statistical inference on the group level. We discuss why the usual procedure of performing t-tests on accuracy maps across subjects in order to produce a group statistic is inappropriate. We propose a solution to this problem for local MVPA approaches, which achieves higher sensitivity than other procedures. Our method uses random permutation tests on the single-subject level, and then combines the results on the group level with a bootstrap method. To preserve the spatial dependency induced by local MVPA methods, we generate a random permutation set and keep it fixed across all locations. This enables us to later apply a cluster size control for the multiple testing problem. More specifically, we explicitly compute the distribution of cluster sizes and use this to determine the p-values for each cluster. Using a volumetric searchlight decoding procedure, we demonstrate the validity and sensitivity of our approach using both simulated and real fMRI data sets. In comparison to the standard t-test procedure implemented in SPM8, our results showed a higher sensitivity. We discuss the theoretical applicability and the practical advantages of our approach, and outline its generalization to other local MVPA methods, such as surface decoding techniques. (C) 2012 Elsevier Inc. All rights reserved.
% 

for i = 1:params.stlzrshuf % create stelzer perms for second level (sampling with replacment) 
    if i == 1 % real map 
        switch params.avgtype
            case 'mean'
                ansmat_2ndlevel(:,i) = nanmean(ansmat(:,i));
            case 'median'
                ansmat_2ndlevel(:,i) = nanmedian(ansmat(:,i));
        end      
    else
        for j = 1:size(ansmat,1) % get random map from each subject 
            idxmaps = randperm(size(ansmat,2)-1) + 1; % first map is real 
            idxuse = idxmaps(1); 
            tmp(j) = ansmat(j,idxuse);
        end
        switch params.avgtype
            case 'mean'
                ansmat_2ndlevel(:,i) = nanmean(tmp);
            case 'median'
                ansmat_2ndlevel(:,i) = nanmedian(tmp);
        end
    end
end
end