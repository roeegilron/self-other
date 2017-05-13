function constructFFXDataBasedOnManualFolds()
computeStzler = 1;
numMaps = 1e3; % num of shuffels maps to use 
dirWithDta = ...
    'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\ffxNotZscoredVocalDataSet\';
outDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\DirectionalVsNondirectionalFFX';

load('subsExtracted30kFolds.mat');
folds = [20, 21,30, 31]; % only fold not done 
for i = 1:length(folds)
    subsExtracted = eval(sprintf('subsToExtrctFold%d',folds(i)));
    computeFFXresults(subsExtracted,folds(i),computeStzler,dirWithDta,outDir,numMaps)    
end

end