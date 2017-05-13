function [ data,locations, mask, labels, fnTosave ]  = loadDataForRack()
filesToLoad = findFilesBVQX(pwd,'*.mat',struct('depth',1));
fprintf('choose which files [num] to load:\n\n');
for i = 1:length(filesToLoad)
    [~, fn] = fileparts(filesToLoad{i});
    fprintf('[%d] %s \n',...
        i,[fn '.mat']);
end
idx = input('which file? ');
load(filesToLoad{idx})
    [~, fnTosave] = fileparts(filesToLoad{idx});

end