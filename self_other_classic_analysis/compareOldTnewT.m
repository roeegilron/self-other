function compareOldTnewT()
rtdir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\';
ffxResFold = fullfile(rtdir,'results_VocalDataSet_FFX_ND_norm_1000_shufs_SL27');

ff = findFilesBVQX(ffxResFold,'*results*.mat');
for i = 1:length(ff)
    [pn,fn] = fileparts(ff{i});
    load(ff{i},'ansMat','ansMatOld');
    newt = ansMat(:,1);
    oldt = ansMatOld(:,1,1);
    r= corrcoef([newt,oldt],'rows','pairwise');
    fprintf('sub %s \t R = %f\t mu1 = %f\t std1 = %f\t mu2 = %f\t std2 = %f\t\n',...
        fn(53:55),...
        r(1,2),...
        nanmean(newt),...
        nanstd(newt),...
        nanmean(oldt),...
        nanstd(oldt));
        
end
end