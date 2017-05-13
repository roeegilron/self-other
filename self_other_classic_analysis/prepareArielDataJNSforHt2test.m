function prepareArielDataJNSforHt2test()
baseFolder = 'JNS_benchmark_intention_v5';
% baseFolder = 'JNS_benchmark_motor_v5';
%% get file names 
fNames = findFilesBVQX(fullfile(pwd,baseFolder),'*realData*.mat');
cnt = 1;
for i = 1:length(fNames)
    fileStruct = matfile(fNames{i});
    unqLabels = unique(fileStruct.labels);
    rawData  = fileStruct.data;
    for j = 1:length(unqLabels)
        relIdxs = find(fileStruct.labels == unqLabels(j));
        data(cnt,:) = mean(rawData(relIdxs,:),1);
        labels(cnt) = unqLabels(j); 
        cnt = cnt + 1;
    end
    clear rawData;
end
fnToSave = [baseFolder '_MuniMeng_ReadyData.mat'];
locations = fileStruct.locations;
mask = fileStruct.map;
save(fullfile(pwd,baseFolder,fnToSave),'data','mask','locations','labels');
end