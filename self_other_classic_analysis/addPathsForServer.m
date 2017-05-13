function addPathsForServer()
if ismac
    pathToToolbox = genpath(fullfile(fileparts(pwd),'toolboxes'));
    addpath(pathToToolbox); 
else
    pathToToolbox = genpath(fullfile(fileparts(pwd),'toolboxes'));
    addpath(pathToToolbox);
    
end

end