function addPaths()
[pN,~] = fileparts(pwd);
pathToToolbox = genpath(fullfile(pN,'toolboxes'));
addpath(pathToToolbox); 