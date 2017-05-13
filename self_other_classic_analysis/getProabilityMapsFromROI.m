function getProabilityMapsFromROI(roiidxs,subsToComputeWith,numSubs,alpha,infmethod,typeOfAna)
rootDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\FFXandRFX_current';
fn = 'pValsDirectionalIndividualSubjectsFFX.mat';
load(fullfile(rootDir,fn));
probSubs = ... % over 50 zero vox
    [2     5     6    11    15,...
    24    25    38    41    43,...
    46    54    60    61    67,...
    68    71    78    83    99   101   105   108   113   128,...
       130   138   143   144   166   167   179   180   195   198   210   214];
allSubs = 1:218;
remSubs = setdiff(allSubs,probSubs);
leftOutSubjets = setdiff(remSubs,subsToComputeWith);
alpha = 0.1;
%% compute within proabbiliy map: 
sigMap = [];
for i = 1:length(subsToComputeWith)
   pValFFX = dataOut.Pvals(:,subsToComputeWith(i));
   [sigMap(:,i), cutoff(i)] = fdr_bh(pValFFX,alpha,'pdep','no');
   fprintf('sub %d has %d voxels passing\n',...
       subsToComputeWith(i),sum(sigMap(:,i)));
end 
probMapAllBrain = sum(sigMap,2)./length(subsToComputeWith);
probaMapWithinROI = probMapAllBrain(roiidxs);
ttlstr = sprintf('%s probabiliy within ROI, subs in analysis, %s %1.2f %s',typeOfAna, numSubs,alpha,infmethod);
figure;
histogram(probaMapWithinROI);
title(ttlstr); 
xlabel('probabliy of activation across voxels'); 
ylabel('count'); 
%% compute left out probably map 

sigMap = [];
for i = 1:length(leftOutSubjets)
   pValFFX = dataOut.Pvals(:,leftOutSubjets(i));
   [sigMap(:,i), cutoff(i)] = fdr_bh(pValFFX,alpha,'pdep','no');
   fprintf('sub %d has %d voxels passing\n',...
       leftOutSubjets(i),sum(zzzsigMap(:,i)));
end 
probMapAllBrain = sum(sigMap,2)./length(leftOutSubjets);
probaMapWithinROILeftOut = probMapAllBrain(roiidxs);
ttlstr = sprintf('%s probabiliy within ROI, left out subs, %s %1.2f %s',typeOfAna, numSubs,alpha,infmethod);
figure;
histogram(probaMapWithinROILeftOut);
title(ttlstr); 
xlabel('probabliy of activation across voxels'); 
ylabel('count'); 

figure;
scatter(probaMapWithinROI,probaMapWithinROILeftOut)
xlabel('within')
ylabel('left out');
end