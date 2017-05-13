function [filesFoundInDir, chosenDirName ]  = loadDirForRack()
rootDir = 'F:\vocalDataSet\processedData\matFilesProcessedData';
dirsToLoad = findFilesBVQX(rootDir,'*',struct('depth',1,'dirs',1));
fprintf('choose which dir [num] to load:\n\n');
for i = 1:length(dirsToLoad)
    [~, fn] = fileparts(dirsToLoad{i});
    fprintf('[%d] %s \n',...
        i,[fn '.mat']);
end
idx = input('which dir? ');
[~, chosenDirName] = fileparts(dirsToLoad{idx});
filesFoundInDir = findFilesBVQX(fullfile(dirsToLoad{idx}),...
'data*.mat',struct('depth',1));
fprintf('found these files in dir:\n\n');

for i = 1:length(filesFoundInDir)
    [~, fn] = fileparts(filesFoundInDir{i});
    fprintf('[%d] %s \n',...
        i,[fn '.mat']);
end


end