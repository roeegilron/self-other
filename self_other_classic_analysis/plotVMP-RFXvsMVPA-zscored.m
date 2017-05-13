function plotVMP-RFXvsMVPAzscored()
%% plot z scored norms RFX vs MVPA on brain

vmpGrunTruth = fullfile(...
    'D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX\vocalDataSet\grounTruthMaps\spmT_0001',...
    'spmT_0001_RFX_FromPaper.vmp');
vmp = BVQXfile(vmpGrunTruth);
voxelPasing = sum(sum(sum(vmp.Map.VMPData>4.79)));
addstr= sprintf(' voxl passing %d',voxelPasing);
vmp.Map.Name = [vmp.Map.Name addstr];
vmp.Map(1).LowerThreshold = 4.79;
vmp.Map(1).RGBLowerThreshPos = [ 0 0 255];
vmp.Map(1).RGBUpperThreshPos = [ 0 0 255];
vmp.Map(1).RGBLowerThreshNeg = [ 0 0 255];
vmp.Map(1).RGBUpperThreshNeg = [ 0 0 255];
vmp.Map(1).UseRGBColor = 1; 

load('normMaps.mat');
rootDirOriginalData = ...
    'F:\vocalDataSet\processedData\matFilesProcessedData\stats_normalized_sep_beta';
load(fullfile(rootDirOriginalData,'allSubsBetas.mat'),'mask','locations');
%% plot graph of RFX and MVPA norm maps all voxels vs each other 
subsOut = {'20subs','75subs'};
for i = 1:length(subsOut)
    normMap = eval(['normMap' subsOut{i}]);
    for j = 1:2 % RFX / MVPA z scored 
        if j == 1
            zscred = zscore(normMap.MVPA);
            mapTitle = sprintf('%s MVPA', subsOut{i});
        else
            zscred = zscore(normMap.RFX);
            mapTitle = sprintf('%s RFX', subsOut{i});
        end
        dataFromAnsMatBackIn3d = scoringToMatrix(mask,zscred,locations);    
    curMapNum = vmp.NrOfMaps + 1;
    vmp.NrOfMaps = curMapNum;
    % set some map properties
    vmp.Map(curMapNum) = vmp.Map(1);
    vmp.Map(curMapNum).VMPData = dataFromAnsMatBackIn3d;
    vmp.Map(curMapNum).LowerThreshold = 0;
    vmp.Map(curMapNum).UpperThreshold = 10;%XXX cutOff;
    vmp.Map(curMapNum).Name = mapTitle
    end
end

vmp.SaveAs()