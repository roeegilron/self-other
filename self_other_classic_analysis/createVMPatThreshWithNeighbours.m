function vmp = ...
    createVMPatThreshWithNeighbours...
    (ansMat,clustThresh,pn,fn,cutOff,locations,mask,pVal,method,params, vmp)
connScheme = 26;
%% get the 3d map 
ansMatAverage(:,2) = ansMat(:,1); %   first column is real data
ansMatAverage(:,1) = 1:size(ansMat,1);
dataFromAnsMatBackIn3d = scoringToMatrix(mask,ansMatAverage,locations);

%% zero out values that do not pass cluster threshold in map
fmrDataToWrite = zeros(size(dataFromAnsMatBackIn3d));
[values, instances,rp]=getAllCc(dataFromAnsMatBackIn3d>cutOff,connScheme,1);
idxOfrpThatPassClusThres = find([rp.Area] >= clustThresh);
% concatenate all idx that pass thresh
idxINfmrDataSpaceThatPassThresh = [];
for j = 1:length(idxOfrpThatPassClusThres)
    idxINfmrDataSpaceThatPassThresh = [idxINfmrDataSpaceThatPassThresh ; ...
        rp(idxOfrpThatPassClusThres(j)).PixelIdxList];
end
fmrDataToWrite(idxINfmrDataSpaceThatPassThresh) = dataFromAnsMatBackIn3d(idxINfmrDataSpaceThatPassThresh);


%% this finds all the neighbours of the idxes that passed and add them to map:
idx = knnsearch(locations, locations, 'K', params.regionSize);
ansMat = reverseScoringToMatrix(fmrDataToWrite,locations);
idxNonZeroVals = find(ansMat(:,2) > 0);
rawNeibourIdxs = idx(idxNonZeroVals,:);
rawNeibourIdxs = unique(rawNeibourIdxs(:)) ; % vectorize and get unq
neghibourIdxs = setxor(idxNonZeroVals,rawNeibourIdxs);
ansMat(neghibourIdxs,2) = 0.2; % set neibhbour indexes to 0.2
dataFromAnsMatBackIn3dWithNeigbors = scoringToMatrix(mask,ansMat,locations);

%% create a dummy vmp to work with
% This is the original data
% just load this temp
niftiData = load_nii(fullfile(pwd,...
    'thresholded_searchlight_results_0.6_2mm_pumpVcashout.nii.gz')); % this is dummy nifty data
niftiData.img = dataFromAnsMatBackIn3dWithNeigbors;
fileNameToWrite = sprintf('method-%s-TcutOff-%.3f-Pval-%.3f-clusterThres-%d',...
                            method,cutOff,pVal,clustThresh);
save_nii(niftiData,fullfile(pn,[fileNameToWrite '.nii']));
n = neuroelf;
vmpPstat = n.importvmpfromspms(fullfile(pn,[fileNameToWrite '.nii']),'a',[],2);


%% add this map to the vmp
curMapNum = vmp.NrOfMaps + 1;
vmp.NrOfMaps = curMapNum;
% set some map properties
vmp.Map(curMapNum) = vmpPstat.Map;
vmp.Map(curMapNum).LowerThreshold = 0;
vmp.Map(curMapNum).UpperThreshold = cutOff;
vmp.Map(curMapNum).Name = fileNameToWrite;
end