function reportNaNsOriginalData()
clc
rootFodler = ...
    'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\FFX_results';
pat = 'stats*.mat';
fNamesToAnalyze = findFilesBVQX(rootFodler,pat);
accRowZeros = [];
accColZeros = [];
subs = 1:218;
probSubs = []; %... % over 200 zero vox
%     [6    15    24    25    41    67,...
%     101   105   128   130   144   179,...
%     210   214];
probSubs = ... % over 50 zero vox
    [2     5     6    11    15,...
    24    25    38    41    43,...
    46    54    60    61    67,...
    68    71    78    83    99   101   105   108   113   128,...
       130   138   143   144   166   167   179   180   195   198   210   214];
subsToRunOn = 1:218;%setxor(subs,probSubs);
%{
for i = 1:length(subsToRunOn)
    load(fNamesToAnalyze{subsToRunOn(i)},'data','mask','locations')%,'dataDelta','ansMat') 
    [~,fp] = fileparts(fNamesToAnalyze{subsToRunOn(i)});
    fprintf('[%d] %s\n',i,fp);
%     ansMat = squeeze(ansMat);
%     data = zscore(data);
    toAn = data;
%     [rows,cols ] = ind2sub(size(toAn),find(isnan(toAn) == 1));
%     fprintf('\t%d unq rows, %d unq colms\n',...
%         length(unique(rows)),...
%         length(unique(cols)))
%     accRowZeros = [accRowZeros rows'];
%     accLenNaNs(i) = length(unique(rows));
    
    [rows,cols ] = ind2sub(size(toAn),find(toAn == 0));
%     fprintf('\t%d unq rows, %d unq colms\n',...
%         length(unique(rows)),...
%         length(unique(cols)))
    idxVoxelZeroInvdSub = unique(cols);
    idxsVoxlMissing{i} = idxVoxelZeroInvdSub;
    find(sum(toAn(:,idxVoxelZeroInvdSub))~=0);
%     if length(idxVoxelZeroInvdSub) ~= sum(length(find(sum(toAn(:,idxVoxelZeroInvdSub))==0)))
%         fprintf('\tflag\n')
%     end
%     fprintf('\t%d voxels with zeros, of which %d trials with zeros\n',...
%         length(idxVoxelZeroInvdSub),...
%         sum(length(find(sum(toAn(:,idxVoxelZeroInvdSub))==0))) );
    accRowZeros = [accRowZeros rows'];
    unqRows = unique(accRowZeros);
    accColZeros = [accColZeros cols'];
    unqCols = unique(accColZeros);
    countVoxelsWithZero(i) = length(idxVoxelZeroInvdSub);
    
    clear data
end

figure; 
histogram(countVoxelsWithZero)
ylabel('count')
xlabel('numver of voxels with zero values in each subj')
title(sprintf('Total number of non overlapping voxels = %d',length(unqCols)));
%}
load('voxelsWithZerosVocalDataSet.mat');


%% create a VMP to visualize voxels that have zero values: 
voxelMissingAndSubs = [1:218 ; countVoxelsWithZero];
voxelMissingAndSubs = voxelMissingAndSubs';
voxelMissingAndSubs = sortrows(voxelMissingAndSubs,2);

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

for i = 218:-1:1
    numVoxelsWithZero = voxelMissingAndSubs(i,2);
    subNum = voxelMissingAndSubs(i,1);
    idxWithZero =  idxsVoxlMissing{ subNum};

    rawMaskVoxels = zeros(size(locations,1),1); % initizlie mask 
    rawMaskVoxels(idxWithZero) = 1;
    dataFromAnsMatBackIn3d = scoringToMatrix(mask,rawMaskVoxels,locations);
    mapName = sprintf('sub %d - %d zeros',subNum,sum(rawMaskVoxels));
    curMapNum = vmp.NrOfMaps + 1;
    vmp.NrOfMaps = curMapNum;
    % set some map properties
    vmp.Map(curMapNum) = vmp.Map(1);
    vmp.Map(curMapNum).Name = mapName;
    vmp.Map(curMapNum).VMPData = dataFromAnsMatBackIn3d;
    vmp.Map(curMapNum).LowerThreshold = 0;
    vmp.Map(curMapNum).UpperThreshold = 10;%XXX cutOff;
    vmp.Map(curMapNum).RGBLowerThreshPos = [ 255 255 0];
    vmp.Map(curMapNum).RGBUpperThreshPos = [ 255 255 0];
    vmp.Map(curMapNum).RGBLowerThreshNeg = [ 255 255 0];
    vmp.Map(curMapNum).RGBUpperThreshNeg = [ 255 255 0];
    vmp.Map(curMapNum).UseRGBColor = 1;
end
vmp.SaveAs()
end