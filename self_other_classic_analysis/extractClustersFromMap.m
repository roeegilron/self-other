function [val,instances] = extractClustersFromMap(ansMat,mask,locations,TcutOff)
connScheme = 26;
ansMatFormatted(:,1) = 1:length(ansMat); 
ansMatFormatted(:,2) = ansMat; 
fmrData = scoringToMatrix(mask, ansMatFormatted, locations);
% check if there are clusters in real data that pass cut off. If not, abort
if sum(sum(sum(fmrData>TcutOff))) == 0
    fprintf('real data map does not have any voxels that pass %1.4f acc threshold, aborting\n',accCutOff)
    return
else
    [val, instances, ~]=getAllCc(fmrData>TcutOff,connScheme(1),1); %
end

end