function    [ffxMatrix, lableMatrix] = createFFXdata(rawData,numShuffels,labels)
%ffxMatrix(subjects, voxels, shuffels) (first shuffle is real);
for i = 1:numShuffels + 1 % loop on shuffels 
    for j = 1:size(rawData,3) % loop on subjects
        if i == 1
            shufLabels = labels;
        else
            shufLabels = labels(randperm(length(labels)));
        end
        lableMatrix(:,j,i) = shufLabels;
        rawsubData = squeeze(rawData(:,:,j));
        meanA = mean(rawsubData(shufLabels==1,:),1);
        meanB = mean(rawsubData(shufLabels==2,:),1);
        subDelta = meanA - meanB;
        ffxMatrix(j,:,i) = subDelta;
    end
    fprintf('ffx shuffle %d out of %d\n',i,numShuffels);
end

end
