function  [ data,locations, mask, labels ]  = loadDataForServer()
dirName = 'G:\ReadyForServerPassive';
filesToLoad = findFilesBVQX(fullfile(dirName,'ss*.mat'));
%% loop on each subject and get data
outData = []; outLabels = [];
cnt = 1;
for i = 1:length(filesToLoad)
    load(filesToLoad{i});
    unqLabels = unique(labels);
    if ndims(data) == 3 % this is data already ready for server 
        data = squeeze(data(:,1,:));
    end
    for j = 1:length(unqLabels)
        tempData = mean(data(unqLabels(j)==labels,:),1);
        outData(cnt,:) = tempData;
        outLabels(cnt) = unqLabels(j);
        cnt = cnt+1;n
    end
    clear data labels 
end
mask = int16(map);
data = outData;
labels = outLabels;

save('OriPassiveTransfer.mat','data','locations','mask','labels');

end