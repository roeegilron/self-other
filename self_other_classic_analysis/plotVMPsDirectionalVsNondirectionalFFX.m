function plotVMPsDirectionalVsNondirectionalFFX()
vmp = getGroundTruthVMPMapUnivariateVocalData();
rootDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\DirectionalVsNondirectionalFFX';
load(fullfile(rootDir,'rois_mandm_fdr_001.mat'));
load(fullfile(rootDir,'pvals_mandm.mat'));
locations = dataOut(1).locations ;
mask = dataOut(1).mask ;
mapType = 1;
for i = 1:length(rois) % loop on rois 
    for j = 1:3
    switch j
        case 1 
            typean = 'direcidxsonly';
            idxuse = rois(i).(typean);
            colorToUse = [40 184 15];
        case 2 
            typean = 'nondiidxsonly';
            idxuse = rois(i).(typean);
            colorToUse = [218 218 0];
        case 3
            typean = 'comonidxsonly';
            idxuse = rois(i).(typean);
            colorToUse = [227 177 50];
    end
%     idxuse = 1:size(locations,1);% XX FA maps whole brain 
    dataToPlot = zeros(size(locations,1),1);
    dataToPlot(idxuse) = 1;%rois(i).normMaps.fa(idxuse); % XXX just get boolean values
    minfa = min(rois(i).normMaps.fa(idxuse));
    maxfa = max(rois(i).normMaps.fa(idxuse));
    mapTitle = sprintf('%s (%d) FDR 0.01 %d subs %d cvfold',...
        typean,...
        length(idxuse),...
        length(rois(i).subsUsed),...
        rois(i).cvfold);
    fprintf('%s\n',mapTitle);
    dataFromAnsMatBackIn3d = scoringToMatrix(mask,dataToPlot,locations);
    curMapNum = vmp.NrOfMaps + 1;
    vmp.NrOfMaps = curMapNum;
    % set some map properties
    vmp.Map(curMapNum) = vmp.Map(1);
    vmp.Map(curMapNum).VMPData = dataFromAnsMatBackIn3d;
    vmp.Map(curMapNum).LowerThreshold = minfa;
    vmp.Map(curMapNum).UpperThreshold = maxfa;%XXX cutOff;
    vmp.Map(curMapNum).UseRGBColor = 0;
    vmp.Map(curMapNum).RGBLowerThreshNeg = colorToUse;
    vmp.Map(curMapNum).RGBUpperThreshNeg = colorToUse;
    vmp.Map(curMapNum).RGBLowerThreshPos = colorToUse ;
    vmp.Map(curMapNum).RGBUpperThreshPos = colorToUse;
    vmp.Map(curMapNum).Name = mapTitle;
    vmp.Map(curMapNum).Type = mapType;
    end
end

vmp.SaveAs();
end