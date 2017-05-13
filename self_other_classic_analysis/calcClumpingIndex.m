function clumpIdx = calcClumpingIndex(meanDeltaPerSub)
% \sum_j j^j sign(c_j)
% where j is the voxels index, varying from i to 27 and c_j is the value in the j'th coordinate.
% (10,14,-12,9) would thus get 1+4-9+19=15. 
% You may check that this function (which I just made up), not give unique ids.
dimRedBy = 3;
meanDeltaPerSub = squeeze(meanDeltaPerSub);
numSubs = size(meanDeltaPerSub,2);

sphrSize = size(meanDeltaPerSub,1);
idxsToMean = reshape(1:sphrSize,dimRedBy,sphrSize/dimRedBy)';
for i = 1:size(idxsToMean,1) % loop on idxs to mean
    reducedDimMat(i,:) = mean(meanDeltaPerSub(idxsToMean(i,:),:),1);
end
MultMat  = [1:size(reducedDimMat,1)].*[1:size(reducedDimMat,1)];
uniqMat = repmat(MultMat',1,size(reducedDimMat,2));
signedReducDim = sign(reducedDimMat);
quadrantsPerSub = signedReducDim.*uniqMat;
numUnqQuadrants = length(unique(sum(quadrantsPerSub,1)));
clumpIdx = numUnqQuadrants/numSubs;
end