function calcReplicabilityPrevelance()
p = genpath('D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX');
addpath(p);
close all
dataFolder = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\ffxNotZscoredVocalDataSet_1000_shufs\';
dataFolder  = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\ffxNotZscored_VocalData_Set1000_Shufs_9slsize_not_smoothed';
vmpname = 'ffxNotZscored_VocalData_Set1000_Shufs_9slsize_not_smoothed';
% load(fullfile(dataFolder,'prevData.mat'),'prevData');
load(fullfile(dataFolder,'prevData_9slsize_unsmoothed.mat'),'prevData');

resultsFolder = dataFolder;%'D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX\matlabCode\atlasLabels';
rng(1);
randSubs = randperm(150,20);
allPvals = [prevData.pvals];
rng(1);
randSubs = randperm(150,20); % XXXXXXXXXXXXXXXXXX choose subset of subjects) 
% allPvals = allPvals(:,randSubs);
n = size(allPvals,2); 
u = floor(0.125 *n);
df = 2 * (n-u+1);

% sum of pvals. 
Ps = [];
for i = 1:size(allPvals,1)
    pvals = allPvals(i,:);
    sortpvals = sort(pvals);
    upvals = sortpvals(u:end);
    upvalslog = log(upvals) * (-2);
    sumus = sum(upvalslog);
    Ps(i) = chi2cdf(sumus,df,'upper');
end
% for i = 1:size(allPvals,2); 
%     [pvalsecond(i), ~] = chi2gof(
% end

%% plot vmp of sig. voxels: 
sigfdr = fdr_bh(Ps,0.05,'pdep','yes'); 
ff = findFilesBVQX(dataFolder,'*.mat');
mfo = matfile(ff{2});
mask = mfo.mask;
locations = mfo.locations;
ansMat = double(sigfdr)';
dataFromAnsMatBackIn3d = scoringToMatrix(mask,ansMat,locations);
dumynii = 'D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX\matlabCode\atlasLabels\HarvardOxford-cort-maxprob-thr0-1mm.nii';
n = neuroelf;
vmpout = n.importvmpfromspms(dumynii,'a',[],3);
vmpout.Map.VMPData = dataFromAnsMatBackIn3d;
vmpout.Map.Name = [vmpname ];

vmpout.SaveAs(fullfile(dataFolder,[vmpname '.vmp']));
%% graph p values in brain of 20 sample subjects: 
rng(1);
randSubs = randperm(150,20);
hfig = figure; 
hfig.Position = [1          41        2560        1323];
hold off;
for i = 1:20
    hplots(i) = subplot(5,4,i); 
    histogram(allPvals(:,randSubs(i)));
    
       h= histogram(allPvals(:,randSubs(i)),30,...
        'DisplayStyle','stairs',...
        'Normalization','probability');
    h.BinWidth = 0.02;
    
    n = 6;
    xs = h.BinEdges(1:end-1)+h.BinWidth/2;
    ys = h.Values;
    xs = [0 xs 1];
    ys = [0 ys 0];
    yspoly = polyfit(xs,ys,n);
    
    x1 = linspace(0,1-0.01,200);
    y1 = polyval(yspoly,x1);
    plot(x1,y1);
    y= y1;
    x = x1;
    basey = min(0,min(y1));
    h = fill([x x(end) x(1)], [y basey basey], [1 0 0]);
    set(h, 'EdgeColor','none', 'FaceAlpha', 0.45);
    ylim([0,max(y)]);
    maxsys(i) = max(y);
    
    % give titels
    ttlstr = sprintf('All pvals in brain, sub %3d',randSubs(i));
    title(ttlstr);
    ylabel('prob (%) of pval');
    xlabel('p-value');
end
% scale plots
for j = 1:length(hplots)
    set(hplots(j),'YLim',[0 max(maxsys)+0.0001])
end
suptitle('FA p-values distribute differently across subjects');
% print picutre
hfig.PaperPositionMode = 'auto';
% hfig.PaperOrientation = 'landscape';
% hfig.PaperUnits = 'inches';
% hfig.PaperPosition = [0 0 11.5 8];
figname = sprintf('FApvals_acrossBrain_InSubjects.pdf');
print(fullfile(resultsFolder,figname),'-dpdf','-r150','-painters')

%% graph p values in some random voxels across subjects 
rng(1);
randVoxels = randperm(size(allPvals,1),20);
hfig = figure; 
hfig.Position = [1          41        2560        1323];
hold off;
for i = 1:20
    hplots(i) = subplot(5,4,i); 
    
    h = histogram(allPvals(randVoxels(i),:),50,...
        'DisplayStyle','stairs');%,...
%         'Normalization','probability');
%     h.BinWidth = 1;
    
%     n = 6;
%     xs = h.BinEdges(1:end-1)+h.BinWidth/2;
%     ys = h.Values;
%     xs = [0 xs 1];
%     ys = [0 ys 0];
%     yspoly = polyfit(xs,ys,n);
%     
%     x1 = linspace(0,1-0.01,200);
%     y1 = polyval(yspoly,x1);
%     plot(x1,y1);
%     y= y1;
%     x = x1;
%     basey = min(0,min(y1));
%     h = fill([x x(end) x(1)], [y basey basey], [1 0 0]);
%     set(h, 'EdgeColor','none', 'FaceAlpha', 0.45);
%     ylim([0,max(y)]);
%     maxsys(i) = max(y);
    
    % give titels
    ttlstr = sprintf('Pvals in voxel %d across 150 subs',randVoxels(i));
    title(ttlstr);
    ylabel('# of subjects');
    xlabel('p-value');
    set(gca,'XTick',0:0.1:1);
end
% scale plots
for j = 1:length(hplots)
    hplots(j).YLim
    set(hplots(j),'YLim',[0 max([hplots.YLim])+0.0001])
end
suptitle('FA p-values in specific voxels across subjects');
% print picutre
hfig.PaperPositionMode = 'auto';
% hfig.PaperOrientation = 'landscape';
% hfig.PaperUnits = 'inches';
% hfig.PaperPosition = [0 0 11.5 8];
figname = sprintf('FApvals_inVoxels_AcorssSubs.pdf');
print(fullfile(resultsFolder,figname),'-dpdf','-r150','-painters')
        
    
x=2;

% chi2gof(
% n <- 20
% pvals <- runif(n)
% u <- 0.2 * n
% 
% # under the null
% pvals.sorted <- sort(pvals)[1:u]
% number <- -2*sum(log(pvals.sorted))
% df <- 2*(n-u+1)
% pvalue.voxel <- pchisq(number, df, lower.tail = FALSE)
% 
% # under the alternative
% pvals.sorted.2 <- pvals.sorted^4
% number.2 <- -2*sum(log(pvals.sorted.2))
% pvalue.voxel <- pchisq(number.2, df, lower.tail = FALSE)
% 
% prevalence <- u/n