function plotVMPRFXvsMVPAzscored()
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
%% plot graph of RFX and MVPA norms and the subtraction
subsOut = {'20subs','75subs'};
cnt =1;
figure;
for i = 1:length(subsOut)
    normMap = eval(['normMap' subsOut{i}]);
    mvpa = normalizeVecZeroToOne(normMap.MVPA);
    rfx  = normalizeVecZeroToOne(normMap.RFX);
    rfxneg = normalizeVecZeroToOne(normMap.RFX).*(-1);
    subplot(2,2,cnt);cnt=cnt+1;
    hold on;
    histogram(mvpa);
    histogram(rfxneg);
    title(sprintf('map of scaled (0-1) norms across brain%s',subsOut{i}));
    xlabel('norms across brain')
    ylabel('count')
    legend({'MVPA','RFX'});
    hold off;
    subplot(2,2,cnt);cnt=cnt + 1;
    rfxVsMVPAnorms = (mvpa + rfxneg).*10;
    histogram(rfxVsMVPAnorms);
    xlabel('MVPA  - RFX norms');
    ylabel('count');
    title({'subtraction of MVPA from RFX norms',...
        'negative = RFX norm higher, positive = MVPA norm higher'});
end
%% plot graph of RFX and MVPA norm maps all voxels vs each other
subsOut = {'20subs','75subs'};
uniqSig = [0.05, 0.01, 0.001];
for k = 1:length(uniqSig);
    for i = 1:length(subsOut)
        normMap = eval(['normMap' subsOut{i}]);
        %% use the log value and subtract it from each other.
        %         rfxVsMVPAnorms = ...
        %             (scaleVector(normMap.MVPA,'log-scaling')-scaleVector(normMap.RFX,'log-scaling'));
        %%%
        %% use the FA measure 
        rfxVsMVPAnorms = normMap.fa;
        %%
        rois = getROIsFromdataOutstruc(dataOut,subsOut{i},uniqSig(k),'FDR');
        zeroVoxels = setxor(1:length(rfxVsMVPAnorms),rois.all);
        rfxVsMVPAnorms(zeroVoxels) = 0;
        faVals  = rfxVsMVPAnorms(rois.all);
        minFA = min(faVals);
        maxFA = max(faVals);
        mapTitle = sprintf('%s FDR %.2f MVPAvsRFX (RFX neg, MVPA pos) %d vxls RFX %d vxls FFX',...
            subsOut{i},uniqSig(k),length(rois.rfx),length(rois.ffx));
        dataFromAnsMatBackIn3d = scoringToMatrix(mask,rfxVsMVPAnorms',locations);
        curMapNum = vmp.NrOfMaps + 1;
        vmp.NrOfMaps = curMapNum;
        % set some map properties
        vmp.Map(curMapNum) = vmp.Map(1);
        vmp.Map(curMapNum).VMPData = dataFromAnsMatBackIn3d;
        vmp.Map(curMapNum).LowerThreshold = minFA;
        vmp.Map(curMapNum).UpperThreshold = maxFA;%XXX cutOff;
        vmp.Map(curMapNum).UseRGBColor = 0;
        vmp.Map(curMapNum).Name = mapTitle;
        vmp.Map(curMapNum).Type = mapType;
    end
end
vmp.SaveAs()