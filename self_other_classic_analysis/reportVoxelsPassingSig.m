function reportVoxelsPassingSig()
rootDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\FFXandRFX_files_readyForanalysis';
fileToAnalyze{1,1} = 'VocalDataSet_results_20-subs_27-slSize_cvFold30_RFX_zscored_20150819T090227.mat'; % i = 1 = 20 subs , i = 2 = 75 sybs 
fileToAnalyze{1,2} = 'VocalDataSet_results_20-subs_27-slSize_cvFold30_FFXstlzrstyleNoZeroingNaN.mat'; % j = 1 = RFX  j = 2 = FFX 

fileToAnalyze{2,1} = 'VocalDataSet_results_75-subs_27-slSize_cvFold20_RFX_zscored_20150818T165304.mat';
fileToAnalyze{2,2} = 'VocalDataSet_results_75-subs_27-slSize_cvFold20_FFXstlzrstyleNoZeroingNaN.mat';
for i = 1:size(fileToAnalyze,1) % loop on subjs used
    for j = 1:size(fileToAnalyze,1) % loop on method used(RFX / FFX 
        load(fullfile(rootDir,fileToAnalyze{i,j}),'ansMat')
        ansMatBig{i,j} = ansMat;
        clear ansMat
    end
end
methodsUsed = {'FDR'};%{'FDR','FWE'}; 
SigLevel = [0.0001 0.001 0.01, 0.05, 0.1, 0.2, 0.3];
TypeOfAnalysis = {'20subs', '75subs'};
InferenceMet = {'RFX','FFX'};
% hFig = figure;
cnt = 1; cntDt =1;
for i = 1:length(methodsUsed)
    for j = 1:length(SigLevel)
        for k = 1:length(TypeOfAnalysis)
            for z = 1:length(InferenceMet)
                dataOut.statMethod{cntDt,1} = TypeOfAnalysis{k};
                dataOut.cutOffVal(cntDt,1)  = SigLevel(j);
                fold = 20;
                sigMap = ...
                    calcAnsMatSig(ansMatBig{k,z},methodsUsed{i},SigLevel(j));
                pVals = calcPvalVoxelWise(ansMatBig{k,z});
                pValsBig{k,z} = pVals;
                voxelPassing(z) = sum(sigMap);
                dataOut.vxlsPassing(cntDt,1) = voxelPassing(z);
                dataOut.InferenceMet{cntDt,1} = InferenceMet{z};
                dataOut.NumMinPval(cntDt,1) = sum(pVals==0.001);
                dataOut.NumMinPvalInSigMap(cntDt,1) = sum(sigMap(find(pVals==0.001)));
                cntDt = cntDt +1;
            end
%             subplot(2,6,cnt)
%             ttlStr = sprintf('%s %f %s',...
%                 methodsUsed{i},SigLevel(j),TypeOfAnalysis{k});
%             bar(voxelPassing,0.5)
%             set(gca,'XTickLabels',InferenceMet)
%             title(ttlStr);
%             cnt = cnt + 1;
        end
    end
end
%% plot p vals histogram 
cnt =1;
figure;
for i = 1:2 
    for j = 1:2
        if i == 1; subC = 20; else subC = 75; end;
        if j == 1; meT = 'RFX'; else meT = 'FFX'; end;
        ttlStr = sprintf('Pval Histogram %d subs - %s',subC,meT);
        subplot(2,2,cnt)
        cnt = cnt + 1;
        histogram(pValsBig{i,j})
        title(ttlStr);
        xlabel('p value')
        ylabel('count')
        if i == 1 
            set(gca,'YLim',[0 11e3]);
        else
            set(gca,'YLim',[0 11e3]);
        end
        
    end
end

%% plot p vals sorted  
cnt =1;
figure;
for i = 1:2 
    for j = 1:2
        if i == 1; subC = 20; else subC = 75; end;
        if j == 1; meT = 'RFX'; else meT = 'FFX'; end;
        ttlStr = sprintf('Pval Histogram %d subs - %s',subC,meT);
        subplot(2,2,cnt)
        cnt = cnt + 1;
        plot(sort(pValsBig{i,j}),1:length(pValsBig{i,j}),...
            'LineWidth',5)
        set(gca,'XLim',[0 m(pValsBig{i,j})])
        title(ttlStr);
        xlabel('p value')
        ylabel('count')
%         if i == 1 
%             set(gca,'YLim',[0 2e4]);
%         else
%             set(gca,'YLim',[0 2e4]);
%         end
        
    end
end

%% plot voxels passing 
tblrslts = struct2table(dataOut);
subsOut = {'20subs','75subs'};
hFig = figure;
cnt = 1;
for i = 1:length(subsOut) % loop on subs 
    tmptbl = tblrslts(strcmp(tblrslts.statMethod,subsOut{i}),:);
    uniqSig = unique(tmptbl.cutOffVal);
    idxsrfx = find(strcmp(tmptbl.InferenceMet,'RFX')==1);
    idxsffx = find(strcmp(tmptbl.InferenceMet,'FFX')==1);
    tmp2 = tmptbl(idxsrfx,:);
    tmp3 = tmptbl(idxsffx,:);
    y(:,1) = tmp2.vxlsPassing; % RFX 
    y(:,2) = tmp3.vxlsPassing; % FFX 
    subplot(2,2,cnt);
    cnt = cnt + 1;
    bar(y)
    legend({'RFX','FFX'})
    set(gca,'XtickLabel',uniqSig)
    title(sprintf('Voxels Passing at various FDR Sig''s %s',subsOut{i}))
    ylabel('Number of Voxels Passing');
    xlabel('FDR alpha value')
    ylimVal = get(gca,'YLim');
    subplot(2,2,cnt);
    cnt = cnt + 1;
    y(:,1) = tmp2.NumMinPvalInSigMap; % RFX
    y(:,2) = tmp3.NumMinPvalInSigMap; % FFX

    bar(y)
    set(gca,'YLim',ylimVal);
    legend({'RFX','FFX'})
    set(gca,'XtickLabel',uniqSig)
    title(sprintf('Number of Min P values in Sig Map %s',subsOut{i}))
    ylabel('Number of Min P values');
    xlabel('FDR alpha value')
end

end