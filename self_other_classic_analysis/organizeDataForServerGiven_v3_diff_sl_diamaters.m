function organizeDataForServerGiven_v3_diff_sl_diamaters()

%% data for the exaustive test on the server:
% rootDir = uigetdir('please choose the directory where the .mat files are')
rootDir = pwd;
slSize = input('what sl size do you want?');
% filesFound = findFilesBVQX(fullfile(rootDir,'s*.mat'));
filesFound = findFilesBVQX(fullfile(rootDir,'VocalDataSet_*20-subs*cvFold2*.mat'));
for i = 1:length(filesFound) 
    startTime = tic;
    load(filesFound{i});
    [pN fN] = fileparts(filesFound{i});
    subjectName = sName;
    params.outputDir = rootDir;
    params.useSaveFast = 0;
    params.saveDataForServer = 1;
    params.searchLightSize = slSize;
%     sName = [sName '_' num2str(slSize) '_'];
    % save subset of data 
    findNeibhoursAndOrganizeDataForServer(data, labels ,map,params,locations,vtcRes,sName)
    fprintf('finished saving subject %s in %f secs\n',subjectName,toc(startTime));
end


end
