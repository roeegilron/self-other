function plotFFXvsRFXrawAnsMatData()
close all 
clc
rootDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\FFXandRFX_current';
foldsToWorkOn = [30 31];
extractData = 0;
if extractData
    for i = 1:length(foldsToWorkOn)
        patSrc = sprintf('*cvFold%d*.mat',foldsToWorkOn(i));
        filesFound = findFilesBVQX(rootDir,patSrc);
        cnt = 1;
        for j = 1:length(filesFound)
            [pn,fn] = fileparts(filesFound{j});
            if ~isempty(strfind(fn,'FFX')); methodUsed = 'FFX';
            elseif ~isempty(strfind(fn,'RFX')); methodUsed = 'RFX';
            end
            load(filesFound{j});
            data(cnt).(methodUsed).MaxAcrossShuff = max(ansMat,[],1);
            data(cnt).(methodUsed).MaxVoxelWise = max(ansMat,[],2);
            data(cnt).(methodUsed).realData   = ansMat(:,1);
            data(cnt).(methodUsed).subsExtract = subsExtracted;
            data(cnt).(methodUsed).locations = locations;
            data(cnt).(methodUsed).mask = locations;
            data(cnt).(methodUsed).pVal = calcPvalVoxelWise(ansMat);
            data(cnt).(methodUsed).fold = foldsToWorkOn(i);
            clear ansMat;
        end
        cnt = cnt + 1;
    end
end
if exist('data','var')
    save('dataFromRFXvsFFX-30Kfolds.mat','data');
else
    load('dataFromRFXvsFFX-30Kfolds.mat');
end

%% plot the data
methodsUsed = fieldnames(data);
hFig = figure; cnt = 1;
set(hFig,'Position',[289          83        1271        1255]);
for i = 1:length(methodsUsed)
    %% plot raw p value
    subplot(3,2,cnt);cnt = cnt+1;
    numShuff = length(data.(methodsUsed{i}).MaxAcrossShuff)-1;
    pVal = sort(data.(methodsUsed{i}).pVal);
    plot(1:length(pVal),pVal)
    ttlstr = sprintf('%s %d subs, %d shuffs, %d voxels = min pval (%%%2.1f)',...
        methodsUsed{i},...
        size(data.(methodsUsed{i}).subsExtract,2),...
        numShuff,...
        sum(pVal==1/numShuff),...
        sum(pVal==1/numShuff)/size(data.(methodsUsed{i}).locations,1)*100);
    xlabel('voxel idx');
    ylabel('voxel wise p value');
    title(ttlstr);
    %% plot real data histogram vs max shuffle
    subplot(3,2,cnt);cnt = cnt+1;
    hold on;
    if methodsUsed{i} == 'FFX'; binW = 0.004;
    else binW = 0.2; end;
    histogram(data.(methodsUsed{i}).realData,'BinWidth',binW);
    histogram(data.(methodsUsed{i}).MaxVoxelWise,'BinWidth',binW);
    histogram(data.(methodsUsed{i}).MaxAcrossShuff,'BinWidth',binW);
    ttlstr = sprintf('%s %d subs, %d shuffs, real data vs max values of shuffs',...
        methodsUsed{i},...
        size(data.(methodsUsed{i}).subsExtract,2),...
        numShuff);
    xlabel('M&M T value');
    ylabel('count');
    title(ttlstr);
    legend({'real data','max voxelwise','max in each shuff'});
end

%% plot values passing diff stat methods and contirbutions
methodsUsed = fieldnames(data);
uniqSig = [0.05, 0.01];
statMethodsUsed = {'FDR','FWE'};%{'FDR','FWE'};
lblCnt = 1;
for z = 1:length(statMethodsUsed)
    for s = 1:length(uniqSig);
        for k = 1:length(methodsUsed)
            switch statMethodsUsed{z}
                case 'FWE'
                    maxVals = data.(methodsUsed{k}).MaxAcrossShuff(2:end);
                    maxVals = sort(maxVals);
                    idxUseCutOff = numShuff*(1-uniqSig(s));
                    cutOff = maxVals(idxUseCutOff);
                    idx2Pass = find(data.(methodsUsed{k}).realData>cutOff);
                    sigMap = zeros(size(data.(methodsUsed{k}).realData,1),1);
                    sigMap(idx2Pass) = 1;
                case 'FDR'
                    sigMap = fdr_bh(data.(methodsUsed{k}).pVal,uniqSig(s),'pdep','no');
                    sigMap = double(sigMap);
            end
            switch methodsUsed{k}
                case 'FFX'
                    rois.ffx = find(sigMap == 1);
                case 'RFX'
                    rois.rfx = find(sigMap == 1);
            end
        end
        rfxOnly = setdiff(rois.rfx,rois.ffx);
        ffxOnly = setdiff(rois.ffx,rois.rfx);
        commonV = intersect(rois.ffx,rois.rfx);
        roisOut(lblCnt).rfx = rfxOnly;
        roisOut(lblCnt).ffx = ffxOnly;
        roisOut(lblCnt).com = commonV;
        roisOut(lblCnt).cond = sprintf('%s %.2f',statMethodsUsed{z},uniqSig(s));
        xTickLabels{lblCnt} = sprintf('%s %.2f',statMethodsUsed{z},uniqSig(s)); 
        y(:,lblCnt) = [length(rfxOnly) length(ffxOnly) length(commonV)];
        lblCnt = lblCnt+1;
    end
end
subplot(3,2,cnt);cnt = cnt+1;
bar(y');
legend({'RFX only','FFX only','common Voxels'}); 
set(gca,'XtickLabel',xTickLabels)
ylabel('number of voxels'); 
title('number of voxels passing various sig. levels');

%% make new graphs of: 
% 1) FFX pavl vs. RFX pval over all sphere.



% 2) Plot of norm of mean versus mean of norms, with some (color?) encoding of FFX only, RFX only, or both. 

rootDirOriginalData = ...
    'F:\vocalDataSet\processedData\matFilesProcessedData\stats_normalized_sep_beta';
load(fullfile(rootDirOriginalData,'allSubsBetas.mat'),'mask','locations');
[normMap] = calcNormsOfLeftOutSubjects(allSubsData,leftOutSubjects,locations,labels);
end