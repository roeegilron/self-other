function analyzeRFXorFFXperformance()
fNamesToAnalyze = getFileNames('RussBaseData*_75*27-slSize*.mat');
createPairedRandHistogramRFXffx(fNamesToAnalyze)
[rawData] = getRawDelta();
fid = startFile();
for i = 1:length(fNamesToAnalyze)
    cvFoldData = getSigIdxsAndSubsUsed(fNamesToAnalyze{i},i);
    calcMeanSqrPerSubject(fid, cvFoldData,rawData);
end
tabulateResults()
tabulateResultsRFXffx()
close all;
end

function outfNs = getFileNames(pattern)
fNs = ...
    findFilesBVQX(fullfile(...
    pwd,'replicabilityAnalysis',pattern));
%% prune files with bug - only use one file from each cross val folds
% find files for each fold RFX and FFX 
cntffx = 1; cntrfx =1;
for j = 1:length(fNs)
    if ~isempty(regexp(fNs{j},'FFX'))
        ffxFn{cntffx} = fNs{j};
        cntffx = cntffx + 1;
    else
        rfxFn{cntrfx} = fNs{j};
        cntrfx = cntrfx + 1;
    end
end
% prune files ffx 
for j = 1:15 % loop on all folds
    for i = 1:length(ffxFn)% loop on all files
        if ~isempty(regexp(ffxFn{i},sprintf('cvFold%d',j)))
        ffxFnPrn{j} = ffxFn{i};
        end
    end
end

% prune files rfx 
for j = 1:15 % loop on all folds
    for i = 1:length(rfxFn)% loop on all files
        if ~isempty(regexp(rfxFn{i},sprintf('cvFold%d.mat',j)))
        rfxFnPrn{j} = rfxFn{i};
        end
    end
end

outfNs = [ffxFnPrn rfxFnPrn];


% print files found 
for i = 1:length(outfNs)
    [~,fp] = fileparts(outfNs{i});
    fprintf('[%d] %s\n',i,fp);
end

end

function cvFoldData = getSigIdxsAndSubsUsed(fn,mapNum)
cvFoldData.SigMap = [];
cvFoldData.SigIdx = [];
cvFoldData.SubsUsd = [];
a = regexp(regexp(fn,'cvFold[0-9]+','match'),'[0-9]+','match');
cvFold = str2num(a{1}{1});
load(fn,'ansMat','subsExtracted');
create95PercHistogram(ansMat,fn);
SigFDR = calcPvalVoxelWise(ansMat);
cvFoldData.SigMap = fdr_bh(SigFDR,0.1,'pdep','no');
cvFoldData.SigIdx = find(cvFoldData.SigMap ==1);
cvFoldData.SubsUsd = subsExtracted;
cvFoldData.mapNum = mapNum;
cvFoldData.cvFold = cvFold; 
[~,fp] = fileparts(fn);
cvFoldData.mapName = fp;
if ~isempty(regexp(fp,'FFX')) % file name should have FFX in it if FFX analysis
    cvFoldData.analysisType = 'FFX';
else
    cvFoldData.analysisType = 'RFX';
end

%% save pvals for later analysis 
pVal = SigFDR;
fNm = sprintf('pVal%s%d',cvFoldData.analysisType,cvFold);
eval([fNm ' = pVal']);
eval( [' save(''PvalsRFX-FFX.mat'',''' fNm ''',''-append'')']);

%% prin some infon on file 
fprintf('in map num %d there are %d voxels passing. time %s\n',...
    mapNum,sum(cvFoldData.SigMap),datestr(clock,0));
end

function fid = startFile()
fid = fopen(fullfile(...
        pwd,'replicabilityAnalysis',...
        'ReplicabiliyAnalysisFFXorRFX_Paired_correctFFX-001.txt'),'w+');
fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',...
    'analysisType',...
    'mapNum',...
    'mapName',...
    'subNum',...
    'cvFold',...
    'voxelPassing',...
    'meanSqr',...
    'meanAbs',...
    'medianAbs',...
    'sumAbs');
end

function calcMeanSqrPerSubject(fid,cvFoldData,rawData)
subsToTest = setxor(1:108,cvFoldData.SubsUsd);
for i = 1:length(subsToTest)
    meanSqr = sum( (rawData.deltaDat(subsToTest(i),cvFoldData.SigIdx)).^2);
    meanAbs = mean(abs(rawData.deltaDat(subsToTest(i),cvFoldData.SigIdx)));
    medianAbs = median(abs(rawData.deltaDat(subsToTest(i),cvFoldData.SigIdx)));
    sumAbs = sum(abs(rawData.deltaDat(subsToTest(i),cvFoldData.SigIdx)));
    if isempty(meanSqr)
        meanSqr = 0;
    end
    voxelsPassing = sum(cvFoldData.SigMap);
    fprintf(fid,'%s,%d,%s,%d,%d,%d,%f,%f,%f,%f\n',...
        cvFoldData.analysisType,...
        cvFoldData.mapNum + 8,...
        cvFoldData.mapName,...
        subsToTest(i),...
        cvFoldData.cvFold,...
        voxelsPassing,...
        meanSqr,...
        meanAbs,...
        medianAbs,...
        sumAbs);
end
end

function rawData = getRawDelta()
load('RussBaseData.mat','data','labels');
rawData.subjects = 1:108;
rawData.deltaDat = data(labels==1,:) - data(labels==2,:);
end

function tabulateResults()
fnTosv = 'ReplicabiliyAnalysisFFXorRFX_Paired_correctFFX-001.txt';
txtFn = fullfile(pwd,'replicabilityAnalysis',fnTosv);
[fp,~] = fileparts(txtFn);
if exist(txtFn,'file')
    t = readtable(txtFn);
    %% plot voxels passing:
    % group data based on RFX / FFX and Map num
    grpMnsTbl = varfun(@median,t,...
        'InputVariables','voxelPassing' ,...
        'GroupingVariables',{'analysisType','cvFold'},...
        'OutputFormat','table');
    hFig = figure;
    set(hFig,'Position',[574   -16   580   981])
    subplot(2,1,2)
    % get idx rfx ffx
    xIdxs = double(strcmp(grpMnsTbl.analysisType,'FFX'));
    xIdxs(xIdxs==0) = 2;
    notBoxPlot(grpMnsTbl.median_voxelPassing,xIdxs,[],'line')
    title('Voxel Declared Significan shuffels FFX / RFX');
    xlabel('Analysis Type')
    ylabel('Count of Sig. Voxels within ROI')
    set(gca,'XTickLabel',{'FFX','RFX'})
    subplot(2,1,1)
    boxplot(grpMnsTbl.median_voxelPassing,{grpMnsTbl.analysisType})
    title('Voxel Declared Significant Subjects FFX / RFX');
    xlabel('Analysis Type')
    ylabel('Count of Sig. Voxels within ROI')
    set(gca,'XTickLabel',{'FFX','RFX'})
    y1 = grpMnsTbl.median_voxelPassing(strcmp(grpMnsTbl.analysisType,'FFX'));
    y2 = grpMnsTbl.median_voxelPassing(strcmp(grpMnsTbl.analysisType,'RFX'));
    [h,pVal] = ttest(y1,y2);
    text(0.5,1,sprintf('p is %2.2f',pVal),'FontSize',12);
    saveas(hFig,fullfile(fp,'1_voxelsSig.jpeg'));
    
    %% plot mean sqr error individual subjects 
    % group data based on RFX / FFX and Map num
    grpMnsTbl = varfun(@median,t,...
        'InputVariables','meanSqr' ,...
        'GroupingVariables',{'analysisType','subNum','cvFold'},...
        'OutputFormat','table');
    hFig = figure;
    set(hFig,'Position',[574   -16   580   981])
    subplot(2,1,2)
    % get idx rfx ffx
    xIdxs = double(strcmp(grpMnsTbl.analysisType,'FFX'));
    xIdxs(xIdxs==0) = 2;
    notBoxPlot(grpMnsTbl.median_meanSqr,xIdxs,[],'line')
    title('Individual left out Subjects - Norm in ROI FFX / RFX');
    xlabel('Analysis Type')
    ylabel('Norm within ROI')
    set(gca,'XTickLabel',{'FFX','RFX'})
    subplot(2,1,1)
    boxplot(grpMnsTbl.median_meanSqr,{grpMnsTbl.analysisType})
    title('Box plot of Norm in individual ROIs FFX / RFX');
    xlabel('Analysis Type')
    ylabel('Norm within ROI')
    set(gca,'XTickLabel',{'FFX','RFX'})
    y1 = grpMnsTbl.median_meanSqr(strcmp(grpMnsTbl.analysisType,'FFX'));
    y2 = grpMnsTbl.median_meanSqr(strcmp(grpMnsTbl.analysisType,'RFX'));
    [h,pVal] = ttest(y1,y2);
    text(0.5,1,sprintf('p is %2.2f',pVal),'FontSize',12);
    saveas(hFig,fullfile(fp,'2_normIndiviSub.jpeg'));
    
    %% plot mean sqr error colllapsed on subjects
    % group data based on RFX / FFX and Map num
    grpMnsTbl = varfun(@median,t,...
        'InputVariables','meanSqr' ,...
        'GroupingVariables',{'analysisType','cvFold'},...
        'OutputFormat','table');
    hFig = figure;
    set(hFig,'Position',[574   -16   580   981])
    subplot(2,1,2)
    % get idx rfx ffx
    xIdxs = double(strcmp(grpMnsTbl.analysisType,'FFX'));
    xIdxs(xIdxs==0) = 2;
    notBoxPlot(grpMnsTbl.median_meanSqr,xIdxs,[],'line')
    title('Norm in ROI RFX / FFX (median over left out subjects / fold)');
    xlabel('Analysis Type')
    ylabel('Norm within ROI')
    set(gca,'XTickLabel',{'FFX','RFX'})
    subplot(2,1,1)
    boxplot(grpMnsTbl.median_meanSqr,{grpMnsTbl.analysisType})
    title('Norm ROIs - median over left out subjects in each fold');
    xlabel('Analysis Type')
    ylabel('Norm within ROI')
    set(gca,'XTickLabel',{'FFX','RFX'})
    y1 = grpMnsTbl.median_meanSqr(strcmp(grpMnsTbl.analysisType,'FFX'));
    y2 = grpMnsTbl.median_meanSqr(strcmp(grpMnsTbl.analysisType,'RFX'));
    [h,pVal] = ttest(y1,y2);
    text(0.5,1,sprintf('p is %2.5f',pVal),'FontSize',12);
    saveas(hFig,fullfile(fp,'3_normMedianOverLeftOutSub.jpeg'));
else
end
end

function tabulateResultsRFXffx()
fnTosv = 'ReplicabiliyAnalysisFFXorRFX_Paired_correctFFX-001.txt';
txtFn = fullfile(pwd,'replicabilityAnalysis',fnTosv);
t = readtable(txtFn);
[fp,~] = fileparts(txtFn);

%% plot voxels passing 
grpMnsTbl = varfun(@median,t,...
    'InputVariables','voxelPassing' ,...
    'GroupingVariables',{'analysisType','cvFold'},...
    'OutputFormat','table');
ffxTbl = grpMnsTbl(strcmp(grpMnsTbl.analysisType,'FFX'),:);
rfxTbl = grpMnsTbl(strcmp(grpMnsTbl.analysisType,'RFX'),:);

hFig = figure;
scatter(ffxTbl.median_voxelPassing,rfxTbl.median_voxelPassing)
hold on;
line([0 get(gca,'XLim')],[0 get(gca,'YLim')],'LineWidth',2)
title('Paird FFX / RFX - voxels passing'); 
xlabel('FFX Num Voxels Passing');
ylabel('RFX Num Voxels Passing');
saveas(hFig,fullfile(fp,'4_pairedVoxelsPassingMedianLeftOutSubsOverFolds.jpeg'));
%% norm - median across subjects 
grpMnsTbl = varfun(@median,t,...
    'InputVariables','meanSqr' ,...
    'GroupingVariables',{'analysisType','cvFold'},...
    'OutputFormat','table');
ffxTbl = grpMnsTbl(strcmp(grpMnsTbl.analysisType,'FFX'),:);
rfxTbl = grpMnsTbl(strcmp(grpMnsTbl.analysisType,'RFX'),:);
hFig = figure;
scatter(ffxTbl.median_meanSqr,rfxTbl.median_meanSqr)
hold on;
ylimNum = get(gca,'YLim');
ylimNum(1) = 0;
ylim(ylimNum);
line([0 get(gca,'XLim')],[0 get(gca,'YLim')],'LineWidth',2)
title('Median of paird FFX / RFX - Norm in ROI'); 
xlabel('FFX Norm ');
ylabel('RFX Norm ');
saveas(hFig,fullfile(fp,'5_pairedNormMedianLeftOutSubsOverFolds.jpeg'));
%% norm - median individual subjects 
grpMnsTbl = varfun(@median,t,...
    'InputVariables','meanSqr' ,...
    'GroupingVariables',{'analysisType','cvFold','subNum'},...
    'OutputFormat','table');
ffxTbl = grpMnsTbl(strcmp(grpMnsTbl.analysisType,'FFX'),:);
rfxTbl = grpMnsTbl(strcmp(grpMnsTbl.analysisType,'RFX'),:);
hFig = figure;
scatter(ffxTbl.median_meanSqr,rfxTbl.median_meanSqr)
hold on;
line([0 get(gca,'XLim')],[0 get(gca,'YLim')],'LineWidth',2)
title('Median of paird FFX / RFX Inidiviual Subjects- Norm in ROI'); 
xlabel('FFX Norm ');
ylabel('RFX Norm ');
saveas(hFig,fullfile(fp,'6_pairedNormMedianLeftOutSubsIndidvidual.jpeg'));

end

function create95PercHistogram(ansMat,fn)
if ~isempty(regexp(fn,'FFX'))
    expTyp = ' FFX';
else
    expTyp = ' RFX';
end
[pn, fp] = fileparts(fn);
sortedAnsMat = sort(ansMat(:,2:end),2);
% shuf histogram 
hFig = figure('visible','off');
histogram(sortedAnsMat(:,955))
ttl = ...
    sprintf('95%% T cut-off across all voxels in the brain (max = %2.2f)',...
    max(sortedAnsMat(:,955)));
ttl = [ttl expTyp];
title(ttl)
xlabel('T stat (muni-meng)');
ylabel('voxel count'); 
saveas(hFig,fullfile(pn,'images_RFX_FFX',['1_' fp  '_shuff.jpeg']))
close(hFig);

% shuf histogram max
hFig = figure('visible','off');
histogram(max(ansMat(:,2:end),[],2))
ttl = ...
    sprintf('Max T voxel wise cross all voxels in the brain (max = %2.2f)',...
    max(max(ansMat(:,2:end),[],2)));
ttl = [ttl expTyp];
title(ttl)
xlabel('T stat (muni-meng)');
ylabel('voxel count'); 
saveas(hFig,fullfile(pn,'images_RFX_FFX',['2_' fp  '_shuff.jpeg']))
close(hFig);

% real histogram 
hFig = figure('visible','off');
histogram(ansMat(:,1))
ttl = ...
    sprintf('real data map across all voxels in the brain (max = %2.2f)',...
    max(ansMat(:,1)));
ttl = [ttl expTyp];
title(ttl)
xlabel('T stat (muni-meng)');
ylabel('voxel count'); 
saveas(hFig,fullfile(pn,'images_RFX_FFX',['3_' fp  '_real.jpeg']))
close(hFig);
% real compared to shuf 
hFig = figure('visible','off');
hold on 
histogram(sortedAnsMat(:,955))
histogram(ansMat(:,1))
ttl = ...
    sprintf('real vs shuff');
ttl = [ttl expTyp];
title(ttl)
xlabel('T stat (muni-meng)');
ylabel('voxel count'); 
legend({'shuff 95% T','real'})
saveas(hFig,fullfile(pn,'images_RFX_FFX',['4_' fp  '_realvsshuff.jpeg']))
close(hFig);
end

function createPairedRandHistogramRFXffx(fNames)
foundFile = {};
% for i = 1:15 % loop on folds
%     cnt = 1 ; 
%     fold = i;
%     for j = 1:30 % loop on files     
%         if ~isempty(regexp(fNames{j},sprintf('cvFold%d',fold),'once'))
%             foundFile{cnt} = fNames{j};
%             cnt = cnt + 1;
%         end
%     end
%     fprintf('pair found:\n')
%     for k = 1:length(foundFile)
%         [pn,fn] = fileparts(foundFile{k});
%         fprintf('[%d] %s\n',k,fn);
%     end
%     clear foundFile
% end
for i = 1:15 
    outFile{i,1} = fNames{i};
    outFile{i,2} = fNames{i+15};
end
for j = 1:length(outFile)
    fprintf('pair found:\n');
    [~,ff] = fileparts(outFile{j,1});
    fprintf('[%d] FFX = %s\n',j,ff);
    [~,ff] = fileparts(outFile{j,2});
    fprintf('[%d] RFX = %s\n\n',j,ff);
end

end