%% code to visualize all thep problems I have with the new and old analysis. 
resdir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\DirectionalVsNondirectionalFFX';

% old analysis file:
oldf = 'Nondirection_FFX_vocalDataset_20-subs_27-slsize_21-cvFold_1000-shuf.mat';
newf = 'VocalDataSet_results_20-subs_27-slSize_cvFold1_FFX_newT2013_notstelzer.mat';

% load old f 
load(fullfile(resdir,oldf),'ansMat');
oldanalysisrealt = squeeze(ansMat(:,1,1));
pvalold = calcPvalVoxelWise(squeeze(ansMat(:,:,1)));
sigfdrold =fdr_bh(pvalold,0.05,'pdep','yes'); 
clear ansMat

%load new f 
load(fullfile(resdir,newf),'ansMatOld');
newanalysisrealt = double(squeeze(ansMatOld(:,1,1)));
pvalnew= calcPvalVoxelWise(squeeze(ansMatOld(:,:,1)));
sigfdrnew =fdr_bh(pvalnew,0.05,'pdep','yes'); 
clear ansMatOld

% set up figure 
figure;
nr = 2; nc = 2; 
% plot real data vs real data 
subplot(nr,nc,1); 
scatter(oldanalysisrealt,newanalysisrealt);
xlabel('old analysis t');
ylabel('new analysis t'); 
rval = corrcoef([oldanalysisrealt,newanalysisrealt],'rows','pairwise');
ttlstr = sprintf('T2008 new (%d) vs T 2008 old (%d) corr %.2f',...
    sum(sigfdrnew),...
    sum(sigfdrold),...
    rval(1,2));
title(ttlstr);

%pval old analyis 
subplot(nr,nc,2); 
histogram(pvalold);
title('pvals old analysis');

%pval new analysis 
subplot(nr,nc,3); 
histogram(pvalnew);
title('pvals new analysis');


% sorted pvals new vs old 
subplot(nr,nc,4); 
hold on;
plot(sort(pvalold),1:length(pvalold));
plot(sort(pvalnew),1:length(pvalnew));
title('pvals old and new');
legend({'old','new'});


%% loop on 20 subjects from fold 21 and calc voxels passing in each subject. 
newdatdir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\results_VocalDataSet_FFX_ND_norm_1000_shufs_SL27';
olddatdir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\ffxNotZscoredVocalDataSet';
newfnpattern ='results_vocalDataSet_FFX_ND_norm_1000_shuf_SL27_sub_001.mat20160126T212413';
olddatapattrn = 'stats_normalized_sep_beta_s001_FFX_results_SLsize27_20150913T102942';
subscheck = getSubsUsedInFold(20); 

for i = subscheck % loop on subs 
    % old 
    ff = findFilesBVQX(olddatdir,sprintf('*s%.3d*.mat',i));
    load(ff{1},'ansMat');
    pvalold = calcPvalVoxelWise(squeeze(ansMat(:,:,1)));
    sigfdrold =fdr_bh(pvalold,0.1,'pdep','no');
    % new
    ff = findFilesBVQX(newdatdir,sprintf('*sub_%.3d*.mat',i));
    load(ff{1},'ansMatOld');
    pvalnew = calcPvalVoxelWise(squeeze(ansMatOld(:,:,1)));
    sigfdrnew =fdr_bh(pvalold,0.1,'pdep','no');
    fprintf('sub %.3d old (%d) new (%d)\n',i,...
        sum(sigfdrold),sum(sigfdrnew));
    
    %real data vs real data
    figure;
    newanalysisrealt = double(squeeze(ansMatOld(:,1,1)));
    oldanalysisrealt = squeeze(ansMat(:,1,1));
    scatter(oldanalysisrealt,newanalysisrealt);
    xlabel('old analysis t');
    ylabel('new analysis t');
    rval = corrcoef([oldanalysisrealt,newanalysisrealt],'rows','pairwise');
    ttlstr = sprintf('T2008 new (%d) vs T 2008 old (%d) corr %.2f',...
        sum(sigfdrnew),...
        sum(sigfdrold),...
        rval(1,2));
    title(ttlstr);
    
    % a few random shuffels vs real data
    shufidx = [5 75 6 2];
    cnt = 1;
    figure;
    for i = 1:2
        
        if i ==1
            ana = 'old'; real = oldanalysisrealt; ansMatuse = ansMat;
        else
            ana = 'new'; real = newanalysisrealt; ansMatuse = ansMatOld;
        end
        for j = 1:4
            shufidxuse = shufidx(j);
            subplot(2,4,cnt); cnt = cnt + 1;
            hold on;
            histogram(real,'BinWidth',0.2);
            histogram(ansMatuse(:,shufidxuse,1),'BinWidth',0.2);
            title([ana ' analysis'])
            legend({'real','shuf'});
            ylim([0 4e3]);
            xlim([-4 8]);
        end
    end
end


