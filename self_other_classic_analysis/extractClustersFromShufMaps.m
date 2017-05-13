function  [unqClusSizes,countOfUnqClusSize] = extractClustersFromShufMaps(ansMat,mask,locations,TcutOff)
connScheme = 26;
clustSizesShuff = []; countOfSizesShuff = []; unqClusSizes = [];
for i = 2:size(ansMat,2)
    % calculate number of clusters in each size at thresh:
    %format ansMat the way Ariel expects it:
    ansMatFormated(:,1) = 1:size(ansMat(:,i),1);
    ansMatFormated(:,2) = ansMat(:,i);
    fmrData = scoringToMatrix(mask, ansMatFormated, locations);
    if sum(sum(sum(fmrData>TcutOff))) % check if you even have clusters
        [valuesShuf, instancesShuf,~]=getAllCc(fmrData>TcutOff,connScheme(1),1);
        clustSizesShuff = [clustSizesShuff ; valuesShuf];
        countOfSizesShuff = [countOfSizesShuff ; instancesShuf];
    end
end
% creat the unique count of cluster sizes / instances
unqClusSizes = unique(clustSizesShuff);
countOfUnqClusSize = zeros(length(unqClusSizes),1);
for i = 1:length(unqClusSizes)
    idxToSum = find(unqClusSizes(i) == clustSizesShuff);
    countOfUnqClusSize(i) = sum(countOfSizesShuff(idxToSum));
end


end