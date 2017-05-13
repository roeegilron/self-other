function vmp = getGroundTruthVMPMapUnivariateVocalData()
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
%for "Type of Map" are reserved, i.e.,
%1 -> t-values, 2 -> correlation values,
%3 -> cross-correlation values, 4 -> F-values,
% 11 -> percent signal change values, 12 -> ICA z values.
mapType = 1;
vmp.Map(1).Type = mapType;

end