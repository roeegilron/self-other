function flattenData = flattenData(data,locations)
data = double(data);
for i = 1:size(data,4)
    flattenData(i,:) = reverseScoringToMatrixForFlat(data(:,:,:,i), locations);
end
