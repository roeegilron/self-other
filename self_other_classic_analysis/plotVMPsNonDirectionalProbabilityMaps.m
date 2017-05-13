function plotVMPsNonDirectionalProbabilityMaps()
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
%for "Type of Map" are reserved, i.e.,
%1 -> t-values, 2 -> correlation values,
%3 -> cross-correlation values, 4 -> F-values,
% 11 -> percent signal change values, 12 -> ICA z values.
mapType = 1;
vmp.Map(1).Type = mapType;
load('normMaps30k.mat');
rootDirOriginalData = ...
    'F:\vocalDataSet\processedData\matFilesProcessedData\stats_normalized_sep_beta';
load(fullfile(rootDirOriginalData,'allSubsBetas.mat'),'mask','locations');
%% plot graph of RFX and MVPA norm maps all voxels vs each other
subsOut = {'20subs','75subs'};
subsOut = {'75subs'};
uniqSig = [0.05, 0.01, 0.001];
uniqSig = [0.05];
methodsUsed = {'FDR','FWE'};%{'FDR','FWE'};
for z = 1:length(methodsUsed)
    for k = 1:length(uniqSig);
        for i = 1:length(subsOut)
            normMap = eval(['normMap' subsOut{i}]);
            %%
            rois = getROIsFromdataOutstruc(dataOut,subsOut{i},uniqSig(k),methodsUsed{z});
            getProabilityMapsFromROI(rois.ffx,rois.subsUsedFFX,subsOut{i},uniqSig(k),methodsUsed{z},'NonDi'); 
            getProabilityMapsFromROI(rois.rfx,rois.subsUsedRFX,subsOut{i},uniqSig(k),methodsUsed{z},'Direc'); 
            dataToPlot = zeros(size(locations,1),1);
            dataToPlot(rois.ffx) = 1;
            %%
%             dataToPlot(rfxOnly) = -5;
%             dataToPlot(ffxOnly) = 5;
%             dataToPlot(commonV) = 1;
            mapTitle = sprintf('%s %s %.2f FFX (%d) pos  # min pval %d',...
                subsOut{i},...
                methodsUsed{z},...
                uniqSig(k),...
                length(ffxOnly),...
                rois.minPvalrfx);
            fprintf('%s\n',mapTitle);
            dataFromAnsMatBackIn3d = scoringToMatrix(mask,dataToPlot,locations);
            curMapNum = vmp.NrOfMaps + 1;
            vmp.NrOfMaps = curMapNum;
            % set some map properties
            vmp.Map(curMapNum) = vmp.Map(1);
            vmp.Map(curMapNum).VMPData = dataFromAnsMatBackIn3d;
            vmp.Map(curMapNum).LowerThreshold = 0;
            vmp.Map(curMapNum).UpperThreshold = 6;%XXX cutOff;
            vmp.Map(curMapNum).UseRGBColor = 0;
            vmp.Map(curMapNum).RGBLowerThreshNeg = [120 255 255 ]; 
            vmp.Map(curMapNum).RGBUpperThreshNeg = [20 255 255 ] ;
            vmp.Map(curMapNum).RGBLowerThreshPos = [240 255 255 ] ;
            vmp.Map(curMapNum).RGBUpperThreshPos = [240 255 255 ] ;
            vmp.Map(curMapNum).Name = mapTitle;
            vmp.Map(curMapNum).Type = mapType;
        end
    end
end
vmp.SaveAs()
end
function outVec = convertToUniq(roiidx,baseVal)
outVec=[];
for i = 1:length(roiidx)
    outVec(i) =   eval( sprintf('%d.%d',baseVal,roiidx(i)));
end
end