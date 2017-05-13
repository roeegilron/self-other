function [outData,outLabels,fnTosave,subsToExtrct]  = ...
    extractSubjectsFromDataRandmly(data,labels,numSubsToExtracs,slSize,cvFold)
allSubjects = []; 
for i = 1:108
    allSubjects = [allSubjects, i , i ]; 
end
allSubjects = allSubjects';
rng(cvFold);
subsToExtrct = randperm(108,numSubsToExtracs);
idxToExtract = [] ; 
for j = 1:length(subsToExtrct)
idxToExtract = [idxToExtract; ...
    find(allSubjects==subsToExtrct(j))];
end
outData = data(idxToExtract,:);
outLabels = labels(idxToExtract); 
extractedSubjecst = allSubjects(idxToExtract);
fnTosave = sprintf('RussBaseData_results_%d-subs_%d-slSize_cvFold%d',...
    numSubsToExtracs,slSize,cvFold);
end