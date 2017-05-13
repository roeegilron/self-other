function getBetaFromEachSubjectAndSaveMatFile()
rootDir  = 'F:\vocalDataSet\processedData\matFilesProcessedData\stats_normalized_sep_beta';

for i = 1:218
    subName = sprintf('data_%3.3d.mat',i);
    load(fullfile(rootDir,subName),'data');
    allSubsData(:,:,i) = data;
    fprintf('sub %3.3d opened \n',i);
end
load(fullfile(rootDir,subName))
save(fullfile(rootDir,'allSubsBetas.mat'),'allSubsData','mask','locations','labels');
end