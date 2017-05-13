function test()
% confirm aribtrary pairing same as regular pairing" 

rootdirorig = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\';
orig = 'results_VocalDataSet_FFX_ND_norm_50_shufs_SL27';
newd = 'results_VocalDataSet_FFX_ND_norm_1shuf_SL27_differnet_pairing_just_real';

subsuse = subsUsedGet(20);
for i = 1:length(subsuse)
    % save new pariing real data with old pairing shuffle: 
    %orig file
    ff = findFilesBVQX(fullfile(rootdirorig,orig),sprintf('*_sub_%.3d*.mat',subsuse(i)));
    [pn,fn] = fileparts(ff{1});
    mfo = matfile(ff{1});
    ansMatOrig = mfo.ansMat;
    ansMatOldOrig = mfo.ansMatOld;
    locations = mfo.locations;
    mask = mfo.mask;
    %new pairting
    ff2 = findFilesBVQX(fullfile(rootdirorig,newd),sprintf('*1shuf_*_sub_%.3d*.mat',subsuse(i)));
    mfo2 = matfile(ff2{1});
    ansMat = mfo2.ansMat;
    ansMatOld = mfo2.ansMatOld;
    % plot to check
    plotsub(ansMatOrig,ansMatOldOrig,ansMat,ansMatOld,subsuse(i))
    % replace the reald data 
    ansMatOrig(:,1,:) = ansMat(:,1,:);
    ansMatOldOrig(:,1,:) = ansMatOld(:,1,:);
    clear ansMat ansMatOld
    ansMat = ansMatOrig;
    ansMatOld = ansMatOldOrig;
    save(fullfile(rootdirorig,newd,fn),...
        'ansMat','ansMatOld','locations','mask');
end
end
function plotsub(ansMatOrig,ansMatOldOrig,ansMat,ansMatOld,subname)
rt13orig = squeeze(ansMatOrig(:,1,1));
rt13npar = squeeze(ansMat(:,1,1));
rt08orig = squeeze(ansMatOldOrig(:,1,1));
rt08npar = squeeze(ansMatOld(:,1,1));
hf= figure;
hf.Position = [148         786        1412         552];
suptitle(sprintf('Sny chk T08 vs T13 sub %.3d',subname));
subplot(1,2,1)
scatter(rt13orig,rt13npar);
rv = corrcoef([rt13orig,rt13npar],'rows','pairwise');
ttlstr = sprintf('T13 p1 vs T13 p2 (corr = %.2f)',rv(1,2));
title(ttlstr)
xlabel('T13 pairing 1')
ylabel('T13 pairing 2')
subplot(1,2,2)
scatter(rt08orig,rt08npar);
rv = corrcoef([rt08orig,rt08npar],'rows','pairwise');
ttlstr = sprintf('T08 p1 vs T08 p2 (corr = %.2f)',rv(1,2));
title(ttlstr)
xlabel('T08 pairing 1')
ylabel('T08 pairing 2')
end