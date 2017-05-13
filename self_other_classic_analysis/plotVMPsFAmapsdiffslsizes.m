function plotVMPsFAmapsdiffslsizes()
vmp = getGroundTruthVMPMapUnivariateVocalData();
rootDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\DirectionalVsNondirectionalFFX';
load(fullfile(rootDir,'famaps_20_SUBS.mat'));
locations = famaps(1).locations ;
mask = famaps(1).mask ;
mapType = 1;
for i = 1:length(famaps) % loop on rois 
    idxuse = 1:size(locations,1);% XX FA maps whole brain 
    dataToPlot = zeros(size(locations,1),1);
    dataToPlot(idxuse) = famaps(i).normMaps.fa(idxuse);
    minfa = min(famaps(i).normMaps.fa(idxuse));
    maxfa = max(famaps(i).normMaps.fa(idxuse));
    mapTitle = sprintf('raw FA sl size %d subs %d',...
        famaps(i).slsize,...
        famaps(i).numsubs);
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
    vmp.Map(curMapNum).RGBLowerThreshNeg = [120 255 255 ];
    vmp.Map(curMapNum).RGBUpperThreshNeg = [20 255 255 ] ;
    vmp.Map(curMapNum).RGBLowerThreshPos = [240 255 255 ] ;
    vmp.Map(curMapNum).RGBUpperThreshPos = [240 255 255 ] ;
    vmp.Map(curMapNum).Name = mapTitle;
    vmp.Map(curMapNum).Type = mapType;
end

vmp.SaveAs();
end