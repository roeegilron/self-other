rootDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\FFXandRFX_current';
rootDir = pwd;
%% directional
clc
alpha = 0.05;
stat = 'FDR';
cvFold = 21;
numSubs = 20;
slsize = 9;
suprttile = sprintf('Directional - %d subs, 1000 shufels, FDR %1.2f fold %d %d slsize',...
    numSubs,alpha,cvFold, slsize);
%% calc norm maps for subs that exist in this fold
fnsavenorms = sprintf('normsMapsForSubsFromFold%d_slsize9.mat',cvFold);
if ~exist(fnsavenorms,'file')
    rootDirOriginalData = ...
        'F:\vocalDataSet\processedData\matFilesProcessedData\stats_normalized_sep_beta';
    load(fullfile(rootDirOriginalData,'allSubsBetas.mat'),'allSubsData','labels','locations');
    fn = sprintf('precomputed_Directional_FFX_Data_%d-subs_1000-shufs_cvFold%d.mat',...
        numSubs,cvFold);
    load(fullfile(rootDir,fn),'subsExtracted');
    
    
    normMaps = calcNormsOfLeftOutSubjects(allSubsData,subsExtracted,locations,labels);
    save(fnsavenorms,'normMaps');
else
    load(fnsavenorms)
end


%% FFX
% vocalDataSetDirectionalFFX_20subs_1000-shufs_9-slsize_cvFold21_TvalsBench_.mat
fntoloadffx = sprintf('vocalDataSetDirectionalFFX_%dsubs_1000-shufs_9-slsize_cvFold%d_TvalsBench_.mat',...
    numSubs,cvFold);
load(fullfile(rootDir,fntoloadffx),'ansMat');
ansMatFFX = ansMat;
pValFFX = calcPvalVoxelWise(squeeze(ansMatFFX(:,:,1)));
[sigMapFFX, cutoffpffx] = fdr_bh(pValFFX,alpha,'pdep','no');
roiIdxsFFX = find(sigMapFFX == 1);
fprintf('sum FFX %d cutt off p %f\n',sum(sigMapFFX),cutoffpffx);

%% RFX
%results_precomputed_uniformsubsflipped_Directional_RFX_Data_20-subs_1000-shufs_cvFold20.mat
% %results_20-subs_9-slSize_cvFold21WithSvmResults_RFX_Tbecnhes20150909T001935.mat
% results_precomputed_fixedshufflabels_Directional_RFX_Data_20-subs_1000-shufs_cvFold20.mat
fntoloadrfx = sprintf('results_%d-subs_9-slSize_cvFold%dWithSvmResults_RFX_Tbecnhes20150909T001935.mat',...
    numSubs,cvFold);
load(fullfile(rootDir,fntoloadrfx),'ansMat');
ansMatRFX = ansMat;
pValRFX = calcPvalVoxelWise(squeeze(ansMatRFX(:,:,1)));
[sigMapRFX, cutoffprfx] = fdr_bh(pValRFX,alpha,'pdep','no');
roiIdxsRFX = find(sigMapRFX == 1);
fprintf('sum RFX %d cutt off p %f\n',sum(sigMapRFX),cutoffprfx);

sum(ansMatFFX(:,1,1)==ansMatRFX(:,1,1))

%% create some figures:
% sbpltx = 4; sbplty = 4;

%% real data
%subplot(sbpltx,sbplty,1);
figure;
set(gcf,'Position',[501          88        1075         812]);
annotation(gcf,'textbox',...
    [0.249496993987975 0.962546816479401 0.543088176352706 0.0243445692883897],...
    'String',suprttile,'FitBoxToText','off');
hold on;
histogram(ansMatRFX(:,1),'BinWidth',0.1,'DisplayStyle','stairs');
histogram(ansMatFFX(:,1),'BinWidth',0.1,'DisplayStyle','stairs');
legend('RFX','FFX');
title('real data T values');
ylabel('count');
xlabel('M&M value');

%% bar graph of voxels passing
% subplot(sbpltx,sbplty,2);
figure;
set(gcf,'Position',[501          88        1075         812]);
annotation(gcf,'textbox',...
    [0.249496993987975 0.962546816479401 0.543088176352706 0.0243445692883897],...
    'String',suprttile,'FitBoxToText','off');
bar([sum(sigMapRFX),sum(sigMapFFX)])
title('voxels passing signficance ');
ylabel('count of voxels passing');
rfxlabel = sprintf('RFX (%d)',sum(sigMapRFX));
ffxlabel = sprintf('FFX (%d)',sum(sigMapFFX));
set(gca,'XTickLabel',{rfxlabel,ffxlabel});

%% max values of shuffle
% subplot(sbpltx,sbplty,3);
figure;
set(gcf,'Position',[501          88        1075         812]);
annotation(gcf,'textbox',...
    [0.249496993987975 0.962546816479401 0.543088176352706 0.0243445692883897],...
    'String',suprttile,'FitBoxToText','off');
hold on;
maxValsRFX  = max(ansMatRFX(:,2:end),[],2);
maxValsFFX  = max(ansMatFFX(:,2:end),[],2);
histogram(maxValsRFX,'BinWidth',5,'DisplayStyle','bar');
histogram(maxValsFFX,'BinWidth',5,'DisplayStyle','bar');
legend('RFX','FFX');
title('max  values across shuffels');
ylabel('count');
xlabel('M&M value');

%% median value of shuffle
% subplot(sbpltx,sbplty,4);
figure;
set(gcf,'Position',[501          88        1075         812]);
annotation(gcf,'textbox',...
    [0.249496993987975 0.962546816479401 0.543088176352706 0.0243445692883897],...
    'String',suprttile,'FitBoxToText','off');
hold on;
maxValsRFX  = median(ansMatRFX(:,2:end),2);
maxValsFFX  = median(ansMatFFX(:,2:end),2);
histogram(maxValsRFX,'BinWidth',0.2,'DisplayStyle','bar');
histogram(maxValsFFX,'BinWidth',0.2,'DisplayStyle','bar');
legend('RFX','FFX');
title('median  values across shuffels');
ylabel('count');
xlabel('M&M value');

%% sorted p value of shuffle
% subplot(sbpltx,sbplty,5);
figure;
set(gcf,'Position',[501          88        1075         812]);
annotation(gcf,'textbox',...
    [0.249496993987975 0.962546816479401 0.543088176352706 0.0243445692883897],...
    'String',suprttile,'FitBoxToText','off');
hold on;
% sort via RFX
[pvalsrfx, idx] = sort(pValRFX);
pvalsffx = pValFFX(idx);

% sort via FFX
[pvalsffx, idx] = sort(pValFFX);
pvalsrfx = pValRFX(idx);

plot(1:length(pValRFX),pvalsrfx,'LineWidth',3)
plot(1:length(pValRFX),pvalsffx,'LineWidth',3)
legend('RFX','FFX');
title('sorted  p values');
ylabel('p value');
xlabel('voxel idx');

%% num of min p values in shuffle
% subplot(sbpltx,sbplty,6);
figure;
set(gcf,'Position',[501          88        1075         812]);
annotation(gcf,'textbox',...
    [0.249496993987975 0.962546816479401 0.543088176352706 0.0243445692883897],...
    'String',suprttile,'FitBoxToText','off');
bar([sum(pValRFX==0.001),sum(pValFFX==0.001)])
title('num of min p values');
ylabel('count of voxels passing');

rfxlabel = sprintf('RFX (%d) cut off p = %f',sum(pValRFX==0.001),cutoffprfx);
ffxlabel = sprintf('FFX (%d) cut off p = %f',sum(pValFFX==0.001),cutoffpffx);
set(gca,'XTickLabel',{rfxlabel,ffxlabel})

%% num of min p values in shuffle
% subplot(sbpltx,sbplty,7);
figure;
set(gcf,'Position',[501          88        1075         812]);
annotation(gcf,'textbox',...
    [0.249496993987975 0.962546816479401 0.543088176352706 0.0243445692883897],...
    'String',suprttile,'FitBoxToText','off');
hold on;
scatter(pValRFX,pValFFX)
title('scatter plot of FFX vs RFX pvals');
ylabel('ffx p vals');
xlabel('rfx p vals');
plot([0 1],[0 1],'LineWidth',3)

%% scatter plot of hotteling
% subplot(sbpltx,sbplty,8);
figure;
set(gcf,'Position',[501          88        1075         812]);
annotation(gcf,'textbox',...
    [0.249496993987975 0.962546816479401 0.543088176352706 0.0243445692883897],...
    'String',suprttile,'FitBoxToText','off');
hold on;
scatter(squeeze(ansMatRFX(:,1,5)),squeeze(ansMatFFX(:,1,5)))
title('scatter plot of hotteling FFX vs RFX pvals real');
ylabel('ffx t vals');
xlabel('rfx t vals');
plot([0 1],[0 1],'LineWidth',3)

%% scatter plot of norm
% subplot(sbpltx,sbplty,9);
figure;
set(gcf,'Position',[501          88        1075         812]);
annotation(gcf,'textbox',...
    [0.249496993987975 0.962546816479401 0.543088176352706 0.0243445692883897],...
    'String',suprttile,'FitBoxToText','off');
hold on;
scatter(squeeze(ansMatRFX(:,1,7)),squeeze(ansMatFFX(:,1,7)))
title('scatter plot of norm FFX vs RFX pvals real');
ylabel('ffx norm');
xlabel('rfx norm');
plot([0 1],[0 1],'LineWidth',3)

%% the max determin of the covariance
figure;
set(gcf,'Position',[501          88        1075         812]);
annotation(gcf,'textbox',...
    [0.249496993987975 0.962546816479401 0.543088176352706 0.0243445692883897],...
    'String',suprttile,'FitBoxToText','off');
hold on;
maxValsDetRFX  = max(squeeze(ansMatRFX(:,2:end,6)),[],2);
maxValsDetFFX  = max(squeeze(ansMatFFX(:,2:end,6)),[],2);
histogram(maxValsDetRFX,'BinWidth',3,'DisplayStyle','bar');
histogram(maxValsDetFFX,'BinWidth',3,'DisplayStyle','bar');
legend('RFX','FFX');
title('max  log of determinent across shuffels');
ylabel('count');
xlabel('determinent');


%% the median determin of the covariance
figure;
set(gcf,'Position',[501          88        1075         812]);
annotation(gcf,'textbox',...
    [0.249496993987975 0.962546816479401 0.543088176352706 0.0243445692883897],...
    'String',suprttile,'FitBoxToText','off');
hold on;
medianValsRFX  = median(squeeze(ansMatRFX(:,2:end,6)),2);
medianValsFFX  = median(squeeze(ansMatFFX(:,2:end,6)),2);
histogram(medianValsRFX,'BinWidth',0.8,'DisplayStyle','bar');
histogram(medianValsFFX,'BinWidth',0.8,'DisplayStyle','bar');
legend('RFX','FFX');
title('median  log of determinent across shuffels');
ylabel('count');
xlabel('M&M value');




%% looking at histgoram of one voxels
figure;
set(gcf,'Position',[501          88        1075         812]);
annotation(gcf,'textbox',...
    [0.249496993987975 0.962546816479401 0.543088176352706 0.0243445692883897],...
    'String',suprttile,'FitBoxToText','off');
hold on;
medianValsRFX  = squeeze(ansMatRFX(20548,2:end,6));
medianValsFFX  = squeeze(ansMatFFX(20548,2:end,6));
histogram(medianValsRFX,'BinWidth',0.3,'DisplayStyle','bar');
histogram(medianValsFFX,'BinWidth',0.3,'DisplayStyle','bar');
legend('RFX','FFX');
title('one voxel ffx vs rfx log of determinant');
ylabel('count');
xlabel('M&M value');

%% looking at denominator of muni meng
figure;
set(gcf,'Position',[501          88        1075         812]);
annotation(gcf,'textbox',...
    [0.249496993987975 0.962546816479401 0.543088176352706 0.0243445692883897],...
    'String',suprttile,'FitBoxToText','off');
hold on;
medianValsRFX  = squeeze(ansMatRFX(20548,2:end,3));
medianValsFFX  = squeeze(ansMatFFX(20548,2:end,3));
histogram(medianValsRFX,'BinWidth',0.3,'DisplayStyle','bar');
histogram(medianValsFFX,'BinWidth',0.3,'DisplayStyle','bar');
legend('RFX','FFX');
title('one voxel ffx vs rfx denominator m&m');
ylabel('count');
xlabel('M&M value');

%% plot directional norm.
figure;
set(gcf,'Position',[501          88        1075         812]);
annotation(gcf,'textbox',...
    [0.249496993987975 0.962546816479401 0.543088176352706 0.0243445692883897],...
    'String',suprttile,'FitBoxToText','off');
rfxnorm = mean(normMaps.RFX(roiIdxsRFX));
ffxnorm = mean(normMaps.RFX(roiIdxsFFX));
bar([rfxnorm,ffxnorm])
title('mean of ''norm of means'' benchmark within rfx / ffx roi');
ylabel('mean of norm of means within roi');
rfxlabel = sprintf('RFX (%d)',length(roiIdxsRFX));
ffxlabel = sprintf('FFX (%d)',length(roiIdxsFFX));
set(gca,'XTickLabel',{rfxlabel,ffxlabel})



% running through all my numbers
annotation(gcf,'textbox',...
    [0.249496993987975 0.962546816479401 0.543088176352706 0.0243445692883897],...
    'String',suprttile,'FitBoxToText','off');
ttls = {'M&M','num M&M','denom M&M','demp','hot','det','norm'};
voxelToPlot = 70;
for i = 1%:7
    figure;
    set(gcf,'Position',[501          88        1075         812]);
    annotation(gcf,'textbox',...
        [0.249496993987975 0.962546816479401 0.543088176352706 0.0243445692883897],...
        'String',suprttile,'FitBoxToText','off');
    hold on;
    medianValsRFX  = squeeze(ansMatRFX(voxelToPlot,2:end,i));
    medianValsFFX  = squeeze(ansMatFFX(voxelToPlot,2:end,i));
    histogram(medianValsRFX,'BinWidth',0.5,'DisplayStyle','bar');
    histogram(medianValsFFX,'BinWidth',0.5,'DisplayStyle','bar');
    legend('RFX','FFX');
    title(sprintf('one voxel (idx %d)- %s',voxelToPlot,ttls{i}));
    ylabel('count');
    xlabel(ttls{i});
end

%% rfx vs ffx 
    figure;
    set(gcf,'Position',[501          88        1075         812]);
    annotation(gcf,'textbox',...
        [0.249496993987975 0.962546816479401 0.543088176352706 0.0243445692883897],...
        'String',suprttile,'FitBoxToText','off');
    hold on;

    mandmRFX  = sort(squeeze(ansMatRFX(:,2:end,1)),2);
    mandmFFX  = sort(squeeze(ansMatFFX(:,2:end,1)),2);
    mandmRFX5perc = mandmRFX(:,950);
    mandmFFX5perc = mandmFFX(:,950);
    histogram(mandmRFX5perc,'BinWidth',0.05,'DisplayStyle','bar');
    histogram(mandmFFX5perc,'BinWidth',0.05,'DisplayStyle','bar');
        legend('RFX','FFX');
    title('95 percent m&m');
    ylabel('count');
    xlabel('95 psercteinail manm');
    figure;
    hold on;
    scatter(mandmFFX5perc,mandmRFX5perc)
    xlabel('FFX m&m 95 perc');
    ylabel('RFX m&m 95 perc');
    set(gca,'XLim',[0.5 2.5]);
    set(gca,'YLim',[0.5 2.5]);
    plot([0.5 2.5],[0.5 2.5],'k','LineWidth',3)
    

x=2;

