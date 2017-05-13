function [outData] = calcSubNormInROI(matFile,roiIdxs,inference,voxelPssing,subNum)

params.regionSize = 27;
% find subject:
load(matFile)
idx = knnsearch(locations, locations, 'K', params.regionSize);
for i = 1:length(roiIdxs) % loop on spheres
    curSphrIdxs = idx(roiIdxs(i),:);
    diffMat = mean(data(labels == 1, curSphrIdxs)) - ...
        mean(data(labels == 2, curSphrIdxs));
    sqrDiffMat = diffMat.^2;
    subNorm(i) = sqrt(sum(sqrDiffMat));
    diffMatCollected(i) = mean(diffMat);
    diffMatAbs(i) = mean(abs(diffMat));
    diffMaxAbs(i) = max(abs(diffMat));
end

% hold on;
% histogram(subNorm,'DisplayStyle','stairs')
% title('histogram of norms across all voxels in brain in 10 left out subjects');
% ylabel('count');
% xlabel('norm');

outData.subNormMean = mean(subNorm);
outData.subNormMedian = median(subNorm);
outData.subAminusB = median(diffMatCollected);
outData.subAbsAminusB = median(diffMatAbs);
outData.subMaxAbsAminusB = max(diffMaxAbs);
outData.subNormRaw = subNorm;
outData.vxl = voxelPssing;
outData.inference = inference;
outData.subNum = subNum;
end