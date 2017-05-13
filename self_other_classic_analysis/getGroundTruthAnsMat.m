function ansMat = getGroundTruthAnsMat()
mask = getMask(); % get mask 
locations = getLocations(mask); % get locations in mask 
data = getGroundTruth();
ansMat = reverseScoringToMatrixForFlat(data, locations);
end