function  [ data,locations, mask, labels ]  = loadDataWithNegbrsForServer()
dirName = uigetdir();
filesToLoad = findFilesBVQX(fullfile(dirName,'ss*.mat'));
%% loop on each subject and get data
outData = []; outLabels = [];
cnt = 1;
start = tic;
for i = 1:length(filesToLoad)
    dataStruc = matfile(filesToLoad{i});
    %load only the first column 
    data = squeeze(dataStruc.data(:,1,:));
    % load the rest of the data you need 
    load(filesToLoad{i},'labels','locations','map');
    unqLabels = unique(labels);
    for j = 1:length(unqLabels)
        tempData = mean(data(unqLabels(j)==labels,:),1);
        outData(cnt,:) = tempData;
        outLabels(cnt) = unqLabels(j);
        cnt = cnt+1;
    end
    fprintf('finised loading sub %s in %f sec\n',dataStruc.subjectName,toc(start))
    clear data labels 
end
mask = int16(map);
data = outData;
labels = outLabels;


end