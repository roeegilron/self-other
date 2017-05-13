function analyzeRFXorFFXperformanceVocalDataSystematicInvest()
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
    [~] = evalc(['fid' inference ' = fopen( ' '''' inference 'SystematicInvestFFXincreasingRelaxed.txt'',''w+'')']);
    
    fprintf(eval(['fid' inference]),...
        ['inference,stat,cutOff,fold,subject,voxelsPassing,'...
        'normMean,normMedian,AminusB,sumAbsAminusB,maxAbsAminusB\n']);
    load(fullfile(rootDirResults,fileToAnalyze{j}),'subsExtracted','ansMat');
    statMethod = 'FWE';
    cutOffVal  = 0.01;
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
% roiIdxsInRFXnotInFFX = setdiff(roiIdxsRFX,roiIdxsFFX);
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
leftOutSubjects = [87    48   122   202   217   209    94    62,...
    157   117    85    86   213   174    19    80    26   183     9   204];

%% set ROI IDX of FFX to be anything but FFX but random.
allVoxels = 1:size(ansMat,1);
voxelsNotInRFX = setxor(allVoxels,roiIdxsRFX);
multiplesOfRFX = [10 30 60 105];
% fold = 1;
% for i = 1:length(multiplesOfRFX)
%     numVoelsNeeded = length(roiIdxsRFX) * multiplesOfRFX(i);
%     potVoxls = length(voxelsNotInRFX);
%     voxelsToChoose = voxelsNotInRFX(randperm(potVoxls,numVoelsNeeded));
%     roiVoxelsFFX{i} = voxelsToChoose;
% end
%% set ROI idxs of FFX to an increasingly relaxed threhsold 
load(fullfile(rootDirResults,fileToAnalyze{2}),'subsExtracted','ansMat');
statMethod = 'FDR';
cutOffVal  = 0.05;
fold = 20;

cutOffVals = [0.05 0.5 0.75 0.9];
for i = 1:length(cutOffVals)
    sigMap = calcAnsMatSig(ansMat,statMethod,cutOffVals(i));
    fprintf('% d voxls passing at %f\n',sum(sigMap),cutOffVals(i))
    voelsPassingFFX = find(sigMap==1);
    voxelsNotInRFXpassingFFX = setxor(voelsPassingFFX,roiIdxsRFX);
    roiVoxelsFFX{i} = voxelsNotInRFXpassingFFX;
end
save('FFXROIs.mat','roiVoxelsFFX','fold');


%% create txt files
cnt = 1;
for z = 1:length(roiVoxelsFFX)
    for i = 1:length(leftOutSubjects)
        for j = 1:2%length(fileToAnalyze)
            if j ==1; inference = 'RFX'; rois = roiIdxsRFX;
            else inference = 'FFX'; rois = roiVoxelsFFX{z}; end
            subName = sprintf('data_%3.3d.mat',leftOutSubjects(i));
            fprintf('z %d i %d j %d \n',z, i ,j);
            runThis = 1;
            if z~=1
                if j == 1 % dont rereun rfx a million times
                    runThis = 0;
                end
            end
            if runThis
                [outData(cnt)] = calcSubNormInROI(...
                    fullfile(rootDirOriginalData,subName)...
                    ,rois,inference,length(rois),leftOutSubjects(i));
                
                %             fprintf('finished calcing norm sub %d\n',i);
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
        end
        %     calcBoxPlotsOfNormOneSubject(outDataNorm,leftOutSubjects(i),rootDirResults);
    end
end
fclose('all');
return
%% create a graph
rfxTbl = readtable('RFXSystematicInvest.txt');
rawffxTbl = readtable('FFXSystematicInvest.txt');
vosPassing = unique(rawffxTbl.voxelsPassing);


ffxTbl(idxs,:)
idxs = (ffxTbl.voxelsPassing==32025)


for j = 1:length(vosPassing)
    rawProps = rfxTbl.Properties
    PropsToPlot = rawProps.VariableNames(6:end)
    hFig = figure;
    idxs = (ffxTbl.voxelsPassing==vosPassing(j))
    ffxTbl = rawffxTbl(idxs,:);
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
end