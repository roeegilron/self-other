function analyzeRFXorFFXperformanceVocalDataSetv2()
% filenames:
rootDirResults = ...
    'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\FFXandRFX_files_readyForanalysis';
rootDirOriginalData = ...
    'F:\vocalDataSet\processedData\matFilesProcessedData\stats_normalized_sep_beta';
origFilePat = 'data*.mat';
fileNameForAnalysis = 'RFX-FFX-vocal-DataSetAnalysis.txt';
fileToAnalyze{1} = 'VocalDataSet_results_20-subs_27-slSize_cvFold30_RFX_zscored_20150819T090227.mat';
fileToAnalyze{2} = 'VocalDataSet_results_20-subs_27-slSize_cvFold30_FFXstlzrstyleNoZeroingNaN.mat';

% fileToAnalyze{1} = 'VocalDataSet_results_75-subs_27-slSize_cvFold20_RFX_zscored_20150818T165304.mat';
% fileToAnalyze{2} = 'VocalDataSet_results_75-subs_27-slSize_cvFold20_FFXstlzrstyleNoZeroingNaN.mat';
for j = 1:length(fileToAnalyze)
    if isempty(regexp(fileToAnalyze{j},'FFX'))
        inference = 'RFX';
    else
        inference = 'FFX';
    end
    % fid = openTextFileWithoutOverwriting(fullfile(pwd,fileNameForAnalysis));
    [~] = evalc(['fid' inference ' = fopen( ' '''' inference '_20Subs.txt'',''w+'')']);
    
    fprintf(eval(['fid' inference]),...
        ['inference,stat,cutOff,fold,subject,voxelsPassing,'...
        'normMean,normMedian,AminusB,sumAbsAminusB,maxAbsAminusB\n']);
    load(fullfile(rootDirResults,fileToAnalyze{j}),'subsExtracted','ansMat');
    statMethod = 'FDR';
    cutOffVal  = 0.05;
    fold = 20;
    sigMap = calcAnsMatSig(ansMat,statMethod,cutOffVal);
%     eval(['roiIdxs' inference])  = find(sigMap == 1);
if j == 1
    roiIdxsRFX = find(sigMap == 1);
else
    roiIdxsFFX = find(sigMap == 1);
end
    
end
%% find non overlapping voxels: 
roiIdxsInRFXnotInFFX = setdiff(roiIdxsRFX,roiIdxsFFX);
% roiIdxsInFFXnotInRFX = setdiff(roiIdxsFFX,roiIdxsRFX);
% roiIdxsRFX = roiIdxsInRFXnotInFFX;
% roiIdxsFFX = roiIdxsInFFXnotInRFX;

%fprintf('%d voxels passing \n',sum(sigMap));
leftOutSubjects = setxor(1:218,subsExtracted);
probSubs = ... % over 50 zero vox
    [2     5     6    11    15,...
    24    25    38    41    43,...
    46    54    60    61    67,...
    68    71    78    83    99   101   105   108   113   128,...
       130   138   143   144   166   167   179   180   195   198   210   214];
leftOutSubjects = setxor(leftOutSubjects,probSubs);
cnt = 1;
for i = 1:length(leftOutSubjects)
    for j = 1:length(fileToAnalyze)
        if j ==1; inference = 'RFX'; rois = roiIdxsRFX;  
        else inference = 'FFX'; rois = roiIdxsFFX; end
        subName = sprintf('data_%3.3d.mat',leftOutSubjects(i));
        [outData(cnt)] = calcSubNormInROI(...
            fullfile(rootDirOriginalData,subName)...
            ,rois,inference,length(rois),leftOutSubjects(i));
        
        fprintf('finished calcing norm sub %d\n',i);
        fprintf(eval(['fid' inference]),...
            '%s,%s,%f,%d,%d,%d,%f,%f,%f,%f,%f\n',...
            inference,...
            statMethod,...
            cutOffVal,...
            fold,...
            leftOutSubjects(i),...
            length(rois),...
            outData(cnt).subNormMean,...
            outData(cnt).subNormMedian,...
            outData(cnt).subAminusB,...
            outData(cnt).subAbsAminusB,...
            outData(cnt).subMaxAbsAminusB...
            );
        outDataNorm.(inference) = outData(cnt).subNormRaw;
        cnt = cnt + 1;
    end
%     calcBoxPlotsOfNormOneSubject(outDataNorm,leftOutSubjects(i),rootDirResults);
end
fclose('all');
return
%% create a graph
rfxTbl = readtable('RFXReportFold30.txt');
ffxTbl = readtable('FFXReportFold30.txt');

rawProps = rfxTbl.Properties
PropsToPlot = rawProps.VariableNames(6:end)
hFig = figure;
for i = 1:length(PropsToPlot)
    subplot(3,2,i);
    scatter(ffxTbl.(PropsToPlot{i}),rfxTbl.(PropsToPlot{i}))
    hold on;
    axis('equal')
    ylimNum = get(gca,'YLim');
    xlimNum = get(gca,'XLim');
    ceilVal = ceil(max([xlimNum, ylimNum]));
    minVal = floor(min([xlimNum, ylimNum]));
    xlim([minVal ceilVal]);
    ylim([minVal ceilVal]);
    line([ get(gca,'XLim')],[ get(gca,'YLim')],'LineWidth',2)
    ttlStr = sprintf('%s of paird FFX / RFX within ROI',PropsToPlot{i});
    title(ttlStr);
    xlblttl = sprintf('FFX Norm  (%d Voxels)',ffxTbl.voxelsPassing(1));
    ylblttl = sprintf('RFX Norm  (%d Voxels)',rfxTbl.voxelsPassing(1));
    xlabel(xlblttl);
    ylabel(ylblttl);
end
end